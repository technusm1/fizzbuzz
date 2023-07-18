defmodule Fizzbuzz.Worker do
  @range_size 15000
  use GenServer

  def init(range_list) do
    send(self(), {:calculate, range_list})
    {:ok, []}
  end

  def handle_info({:calculate, range_list}, _state) do
    result = range_list |> Stream.map(&process_range/1) |> Enum.into([])
    {:noreply, result}
  end

  def handle_call(:print, _from, results) do
    IO.binwrite(results)
    {:reply, :ok, []}
  end

  defp process_range(range = lower.._upper) do
    res = if Range.size(range) == @range_size do
      i = lower - 1
      0..(div(@range_size, 60) - 1)
      |> Stream.map(fn j ->
        [
          Integer.to_string(15 * j + 1 + i), "\n",
          Integer.to_string(15 * j + 2 + i), "\n",
          "Fizz\n",
          Integer.to_string(15 * j + 4 + i), "\n",
          "Buzz\nFizz\n",
          Integer.to_string(15 * j + 7 + i), "\n",
          Integer.to_string(15 * j + 8 + i), "\n",
          "Fizz\nBuzz\n",
          Integer.to_string(15 * j + 11 + i), "\n",
          "Fizz\n",
          Integer.to_string(15 * j + 13 + i), "\n",
          Integer.to_string(15 * j + 14 + i), "\n",
          "FizzBuzz\n",
          Integer.to_string(15 * j + 16 + i), "\n",
          Integer.to_string(15 * j + 17 + i), "\n",
          "Fizz\n",
          Integer.to_string(15 * j + 19 + i), "\n",
          "Buzz\nFizz\n",
          Integer.to_string(15 * j + 22 + i), "\n",
          Integer.to_string(15 * j + 23 + i), "\n",
          "Fizz\nBuzz\n",
          Integer.to_string(15 * j + 26 + i), "\n",
          "Fizz\n",
          Integer.to_string(15 * j + 28 + i), "\n",
          Integer.to_string(15 * j + 29 + i), "\n",
          "FizzBuzz\n",
          Integer.to_string(15 * j + 31 + i), "\n",
          Integer.to_string(15 * j + 32 + i), "\n",
          "Fizz\n",
          Integer.to_string(15 * j + 34 + i), "\n",
          "Buzz\nFizz\n",
          Integer.to_string(15 * j + 37 + i), "\n",
          Integer.to_string(15 * j + 38 + i), "\n",
          "Fizz\nBuzz\n",
          Integer.to_string(15 * j + 41 + i), "\n",
          "Fizz\n",
          Integer.to_string(15 * j + 43 + i), "\n",
          Integer.to_string(15 * j + 44 + i), "\n",
          "FizzBuzz\n",
          Integer.to_string(15 * j + 46 + i), "\n",
          Integer.to_string(15 * j + 47 + i), "\n",
          "Fizz\n",
          Integer.to_string(15 * j + 49 + i), "\n",
          "Buzz\nFizz\n",
          Integer.to_string(15 * j + 52 + i), "\n",
          Integer.to_string(15 * j + 53 + i), "\n",
          "Fizz\nBuzz\n",
          Integer.to_string(15 * j + 56 + i), "\n",
          "Fizz\n",
          Integer.to_string(15 * j + 58 + i), "\n",
          Integer.to_string(15 * j + 59 + i), "\n",
          "FizzBuzz\n"
        ]
      end)
      |> Stream.chunk_every(div(@range_size, 60) + 50)
      |> Enum.into([])
    else
      Fizzbuzz.fizzbuzz_no_io(range)
    end
    :erlang.iolist_to_binary(res)
  end
end
