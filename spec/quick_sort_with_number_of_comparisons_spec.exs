defmodule QuickSortWithNumberOfComparisonsSpec do
  use ESpec

  describe ".pivot_and_rest" do
    let :array, do: [1,4,3,2,5,6]
    it "get first" do
      {pivot, rest} = QuickSortWithNumberOfComparisons.pivot_and_rest(array, :first)
      expect(pivot).to eq(1)
      expect(rest).to eq([4,3,2,5,6])
    end

    it "get last" do
      {pivot, rest} = QuickSortWithNumberOfComparisons.pivot_and_rest(array, :last)
      expect(pivot).to eq(6)
      expect(rest).to eq([1,4,3,2,5])
    end

    it "get median" do
      {pivot, rest} = QuickSortWithNumberOfComparisons.pivot_and_rest(array, :median)
      expect(pivot).to eq(3)
      expect(rest).to eq([1,4,2,5,6])

      {pivot, rest} = QuickSortWithNumberOfComparisons.pivot_and_rest([5,4,3,2,1], :median)
      expect(pivot).to eq(3)
      expect(rest).to eq([5,4,2,1])
    end
  end


  context "simple arrays" do
    it "checks simple array" do
      {sorted, number} = QuickSortWithNumberOfComparisons.sort([1, 2])
      {sorted, number} |> should eq {[1,2], 1}
    end

    it "checks simple array" do
      {sorted, number} = QuickSortWithNumberOfComparisons.sort([2,3,1])
      {sorted, number} |> should eq {[1,2,3], 2}
    end

    it "checks simple array" do
      {sorted, number} = QuickSortWithNumberOfComparisons.sort([3,2,1])
      {sorted, number} |> should eq {[1,2,3], 3}
    end

    it "checks simple array" do
      {sorted, number} = QuickSortWithNumberOfComparisons.sort([3,4,5,2,1])
      {sorted, number} |> should eq {[1,2,3,4,5], 6}
    end
  end

  context "quick_sort.txt array" do
    before do
      {:ok, data} = File.read("spec/data/quick_sort.txt")
      {:ok, array: String.split(data) |> Enum.map(&String.to_integer(&1))}
    end

    subject do: QuickSortWithNumberOfComparisons.sort(shared[:array])
    it do: is_expected.to eq({Enum.into(1..10000, []), 157946})
  end
end
