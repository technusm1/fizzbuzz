# Fizzbuzz in Elixir

To benchmark:
- Make sure your have Elixir installed on your system (latest edition will do).
- Checkout the project.
- Use the command `MIX_ENV=prod mix escript.build` to build the executable.
- Use the command `./fizzbuzz 1 1000000000 | pv > /dev/null` to benchmark.

**Current speed on my system**: 175 MiB/s