defmodule KargerSpec do
  use ESpec

  context "simple graph" do

    describe "filter graph" do
      let(:graph) do
        [{2,1}, {1,4}, {3,2}, {2,4}, {4,3}, {1,1}, {2,2}]
      end

      let(:filtered) do
        [{1,2}, {1,4}, {2,3}, {2,4}, {3,4}]
      end

      it "should filter" do
        expect(Karger.filter(graph)).to eq(filtered)
      end

      context "contract" do
        it do
          Karger.contract(filtered)
        end
      end
    end

    describe "prepare_graph" do
      let(:matrix) do
        [
          [1, 2, 4],
          [2, 1, 3, 4],
          [3, 2, 4],
          [4, 1, 2, 3]
        ]
      end

      let :graph, do: Karger.prepare_graph(matrix)
      it do: expect(graph).to eq([{1,2}, {1,4}, {2,3}, {2,4}, {3,4}])
    end
  end

  context "read file" do
    before do
      {:ok, data} = File.read("spec/data/kargerMinCut.txt")
      matrix = String.split(data, "\r\n")
      |> Enum.reverse |> tl |> Enum.reverse
      |> Enum.map(fn(string) ->
        String.split(string, "\t")
        |> Enum.map(&(String.to_integer(&1)))
      end)
      {:ok, matrix: matrix}
    end

    context "create graph" do
      before do
        graph = Karger.prepare_graph(shared.matrix)
        results = (1..200)
        |> Enum.map(fn(i) ->
          Task.async(fn -> length(Karger.contract(graph)) end)
        end)
        |> Enum.map(&Task.await(&1, :infinity))
        {:ok, results: results}
      end

      it "check result" do
        expect(shared.results).to have_size(200)
        expect(Enum.min(shared.results)).to eq(17)
      end
    end
  end
end
