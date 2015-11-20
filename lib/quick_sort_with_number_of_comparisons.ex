defmodule QuickSortWithNumberOfComparisons do
  def sort(array) when length(array) > 1 do
    {pivot, rest} = pivot_and_rest(array, :first)
    {left, right} = split(pivot, rest)
    {sorted_left, number_left} = sort(left)
    {sorted_right, number_right} = sort(right)
    {sorted_left ++ [pivot] ++ sorted_right, number_left + number_right + length(rest)}
  end

  def sort(array), do: {array, 0}

  def split(pivot, rest), do: do_split(pivot, rest, {[], []})

  def pivot_and_rest(array, :first) do
    [pivot | rest] = array
    {pivot, rest}
  end

  def pivot_and_rest(array, :last) do
    [pivot | rest] = Enum.reverse(array)
    {pivot, Enum.reverse(rest)}
  end

  def pivot_and_rest(array, :median) do
    first = hd(array)
    last = hd(Enum.reverse(array))
    medium = Enum.at(array, div(length(array)-1, 2))
    median = get_median(first, last, medium)
    rest = Enum.reject(array, &(&1 == median))
    {median, rest}
  end

  defp get_median(a, b, c) do
    Enum.sort([a,b,c])
    |> tl |> hd
  end

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
