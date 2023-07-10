defmodule Fizzbuzz do
  def fizzbuzz_no_io(enumerable) do
    Stream.map(enumerable, &reply/1)
    |> Stream.chunk_every(5000)
    |> Enum.into([])
  end

  def reply(n) when rem(n, 15) == 0, do: <<70, 105, 122, 122, 66, 117, 122, 122, 10>>
  def reply(n) when rem(n, 3) == 0, do: <<70, 105, 122, 122, 10>>
  def reply(n) when rem(n, 5) == 0, do: <<66, 117, 122, 122, 10>>
  def reply(n), do: [Integer.to_string(n), <<10>>]
end
