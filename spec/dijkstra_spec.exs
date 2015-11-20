defmodule DijkstraSpec do
  use ESpec

  context "small graph" do
    let :graph do
      [
        {:s, :v, 1},
        {:s, :w, 4},
        {:v, :w, 2},
        {:v, :t, 6},
        {:w, :t, 3},
      ]
    end

    let :dict_graph, do: Dijkstra.dict_representation(graph)

    context "check dict representation" do
      it do: expect Dict.get(dict_graph, :s) |> to eq [{:w, 4}, {:v, 1}]
      it do: expect Dict.get(dict_graph, :v) |> to eq [{:t, 6}, {:w, 2}, {:s, 1}]
      it do: expect Dict.get(dict_graph, :w) |> to eq [{:t, 3}, {:v, 2}, {:s, 4}]
      it do: expect Dict.get(dict_graph, :t) |> to eq [{:w, 3}, {:v, 6}]
    end

    # describe "min_edge" do
    #   it do: expect Dijkstra.min_edge([:s], dict_graph) |> to eq {:s, :v, 1}
    #   it do: expect Dijkstra.min_edge([:s, :v], dict_graph) |> to eq {:v, :w, 2}
    #   it do: expect Dijkstra.min_edge([:s, :v, :w], dict_graph) |> to eq {:w, :t, 3}
    #   it do: expect Dijkstra.min_edge([:s, :v, :w, :t], dict_graph) |> to eq false
    # end

    describe "shortest_path" do
      let :res, do: Dijkstra.shortest_path(dict_graph, :s)
      it do: expect Dict.get(res, :s) |> to eq(0)
      it do: expect Dict.get(res, :v) |> to eq(1)
      it do: expect Dict.get(res, :w) |> to eq(3)
      it do: expect Dict.get(res, :t) |> to eq(6)
    end
  end

  context "another graph" do
    let :graph do
      [
        {1, 2, 7},
        {1, 3, 9},
        {1, 6, 14},
        {2, 3, 10},
        {2, 4, 15},
        {3, 6, 2},
        {3, 4, 11},
        {6, 5, 9},
        {5, 4, 6},
      ]
    end

    let :dict_graph, do: Dijkstra.dict_representation(graph)
    describe "shortest_path" do
      let :res, do: Dijkstra.shortest_path(dict_graph, 1)
      it do: IO.inspect(res)
      it do: expect Dict.get(res, 1) |> to eq(0)
      it do: expect Dict.get(res, 2) |> to eq(7)
      it do: expect Dict.get(res, 3) |> to eq(9)
      it do: expect Dict.get(res, 4) |> to eq(20)
      it do: expect Dict.get(res, 5) |> to eq(20)
      it do: expect Dict.get(res, 6) |> to eq(11)
    end
  end

  context "Large graph" do
    before do
      {:ok, data} = File.read("spec/data/dijkstraData.txt")
      matrix = String.split(data, "\r\n")
      |> Enum.filter(&String.length(&1) > 0)
      |> Enum.map(fn(row) ->
        String.split(row, "\t")
        |>  Enum.filter(&String.length(&1) > 0)
      end)

      res = Enum.map(matrix, fn(row) ->
        [h | t] = row
        Enum.reduce(t, [], fn(el, acc) ->
          [r, w] = String.split(el, ",")
          edge = {String.to_integer(h), String.to_integer(r), String.to_integer(w)}
          [edge | acc]
        end)
      end)
      {:shared, graph: List.flatten(res) }
    end

    let :dict_graph, do: Dijkstra.dict_representation(shared.graph)
    let :list, do: Dijkstra.build_list(dict_graph, [1])

    describe "shortest_path" do
      let :vertices, do: [7,37,59,82,99,115,133,165,188,197]
      let :res, do: Dijkstra.shortest_path(dict_graph, 1)

      it "checks path" do
        expect Enum.map(vertices, &Dict.get(res, &1)) |> to eq [2599, 2610, 2947, 2052, 2367, 2399, 2029, 2442, 2505, 3068]
      end

    end
  end
end
