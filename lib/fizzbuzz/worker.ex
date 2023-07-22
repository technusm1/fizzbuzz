defmodule Fizzbuzz.Worker do
  @range_size 15000
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
    res = if Range.size(range) == @range_size do
      i = lower - 1
      0..(div(@range_size, 15) - 1)
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
          "FizzBuzz\n"
        ]
      end)
      |> Stream.chunk_every(div(@range_size, 15) + 50)
      |> Enum.into([])
    else
      Fizzbuzz.fizzbuzz_no_io(range)
    end
    :erlang.iolist_to_binary(res)
  end
end
