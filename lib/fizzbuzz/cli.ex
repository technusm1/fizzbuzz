defmodule Fizzbuzz.Cli do
  @range_size 600000
  def main([lower, upper]) do
    {lower, upper} = {String.to_integer(lower), String.to_integer(upper)}
    chunk_size = min(div(upper - lower, System.schedulers_online()), @range_size)
    port = :erlang.open_port({:fd, 0, 1}, [:binary, :out])

    if chunk_size == @range_size do
      # We'll divide the input range into 3 parts: beginning, 6k ranges and ending
      # beginning and ending will be processed before and after stream.run respectively.
      input_lower =
        case rem(lower, 15) do
          1 -> lower

          0 ->
            send(port, {self(), {:command, "FizzBuzz\n"}})
            lower + 1

          remainder ->
            send(port, {self(), {:command, Fizzbuzz.fizzbuzz_no_io(lower..(15 - remainder + lower))}})
            15 - remainder + lower + 1
        end

      input_upper =
        case rem(upper - input_lower + 1, @range_size) do
          0 -> upper
          remainder -> upper - remainder
        end

      input_enumerable = New6kStream.create(input_lower..input_upper)

      Task.async_stream(
        input_enumerable,
        fn input -> elem(GenServer.start_link(Fizzbuzz.Worker, [input]), 1) end,
        timeout: :infinity
      )
      |> Stream.map(fn {:ok, res} -> res end)
      |> Stream.each(fn pid ->
        send(port, {self(), {:connect, pid}})
        GenServer.call(pid, {:print, port})
        Process.exit(pid, :kill)
      end)
      |> Stream.run()

      if input_upper < upper do
        send(port, {self(), {:command, Fizzbuzz.fizzbuzz_no_io(input_upper+1..upper)}})
      end
    else
      input_enumerable = get_input_ranges2(lower, upper, chunk_size)

      Task.async_stream(
        input_enumerable,
        fn input -> elem(GenServer.start_link(Fizzbuzz.Worker, [input]), 1) end,
        timeout: :infinity
      )
      |> Stream.map(fn {:ok, res} -> res end)
      |> Stream.each(fn pid ->
        send(port, {self(), {:connect, pid}})
        GenServer.call(pid, {:print, port})
        Process.exit(pid, :kill)
      end)
      |> Stream.run()
    end

    send(port, {self(), :close})
  end

  def main(_), do: IO.puts("Usage: fizzbuzz 1 10000")

  defp get_input_ranges2(lower, upper, chunk_size) do
    # Need to make this streamable
    if chunk_size >= 10 do
      ChunkRangeStream.create(lower..upper, chunk_size)
    else
      [lower..upper]
    end
  end
end

defmodule New6kStream do
  @range_size 600000

  def create(lower..upper) do
    end_range = (upper + 1)..(upper + @range_size)
    Stream.unfold(lower..(lower + @range_size - 1), fn
      ^end_range -> nil
       n -> {n, n.last + 1..(n.last + @range_size)}
    end)
  end
end

defmodule ChunkRangeStream do
  def create(range, chunk_size) do
    Stream.resource(fn -> initialize(range, chunk_size) end, &generate_next_value/1, &done/1)
  end

  defp initialize(range, chunk_size) do
    {range, chunk_size, range.first}
  end

  defp generate_next_value({range, chunk_size, lower}) do
    if lower < range.last do
      {[lower..min(lower + chunk_size, range.last)],
       {range, chunk_size, min(range.last, lower + chunk_size + 1)}}
    else
      {:halt, {range, chunk_size, lower}}
    end
  end

  defp done(_) do
    nil
  end
end
