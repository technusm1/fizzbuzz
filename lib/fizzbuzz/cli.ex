defmodule Fizzbuzz.Cli do
  def main([lower, upper]) do
    {lower, upper} = {String.to_integer(lower), String.to_integer(upper)}
    chunk_size = min(div(upper - lower, System.schedulers_online), 6000)
    input_enumerable = get_input_ranges2(lower, upper, chunk_size)
    Task.async_stream(input_enumerable, fn input -> elem(GenServer.start_link(Fizzbuzz.Worker, [input]), 1) end, timeout: :infinity)
    |> Stream.map(fn {:ok, res} -> res end)
    |> Stream.each(
      fn pid ->
        GenServer.call(pid, :print)
        Process.exit(pid, :kill)
      end)
    |> Stream.run()
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

defmodule ChunkRangeStream do
	def create(range, chunk_size) do
		Stream.resource(fn -> initialize(range, chunk_size) end, &generate_next_value/1, &done/1)
	end

	defp initialize(range, chunk_size) do
		{range, chunk_size, range.first}
	end

	defp generate_next_value({range, chunk_size, lower}) do
    if lower < range.last do
      {[lower..min(lower+chunk_size, range.last)], {range, chunk_size, min(range.last, lower+chunk_size+1)}}
    else
      {:halt, {range, chunk_size, lower}}
    end
	end

	defp done(_) do
		nil
	end
end
