defmodule InversionsCountSpec do
  use ESpec

  context "simple array" do
    let :array, do: [1,3,5,2,4,6]
    subject do: InversionsCount.count(array)
    it do: is_expected.to eq(3)

    it "checks more arrays" do
      InversionsCount.count([2,1]) |> should eq 1
      InversionsCount.count([3,2,1]) |> should eq 3
      InversionsCount.count([1,2,3,4,5,6,7,8]) |> should eq 0
      InversionsCount.count([1,2,3,4,5,6,8,7]) |> should eq 1
      InversionsCount.count([9,1,2,3,4,5,6,7,8]) |> should eq 8
    end

    describe "count_inv" do
      def count(l, r), do: InversionsCount.count_inv(l, r)

      it "counts inversions" do
        count([1], []) |> should eq 0
        count([], [2]) |> should eq 0
        count([1], [2]) |> should eq 0
        count([2], [1]) |> should eq 1
        count([1,3,5], [2,4,6]) |> should eq 3
        count([1,2,3,9], [4,5,6,7,8]) |> should eq 5
      end
    end
  end

  context "big array" do
    before do
      {:ok, data} = File.read("spec/data/big_array.txt")
      {:ok, big_array: String.split(data) |> Enum.map(&String.to_integer(&1))}
    end

    subject do: InversionsCount.count(shared[:big_array])

    it do: is_expected.to eq 2407905288
  end
end
