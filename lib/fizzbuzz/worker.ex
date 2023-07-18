defmodule Fizzbuzz.Worker do
  @range_size 12000
  use GenServer

  def init(range_list) do
    # IO.inspect(range_list)
    send(self(), {:calculate, range_list})
    {:ok, []}
  end

  def handle_info({:calculate, range_list}, _state) do
    result =
      range_list
      |> Enum.map(&process_range/1)
    {:noreply, result}
  end

  def handle_call(:print, _from, results) do
    IO.binwrite(results)
    {:reply, :ok, []}
  end

  defp process_range(range) do
    res = if Range.size(range) == @range_size do
      i = range.first - 1
      0..(div(@range_size, 15) -1)
      |> Stream.map(fn j ->
        [[Integer.to_string(15 * j + 1 + i), "\n"], [Integer.to_string(15 * j + 2 + i), "\n"], "Fizz\n", [Integer.to_string(15 * j + 4 + i), "\n"], "Buzz\nFizz\n", [Integer.to_string(15 * j + 7 + i), "\n"], [Integer.to_string(15 * j + 8 + i), "\n"], "Fizz\nBuzz\n", [Integer.to_string(15 * j + 11 + i), "\n"], "Fizz\n", [Integer.to_string(15 * j + 13 + i), "\n"], [Integer.to_string(15 * j + 14 + i), "\n"], "FizzBuzz\n"]
      end)
      |> Stream.chunk_every(400)
      |> Enum.into([])
    else
      Fizzbuzz.fizzbuzz_no_io(range)
    end
    :erlang.iolist_to_binary(res)
  end
end
