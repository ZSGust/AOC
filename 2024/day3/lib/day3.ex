defmodule Day3_Part1 do
  def part1() do
    total =
      File.stream!("lib/input.txt")
      |> Stream.flat_map(fn line ->
        Regex.scan(~r/mul\((\d{1,3}),(\d{1,3})\)/, line)
        |> Enum.map(fn [_, x_str, y_str] ->
          x = String.to_integer(x_str)
          y = String.to_integer(y_str)
          x * y
        end)
      end)
      |> Enum.sum()

    IO.puts("Total sum of multiplications: #{total}")
  end
end

defmodule Day3_Part2 do
  def calculate_total do
    content = File.read!("lib/input.txt")
    total = process_content(content, 0, :enabled)
    IO.puts("Total sum of multiplications: #{total}")
  end

  defp process_content(<<"do()"::binary, rest::binary>>, acc, _state) do
    process_content(rest, acc, :enabled)
  end

  defp process_content(<<"don't()"::binary, rest::binary>>, acc, _state) do
    process_content(rest, acc, :disabled)
  end

  defp process_content(<<"mul(", rest::binary>>, acc, state) do
    case parse_mul_args(rest) do
      {:ok, x, y, rest_after_mul} ->
        new_acc = if state == :enabled, do: acc + x * y, else: acc
        process_content(rest_after_mul, new_acc, state)

      :error ->
        process_content(rest, acc, state)
    end
  end

  defp process_content(<<_char::utf8, rest::binary>>, acc, state) do
    process_content(rest, acc, state)
  end

  defp process_content(<<>>, acc, _state) do
    acc
  end

  defp parse_mul_args(rest) do
    with {:ok, x_str, rest1} <- parse_number(rest),
         <<","::utf8, rest2::binary>> <- rest1,
         {:ok, y_str, rest3} <- parse_number(rest2),
         <<")"::utf8, rest_after_mul::binary>> <- rest3,
         x = String.to_integer(x_str),
         y = String.to_integer(y_str) do
      {:ok, x, y, rest_after_mul}
    else
      _ -> :error
    end
  end

  defp parse_number(binary) do
    parse_digits(binary, "", 0)
  end

  defp parse_digits(<<char::utf8, rest::binary>>, acc, count) when char in ?0..?9 and count < 3 do
    parse_digits(rest, acc <> <<char>>, count + 1)
  end

  defp parse_digits(binary, acc, _count) when acc != "" do
    {:ok, acc, binary}
  end

  defp parse_digits(_binary, _acc, _count) do
    :error
  end
end

Day3_Part2.calculate_total()
