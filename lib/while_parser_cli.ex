defmodule WhileParserCli do
  @moduledoc """
    Command line interface for `while_parser` package.

    See [https://github.com/manuelmontenegro/while_parser] for more details.
  """

  @cli_options [
    strict: [
      pretty: :boolean,
      output: :string
    ],
    aliases: [
      p: :pretty,
      o: :output
    ]
  ]

  @defaults [pretty: false, output: :stdout]

  @usage """
  Usage: while_parser_cli INPUT_FILE [-o OUTPUT_FILE] [-p]

    INPUT_FILE
        File containing the input source code in While (use '-' for standard input)

    -p
    --pretty
        Pretty-print JSON before output

    -o [OUTPUT_FILE]
    --output [OUTPUT_FILE]
        Output file name. If defaults to standard output if not given.
  """

  def main(args) do
    with {:ok, opts} <- parse_options(args),
         {:ok, input_str} <- read_input_file(opts.input),
         {:ok, json} <- WhileParser.parse_to_json(input_str, pretty: opts.pretty),
         :ok <- write_output_file(json, opts.output) do
    else
      {:error, {:invalid_params, msg}} ->
        IO.puts("ERROR: #{msg}")
        IO.puts(@usage)
      {:error, err} when err in [:enoent, :eacces, :eisdir, :enotdir, :enomem] ->
        IO.puts("Error: #{:file.format_error(err)}")
      _ ->
        IO.puts(:stderr, "Unexpected result")
    end
  end

  defp parse_options(args) do
    case OptionParser.parse(args, @cli_options) do
      {_, _, [{opt, _} | _]} ->
        {:error, {:invalid_params, "Invalid option: #{opt}"}}

      {_, [], []} ->
        {:error, {:invalid_params, "Missing input file name"}}

      {_, [_, _ | _], []} ->
        {:error, {:invalid_params, "Too many input file names"}}

      {opts, [input], []} ->
        {:ok,
         @defaults
         |> Keyword.merge(opts)
         |> Enum.into(%{})
         |> Map.put(:input, translate_input_parameter(input))}
    end
  end

  defp translate_input_parameter("-"), do: :stdin
  defp translate_input_parameter(other), do: other


  defp read_input_file(:stdin) do
    case IO.read(:stdio, :all) do
      {:error, _} = err -> err
      data -> {:ok, data}
    end
  end

  defp read_input_file(other) do
    File.read(other)
  end

  defp write_output_file(output, :stdout) do
    IO.puts output
  end

  defp write_output_file(output, file) do
    File.write(file, output)
  end
end
