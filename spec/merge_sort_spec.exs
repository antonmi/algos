defmodule MergeSortSpec do
	use ESpec

	context "simple array" do
		let :array, do: [8,5,7,6,4,2,3,1]
		subject do: MergeSort.sort(array)

		it do: is_expected.to eq([1,2,3,4,5,6,7,8])

		context "merge" do
			let :left, do: [1,3,5]
			let :right, do: [2,4,6]

			it "merge" do
				MergeSort.merge([1], []) |> should eq([1])
				MergeSort.merge([], [2]) |> should eq([2])
				MergeSort.merge([1,3], [2]) |> should eq([1,2,3])
				MergeSort.merge(left, right) |> should eq([1,2,3,4,5,6])
				MergeSort.merge([1, 2, 3, 4], [5, 6, 7, 8]) |> should eq([1,2,3,4,5,6,7,8])
			end
		end
	end

	context "big array" do
		before do
			{:ok, data} = File.read("spec/data/big_array.txt")
			{:ok, big_array: String.split(data) |> Enum.map(&String.to_integer(&1))}
		end

		subject do: MergeSort.sort(shared[:big_array])
		it do: is_expected.to eq(Enum.into(1..100000, []))
	end
end
