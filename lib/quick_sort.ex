defmodule QuickSort do
  def sort(array) when length(array) > 1 do
    [pivot | rest] = array
    {left, right} = split(pivot, rest)
    sort(left) ++ [pivot] ++ sort(right)
  end

  def sort(array), do: array

  def split(pivot, rest), do: do_split(pivot, rest, {[], []})

  defp do_split(pivot, [hd | tl], {left, right}) when hd <= pivot do
    do_split(pivot, tl, {[hd | left], right})
  end

  defp do_split(pivot, [hd | tl], {left, right}) do
    do_split(pivot, tl, {left, [hd | right]})
  end

  defp do_split(pivot, [], {left, right}) do
    {Enum.reverse(left), Enum.reverse(right)}
  end
end
