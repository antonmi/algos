defmodule QuickSortSpec do
  use ESpec

  context "simple array" do
    let :array, do: [8,5,7,6,4,2,3,1]
		subject do: QuickSort.sort(array)

		it do: is_expected.to eq([1,2,3,4,5,6,7,8])
  end

  describe "split" do
    let :array, do: [8,7,6,4,2,3,1]
    it "splits array" do
      {less, more} = QuickSort.split(5, array)
      less |> should eq [4,2,3,1]
      more |> should eq [8,7,6]
    end
  end

  context "big array" do
    before do
      {:ok, data} = File.read("spec/data/big_array.txt")
      {:ok, big_array: String.split(data) |> Enum.map(&String.to_integer(&1))}
    end

    subject do: QuickSort.sort(shared[:big_array])
    it do: is_expected.to eq(Enum.into(1..100000, []))
  end
end
