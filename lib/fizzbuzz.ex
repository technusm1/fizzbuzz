defmodule Fizzbuzz do
  def fizzbuzz_no_io(enumerable) do
    Stream.map(enumerable, &reply/1)
    |> Stream.chunk_every(5000)
    |> Enum.into([])
  end

  def reply(n) do
    case {rem(n, 3), rem(n, 5)} do
      {0, 0} -> "FizzBuzz\n"
      {0, _} -> "Fizz\n"
      {_, 0} -> "Buzz\n"
      {_, _} -> "#{n}\n"
    end
  end
end
