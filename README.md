# Fizzbuzz in Elixir

To benchmark:
- Make sure your have Elixir installed on your system (latest edition will do).
- Checkout the project.
- Use the command `MIX_ENV=prod mix escript.build` to build the executable.
- Use the command `./fizzbuzz 1 288230376151711744 | pv > /dev/null` to benchmark. The range is large enough to give us a good sustained load.

**Current speed on my system**: 450-500 MiB/s

## Known issues
- The results are not completely printed on terminal. For e.g. running the command `./fizzbuzz 1 2882303` doesn't properly show the complete results on terminal. However, directing the output to a file shows the results properly, which means there's probably an issue of results not being flushed properly somewhere. This is being investigated.
