# Fizzbuzz in Elixir

Inspired from the following CodeGolf thread: https://codegolf.stackexchange.com/questions/215216/high-throughput-fizz-buzz/236630#236630

To benchmark:
- Make sure your have Elixir installed on your system (latest edition will do).
- Checkout the project.
- Use the command `MIX_ENV=prod mix escript.build` to build the executable.
- Use the command `./fizzbuzz 1 288230376151711744 | pv > /dev/null` to benchmark. The range is large enough to give us a good sustained load.

**Current speed on my system**: 570+ MiB/s
