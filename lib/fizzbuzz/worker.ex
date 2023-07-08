defmodule Fizzbuzz.Worker do
  use GenServer

  def init([range]) do
    send(self(), {:calculate, range})
    {:ok, []}
  end

  def handle_info({:calculate, range}, _state) do
    res = Fizzbuzz.fizzbuzz_no_io(range)
    {:noreply, res}
  end

  def handle_call(:print, _from, results) do
    results |> Enum.into(IO.binstream)
    {:reply, :ok, []}
  end
end
