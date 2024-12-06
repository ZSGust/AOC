defmodule Day1 do
  def process_file(file_path) do
    file_path
    |> Path.expand()
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.reduce({[], []}, fn line, {left_acc, right_acc} ->
      [left, right] = String.split(line, ~r/\s+/, trim: true)
      {[String.to_integer(left) | left_acc], [String.to_integer(right) | right_acc]}
    end)
    |> then(fn {left_column, right_column} ->
      {
        Enum.sort(Enum.reverse(left_column)),
        Enum.sort(Enum.reverse(right_column))
      }
    end)
  end

  def count_and_sum(left_list, right_list) do
    frequencies = Enum.frequencies(right_list)

    left_list
    |> Enum.map(fn left ->
      occurrence_count = Map.get(frequencies, left, 0)
      left * occurrence_count
    end)
    |> Enum.sum()
  end
end

{left_sorted, right_sorted} = Day1.process_file("~/projects/AOC/2024/day1/lib/input.text")

differences =
  Enum.zip(left_sorted, right_sorted)
  |> Enum.map(fn {left, right} -> Kernel.abs(right - left) end)
  |> Enum.sum()

IO.inspect(differences, label: "Differences")
total_sum = Day1.count_and_sum(left_sorted, right_sorted)

IO.inspect(total_sum, label: "Total Sum")
