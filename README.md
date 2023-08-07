# Fizzbuzz in Elixir

Inspired from the following CodeGolf thread for High-throughput Fizzbuzz: https://codegolf.stackexchange.com/questions/215216/high-throughput-fizz-buzz/236630#236630

## Background
Fizz Buzz is a common challenge given during interviews. The challenge goes something like this:

> Write a program that prints the numbers from 1 to n. If a number is divisible by 3, write Fizz instead. If a number is divisible by 5, write Buzz instead. However, if the number is divisible by both 3 and 5, write FizzBuzz instead.

The goal of this question is to write a FizzBuzz implementation that goes from 1 to infinity (or some arbitrary very very large number), and that implementation should do it as fast as possible.

To benchmark:
- Make sure your have Elixir installed on your system (latest edition will do).
- Checkout the project.
- Use the command `MIX_ENV=prod mix escript.build` to build the executable.
- Use the command `./fizzbuzz 1 288230376151711744 | pv > /dev/null` to benchmark. This range of numbers is large enough to give us a good sustained load.

**Current speed on my system**: 570+ MiB/s
