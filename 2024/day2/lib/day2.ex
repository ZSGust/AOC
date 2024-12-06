defmodule Day2 do
  def parse_row(row) do
    row
    |> String.trim()
    |> String.split(~r/\s+/)
    |> Enum.map(&String.to_integer/1)
  end

  def safe_jumpity?(row) do
    if is_row_safe(row) do
      true
    else
      row_length = length(row)

      Enum.any?(0..(row_length - 1), fn index ->
        new_row = List.delete_at(row, index)
        is_row_safe(new_row)
      end)
    end
  end

  defp is_row_safe(row) do
    check_monotonicity(row, :increasing) or check_monotonicity(row, :decreasing)
  end

  defp check_monotonicity(row, direction) do
    Enum.reduce_while(Enum.chunk_every(row, 2, 1, :discard), true, fn [a, b], _acc ->
      diff = b - a

      is_valid_jump =
        case direction do
          :increasing -> a < b and diff <= 3 and diff > 0
          :decreasing -> a > b and diff >= -3 and diff < 0
        end

      if is_valid_jump do
        {:cont, true}
      else
        {:halt, false}
      end
    end)
  end

  def count_safe_rows(rows) do
    Enum.reduce(rows, 0, fn row, acc ->
      if safe_jumpity?(row) do
        acc + 1
      else
        acc
      end
    end)
  end
end

da_mighty_map =
  File.stream!("lib/input.txt")
  |> Stream.map(&Day2.parse_row/1)
  |> Enum.to_list()

safe_row_count = Day2.count_safe_rows(da_mighty_map)

IO.inspect(safe_row_count, label: "Number of Safe Rows")
