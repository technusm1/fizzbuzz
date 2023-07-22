defmodule Fizzbuzz.Cli do
  @range_size 15000
  def main([lower, upper]) do
    {lower, upper} = {String.to_integer(lower), String.to_integer(upper)}
    chunk_size = min(div(upper - lower, System.schedulers_online()), @range_size)
    # {:ok, io_device} = :file.open("/dev/stdout", [:append, {:delayed_write, Size, Delay}])
    port = :erlang.open_port({:fd, 0, 1}, [:binary, :out])

    if chunk_size == @range_size do
      # We'll divide the input range into 3 parts: beginning, 6k ranges and ending
      # beginning and ending will be processed before and after stream.run respectively.
      input_lower =
        case rem(lower, 15) do
          1 -> lower

          0 ->
            # IO.binwrite("FizzBuzz\n")
            send(port, {self(), {:command, "FizzBuzz\n"}})
            lower + 1

          remainder ->
            # IO.binwrite(Fizzbuzz.fizzbuzz_no_io(lower..(15 - remainder + lower)))
            send(port, {self(), {:command, Fizzbuzz.fizzbuzz_no_io(lower..(15 - remainder + lower))}})
            15 - remainder + lower + 1
        end

      input_upper =
        case rem(upper - input_lower + 1, @range_size) do
          0 -> upper
          remainder -> upper - remainder
        end

      input_enumerable = Chunk6kStream.create(input_lower..input_upper)

      Task.async_stream(
        input_enumerable |> Stream.chunk_every(400),
        fn input -> elem(GenServer.start_link(Fizzbuzz.Worker, input), 1) end,
        timeout: :infinity
      )
      |> Stream.map(fn {:ok, res} -> res end)
      |> Stream.each(fn pid ->
        # GenServer.call(pid, {:print, io_device})
        send(port, {self(), {:connect, pid}})
        GenServer.call(pid, {:print, port})
        Process.exit(pid, :kill)
      end)
      |> Stream.run()

      if input_upper < upper do
        IO.binwrite(Fizzbuzz.fizzbuzz_no_io(input_upper+1..upper))
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
        # GenServer.call(pid, {:print, io_device})
        send(port, {self(), {:connect, pid}})
        GenServer.call(pid, {:print, port})
        Process.exit(pid, :kill)
      end)
      |> Stream.run()
    end

    send(port, {self(), :close})
    # :file.close(io_device)
  end

  def main(_), do: IO.puts("Usage: fizzbuzz 1 10000")

  defp wait_for_process_to_finish(pid) do
    if Process.alive?(pid) do
      Process.sleep(100)
      wait_for_process_to_finish(pid)
    end
  end

  defp get_input_ranges2(lower, upper, chunk_size) do
    # Need to make this streamable
    if chunk_size >= 10 do
      ChunkRangeStream.create(lower..upper, chunk_size)
    else
      [lower..upper]
    end
  end
end

defmodule Chunk6kStream do
  @range_size 15000
  # Make sure that range has size of multiples of 6000 and range.first is divisible by 15
  def create(range) do
    Stream.resource(fn -> initialize(range) end, &generate_next_value/1, &done/1)
  end

  defp initialize(range) do
    {range, range.first - 1, range.last}
  end

  defp generate_next_value({range, upper, upper}) do
    {:halt, {range, upper, upper}}
  end

  defp generate_next_value({range, lower, upper}) do
    {[(lower + 1)..(lower + @range_size)], {range, lower + @range_size, upper}}
  end

  defp done(_) do
    nil
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
