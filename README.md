# While Parser CLI

This is a command line interface for the [while_parser](https://github.com/manuelmontenegro/while_parser)
library, written in Elixir.

It can be built an installed as an _escript_, which is a standalone executable that requires the [Erlang Runtime System](https://www.erlang.org/downloads) to be installed.

Usage: `while_parser_cli INPUT_FILE [-o OUTPUT_FILE] [-p]`.

```
INPUT_FILE
    File containing the input source code in While (use '-' for standard input)

-p
--pretty
    Pretty-print JSON before output

--cfg
    Return the CFG of the main statement in the program

-o [OUTPUT_FILE]
--output [OUTPUT_FILE]
    Output file name. If defaults to standard output if not given.
```

## Installation

It has been tested with Elixir 1.9.1, although it might work with earlier versions.

```
# git clone https://github.com/manuelmontenegro/while_parser_cli.git
# cd while_parser_cli
# mix escript.build
```

The commands above would generate an executable `while_parser_cli`. You can remove debug information by replacing the last line with the `escript.build` command with the following:

```
# MIX_ENV=prod mix escript.build
```

In order to install it, type the following:

```
# MIX_ENV=prod mix escript.install
```

This will install the executable in the `$HOME/.mix/escripts` directory, which should be included in the `PATH` environment variable.

