# Fizzbuzz in Elixir

To benchmark:
- Make sure your have Elixir installed on your system (latest edition will do).
- Checkout the project.
- Use the command `MIX_ENV=prod mix escript.build` to build the executable.
- Use the command `./fizzbuzz 1 288230376151711744 | pv > /dev/null` to benchmark. The range is large enough to give us a good sustained load.

**Current speed on my system**: 570+ MiB/s
