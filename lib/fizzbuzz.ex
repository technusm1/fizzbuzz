defmodule Fizzbuzz do
  def fizzbuzz_no_io(enumerable) do
    Stream.map(enumerable, &reply/1)
    |> Stream.chunk_every(5000)
    |> Enum.into([])
  end

  def reply(n) do
    result = case {rem(n, 3), rem(n, 5)} do
      {0, 0} -> "FizzBuzz"
      {0, _} -> "Fizz"
      {_, 0} -> "Buzz"
      {_, _} -> Integer.to_string(n)
    end
    [result, "\n"]
  end
end
