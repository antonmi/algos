defmodule SCCSpec do
  use ESpec

  describe SCC.VisitedSet do
    before do
      SCC.VisitedSet.start
      SCC.VisitedSet.visit(1)
      SCC.VisitedSet.visit(2)
    end

    finally do: SCC.VisitedSet.stop

    it do: expect SCC.VisitedSet.visited?(1) |> to be true
    context "visit next" do
      before do: SCC.VisitedSet.visit(2)
      it do: expect SCC.VisitedSet.visited?(2) |> to be true
      it do: expect SCC.VisitedSet.visited?(3) |> to be false

      context "reset" do
        before do: SCC.VisitedSet.reset
        it do: expect SCC.VisitedSet.visited?(1) |> to be false
      end
    end
  end

  describe FinishTimes do
    before do
      SCC.FinishTimes.start
      SCC.FinishTimes.set(1, 20)
    end

    finally do: SCC.FinishTimes.stop

    it do: expect SCC.FinishTimes.get(1) |> to eq 20
  end

  describe LeaderSet do
    before do
      SCC.LeaderSet.start
      SCC.LeaderSet.add(1, 1)
      SCC.LeaderSet.add(1, 2)
      SCC.LeaderSet.add(5, 6)
    end

    finally do: SCC.LeaderSet.stop

    it do: expect SCC.LeaderSet.get(1) |> to eq 2
    it do: expect SCC.LeaderSet.get(5) |> to eq 1
    it do: expect SCC.LeaderSet.leaders |> to eq [1,5]
  end

  context "small graph" do
    before do
      graph = [{7,1}, {1,4}, {4,7}, {9,7}, {6,9}, {9,3},
        {3,6}, {8,6}, {2,8}, {5,2}, {8,5}]
      SCC.Graph.init(graph)
      SCC.Graph.calc_all_ways_to
    end

    it do: SCC.Graph.max |> should eq 9
    it do: SCC.Graph.ways_to(7) |> should eq [4, 9]
    it do: SCC.Graph.ways_to(6) |> should eq [3, 8]

    describe "fill_times" do
      before do
        SCC.Graph.calc_all_ways_to
        SCC.find_times
        SCC.Graph.set(SCC.Graph.times_graph)
      end
      it do: expect SCC.Graph.get |> to eq [{9, 7}, {7, 8}, {8, 9}, {6, 9}, {5, 6}, {6, 1}, {1, 5}, {4, 5}, {3, 4}, {2, 3}, {4, 2}]

      context "cal_ways_from" do
        before do: SCC.Graph.calc_all_ways_from
        it do: SCC.Graph.ways_from(6) |> should eq [9, 1]
        it do: SCC.Graph.ways_from(4) |> should eq [5, 2]
      end

      describe "find_scc" do
        before do
          SCC.Graph.calc_all_ways_from
          SCC.find_scc
        end

        it "checks LeaderSet" do
          expect Enum.sort(SCC.LeaderSet.leaders) |> to eq [4, 6, 9]
          expect SCC.LeaderSet.get(9) |> to eq 3
          expect SCC.LeaderSet.get(6) |> to eq 3
          expect SCC.LeaderSet.get(4) |> to eq 3
        end
      end
    end

  end

  context "extra large graph" do
    before do
      IO.inspect("Start loading")
      {:ok, data} = File.read("spec/data/SCC.txt")
      IO.inspect("File has been read")
      data = String.split(data)
      IO.inspect("splitted")
      data = Enum.chunk(data, 2)
      IO.inspect("chunked")
      graph = Enum.map(data, fn([l, r]) ->
        {String.to_integer(l), String.to_integer(r)}
      end)
      IO.inspect("Finish loading")
      SCC.Graph.init(graph)
    end

    it do: SCC.Graph.max |> should eq 875714

    describe "fill_times" do
      before do
        IO.inspect("calc_all_ways_to")
        SCC.Graph.calc_all_ways_to
        IO.inspect("find_times")
        SCC.find_times
        IO.inspect("build times_graph")
        SCC.Graph.set(SCC.Graph.times_graph)
      end

      describe "find_scc" do
        before do
          IO.inspect("calc_all_ways_from")
          SCC.Graph.calc_all_ways_from
          IO.inspect("find_scc")
          SCC.find_scc
        end

        let(:the_answer) do
          SCC.LeaderSet.leaders
          |> Enum.map(&SCC.LeaderSet.get(&1))
          |> Enum.sort |> Enum.reverse
          |> Enum.chunk(5) |> List.first
        end

        # The final solution
        it do: expect the_answer |> to eq [434821, 968, 459, 313, 211]
      end
    end
  end
end
