defmodule Fizzbuzz.Worker do
  @compile {:inline, process_range: 1}
  @range_size 600000
  use GenServer

  def init(range_list) do
    {:ok, nil, {:continue, {:calculate, range_list}}}
  end

  def handle_continue({:calculate, range_list}, _state) do
    result = range_list |> Stream.map(&process_range/1) |> Enum.into([])
    {:noreply, result}
  end

  def handle_call({:print, port}, {pid, _}, results) do
    send(port, {self(), {:command, results}})
    send(port, {self(), {:connect, pid}})
    {:reply, :ok, []}
  end

  defp process_range(range = lower.._upper) do
    if Range.size(range) == @range_size do
      i = lower - 1
      0..(div(@range_size, 2400) - 1)
      |> Stream.map(fn j ->
        for x <- 0..(2400 - 1)//150 do
          [Integer.to_string(2400 * j + 1 + x + i), "\n", Integer.to_string(2400 * j + 2 + x + i), "\n", "Fizz\n", Integer.to_string(2400 * j + 4 + x + i), "\n", "Buzz\nFizz\n", Integer.to_string(2400 * j + 7 + x + i), "\n", Integer.to_string(2400 * j + 8 + x + i), "\n", "Fizz\nBuzz\n", Integer.to_string(2400 * j + 11 + x + i), "\n", "Fizz\n", Integer.to_string(2400 * j + 13 + x + i), "\n", Integer.to_string(2400 * j + 14 + x + i), "\n", "FizzBuzz\n", Integer.to_string(2400 * j + 16 + x + i), "\n", Integer.to_string(2400 * j + 17 + x + i), "\n", "Fizz\n", Integer.to_string(2400 * j + 19 + x + i), "\n", "Buzz\nFizz\n", Integer.to_string(2400 * j + 22 + x + i), "\n", Integer.to_string(2400 * j + 23 + x + i), "\n", "Fizz\nBuzz\n", Integer.to_string(2400 * j + 26 + x + i), "\n", "Fizz\n", Integer.to_string(2400 * j + 28 + x + i), "\n", Integer.to_string(2400 * j + 29 + x + i), "\n", "FizzBuzz\n", Integer.to_string(2400 * j + 31 + x + i), "\n", Integer.to_string(2400 * j + 32 + x + i), "\n", "Fizz\n", Integer.to_string(2400 * j + 34 + x + i), "\n", "Buzz\nFizz\n", Integer.to_string(2400 * j + 37 + x + i), "\n", Integer.to_string(2400 * j + 38 + x + i), "\n", "Fizz\nBuzz\n", Integer.to_string(2400 * j + 41 + x + i), "\n", "Fizz\n", Integer.to_string(2400 * j + 43 + x + i), "\n", Integer.to_string(2400 * j + 44 + x + i), "\n", "FizzBuzz\n", Integer.to_string(2400 * j + 46 + x + i), "\n", Integer.to_string(2400 * j + 47 + x + i), "\n", "Fizz\n", Integer.to_string(2400 * j + 49 + x + i), "\n", "Buzz\nFizz\n", Integer.to_string(2400 * j + 52 + x + i), "\n", Integer.to_string(2400 * j + 53 + x + i), "\n", "Fizz\nBuzz\n", Integer.to_string(2400 * j + 56 + x + i), "\n", "Fizz\n", Integer.to_string(2400 * j + 58 + x + i), "\n", Integer.to_string(2400 * j + 59 + x + i), "\n", "FizzBuzz\n", Integer.to_string(2400 * j + 61 + x + i), "\n", Integer.to_string(2400 * j + 62 + x + i), "\n", "Fizz\n", Integer.to_string(2400 * j + 64 + x + i), "\n", "Buzz\nFizz\n", Integer.to_string(2400 * j + 67 + x + i), "\n", Integer.to_string(2400 * j + 68 + x + i), "\n", "Fizz\nBuzz\n", Integer.to_string(2400 * j + 71 + x + i), "\n", "Fizz\n", Integer.to_string(2400 * j + 73 + x + i), "\n", Integer.to_string(2400 * j + 74 + x + i), "\n", "FizzBuzz\n", Integer.to_string(2400 * j + 76 + x + i), "\n", Integer.to_string(2400 * j + 77 + x + i), "\n", "Fizz\n", Integer.to_string(2400 * j + 79 + x + i), "\n", "Buzz\nFizz\n", Integer.to_string(2400 * j + 82 + x + i), "\n", Integer.to_string(2400 * j + 83 + x + i), "\n", "Fizz\nBuzz\n", Integer.to_string(2400 * j + 86 + x + i), "\n", "Fizz\n", Integer.to_string(2400 * j + 88 + x + i), "\n", Integer.to_string(2400 * j + 89 + x + i), "\n", "FizzBuzz\n", Integer.to_string(2400 * j + 91 + x + i), "\n", Integer.to_string(2400 * j + 92 + x + i), "\n", "Fizz\n", Integer.to_string(2400 * j + 94 + x + i), "\n", "Buzz\nFizz\n", Integer.to_string(2400 * j + 97 + x + i), "\n", Integer.to_string(2400 * j + 98 + x + i), "\n", "Fizz\nBuzz\n", Integer.to_string(2400 * j + 101 + x + i), "\n", "Fizz\n", Integer.to_string(2400 * j + 103 + x + i), "\n", Integer.to_string(2400 * j + 104 + x + i), "\n", "FizzBuzz\n", Integer.to_string(2400 * j + 106 + x + i), "\n", Integer.to_string(2400 * j + 107 + x + i), "\n", "Fizz\n", Integer.to_string(2400 * j + 109 + x + i), "\n", "Buzz\nFizz\n", Integer.to_string(2400 * j + 112 + x + i), "\n", Integer.to_string(2400 * j + 113 + x + i), "\n", "Fizz\nBuzz\n", Integer.to_string(2400 * j + 116 + x + i), "\n", "Fizz\n", Integer.to_string(2400 * j + 118 + x + i), "\n", Integer.to_string(2400 * j + 119 + x + i), "\n", "FizzBuzz\n", Integer.to_string(2400 * j + 121 + x + i), "\n", Integer.to_string(2400 * j + 122 + x + i), "\n", "Fizz\n", Integer.to_string(2400 * j + 124 + x + i), "\n", "Buzz\nFizz\n", Integer.to_string(2400 * j + 127 + x + i), "\n", Integer.to_string(2400 * j + 128 + x + i), "\n", "Fizz\nBuzz\n", Integer.to_string(2400 * j + 131 + x + i), "\n", "Fizz\n", Integer.to_string(2400 * j + 133 + x + i), "\n", Integer.to_string(2400 * j + 134 + x + i), "\n", "FizzBuzz\n", Integer.to_string(2400 * j + 136 + x + i), "\n", Integer.to_string(2400 * j + 137 + x + i), "\n", "Fizz\n", Integer.to_string(2400 * j + 139 + x + i), "\n", "Buzz\nFizz\n", Integer.to_string(2400 * j + 142 + x + i), "\n", Integer.to_string(2400 * j + 143 + x + i), "\n", "Fizz\nBuzz\n", Integer.to_string(2400 * j + 146 + x + i), "\n", "Fizz\n", Integer.to_string(2400 * j + 148 + x + i), "\n", Integer.to_string(2400 * j + 149 + x + i), "\n", "FizzBuzz\n"]
        end
        |> :erlang.iolist_to_binary
      end)
      |> Stream.chunk_every(div(@range_size, 2400) + 50)
      |> Enum.into([])
    else
      Fizzbuzz.fizzbuzz_no_io(range)
    end
  end
end
