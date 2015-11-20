defmodule InversionsCount do
  def count(array) when length(array) > 1 do
    {left, right} = Enum.split(array, div(length(array), 2))
    left_right = count(left) + count(right)
    left_right + count_inv(MergeSort.sort(left), MergeSort.sort(right))
  end

  def count(array) when length(array) == 1, do: 0

  def count_inv(left, right), do: do_count_inv(left, right, 0)

  defp do_count_inv([hl | tl], [hr | tr], acc) when hl <= hr do
    do_count_inv(tl, [hr | tr], acc)
  end

  defp do_count_inv([hl | tl], [_hr | tr], acc) do
    do_count_inv([hl | tl], tr, acc + length([hl | tl]))
  end

  defp do_count_inv(_, _, acc), do: acc
end
