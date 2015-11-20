defmodule Dijkstra do

  def shortest_path(graph, origin) do
    dict = Dict.put(HashDict.new, origin, 0)
    build_list(graph, [origin], dict)
  end

  def build_list(graph, list, dict) do
    case min_edge(list, graph, dict) do
      {from, to, w} ->
        weigth = Dict.get(dict, from)
        new_dict = Dict.put(dict, to, weigth + w)
        build_list(graph, [to | list], new_dict)
      false -> dict
    end
  end

  def min_edge(list, graph, dict) do
    ways = Enum.map(list, fn(v) ->
      Dict.get(graph, v, [])
      |> Enum.map(fn {to, w} -> {v, to, w} end)
      |> Enum.filter(fn {_v, vert, _w} ->
        !Enum.member?(list, vert)
      end)
    end)
    |> List.flatten
    if length(ways) > 0 do
      Enum.min_by(ways, fn {vv, _v, w} -> Dict.get(dict, vv) + w end)
    else
      false
    end
  end

  def dict_representation(graph) do
    do_dict_representation(graph, HashDict.new)
  end

  defp do_dict_representation([], dict), do: dict

  defp do_dict_representation(graph, dict) do
    [edge | rest] = graph
    {l, r, w} = edge
    l_edges = Dict.get(dict, l, [])
    r_edges = Dict.get(dict, r, [])
    new_dict = dict
    |> Dict.put(l, [{r,w} | l_edges])
    |> Dict.put(r, [{l,w} | r_edges])

    do_dict_representation(rest, new_dict)
  end
end
