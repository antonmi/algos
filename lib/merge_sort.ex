defmodule MergeSort do
  def sort(array) when length(array) > 1 do
    {left, right} = Enum.split(array, div(length(array), 2))
    merge(sort(left), sort(right))
  end

  def sort(array), do: array

  def merge(left, right), do: Enum.reverse(do_merge(left, right, []))

  defp do_merge([hl | tl], [hr | tr], acc) when hl <= hr do
    do_merge(tl, [hr | tr], [hl | acc])
  end

  defp do_merge([hl | tl], [hr | tr], acc) do
    do_merge([hl | tl], tr, [hr | acc])
  end

  defp do_merge([], r, acc), do: Enum.reverse(r) ++ acc
  defp do_merge(l, [], acc), do: Enum.reverse(l) ++ acc
end
