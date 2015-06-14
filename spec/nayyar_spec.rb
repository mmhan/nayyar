require 'spec_helper'

describe Nayyar do

  it 'has a version number' do
    expect(Nayyar::VERSION).not_to be nil
  end

	describe ".states" do
		subject { described_class.states }
		it { is_expected.to be_an Array }
		it "contains hashes of state data" do
			expect(subject.first).to be_a Nayyar::State
			expect(subject.size).to be > 1
		end
	end

	describe ".state_with_pcode" do
		subject { described_class.state_with_pcode("MMR001") }
		it { is_expected.to be_a Nayyar::State }
		it "will return nil if state is not found" do
			expect(described_class.state_with_pcode("FOOBAR")).to be_nil
		end
	end
end

describe Nayyar::State do
	let(:state) do
		described_class.new( pcode: "MMR000",
			name: "Fake State",
			iso: "MM-00"
		)
	end
	describe "#initialize" do
		it "allows to create a state by providing hash data" do
			expect(state.data).not_to be nil
		end
	end
	describe "attributes" do
		let(:attributes) { [:iso, :pcode, :name] }
		it "allows its attributes to be accessed by methods" do
			attributes.each do |method|
				expect(state).to respond_to method
			end
		end
		it "allows its attributes to be accessed as keys" do
			attributes.each do |key|
				expect(state[key]).not_to be_nil
			end
		end
	end
end