defmodule Karger do
  def filter(graph) do
    graph
    |> Enum.filter(fn({l, r}) -> r != l end)
    |> Enum.map(fn({l, r}) ->
      if l > r, do: {r, l}, else: {l, r}
    end)
  end

  def contract(graph) do
    :random.seed(:os.timestamp)
    graph = filter(graph)
    if length(Enum.uniq(graph)) == 1 do
      graph
    else
      rand = :random.uniform(length(graph)) - 1
      {left, right} = Enum.at(graph, rand)
      graph = Enum.map(graph, fn({l, r}) ->
        if r == right, do: r = left
        if l == right, do: l = left
        {l, r}
      end)
      contract(graph)
    end
  end

  def prepare_graph(matrix) do
    matrix
    |> Enum.reduce([], fn(row, acc) ->
      left = hd(row)
      list = Enum.reduce(tl(row), [], fn(el, a) ->
        el = if left <= el, do: {left, el}, else: {el, left}
        [el | a]
      end)
      acc ++ list
    end)
    |> Enum.uniq
    |> Enum.sort
  end
end
