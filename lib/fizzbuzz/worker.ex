defmodule Fizzbuzz.Worker do
  use GenServer

  def init([range]) do
    send(self(), {:calculate, range})
    {:ok, []}
  end

  def handle_info({:calculate, range}, _state) do
    res = if Range.size(range) == 6000 do
      i = range.first - 1
      0..(400-1)
      |> Stream.map(fn j ->
        [[Integer.to_string(15 * j + 1 + i), "\n"], [Integer.to_string(15 * j + 2 + i), "\n"], "Fizz\n", [Integer.to_string(15 * j + 4 + i), "\n"], "Buzz\nFizz\n", [Integer.to_string(15 * j + 7 + i), "\n"], [Integer.to_string(15 * j + 8 + i), "\n"], "Fizz\nBuzz\n", [Integer.to_string(15 * j + 11 + i), "\n"], "Fizz\n", [Integer.to_string(15 * j + 13 + i), "\n"], [Integer.to_string(15 * j + 14 + i), "\n"], "FizzBuzz\n"]
      end)
      |> Stream.chunk_every(400)
      |> Enum.into([])
    else
      Fizzbuzz.fizzbuzz_no_io(range)
    end

    {:noreply, res |> :erlang.iolist_to_binary}
  end

  def handle_call(:print, _from, results) do
    IO.binwrite(results)
    {:reply, :ok, []}
  end
end
