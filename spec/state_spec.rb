# frozen_string_literal: true

require 'spec_helper'

describe Nayyar::State do
  describe 'class methods' do
    let(:valid_queries) { %w[pcode iso alpha3].zip(%w[MMR001 MM-01 YGN]).to_h }
    let(:invalid_queries) { %w[pcode iso alpha3].zip(%w[FOOBAR MM-00 ABC]).to_h }

    describe '.all' do
      subject { described_class.all }
      it { is_expected.to be_an Array }
      it 'contains hashes of state data' do
        expect(subject.first).to be_a Nayyar::State
        expect(subject.size).to be > 1
      end
    end

    describe '.find_by' do
      it 'returns state when it finds it' do
        valid_queries.each do |index, query|
          expect(described_class.find_by(index => query)).to be_a Nayyar::State
        end
      end
      it 'will return nil if state is not found' do
        invalid_queries.each do |index, query|
          expect(described_class.find_by(index => query)).to be_nil
        end
      end
      it 'will raise ArgumentError if no argument is provided' do
        expect { described_class.find_by }.to raise_error ArgumentError
      end
      it 'will raise ArgumentError if wrong argument is provided' do
        expect { described_class.find_by(foo: :bar) }.to raise_error ArgumentError
      end
    end

    describe '.find_by!' do
      subject { described_class.find_by!(pcode: 'MMR001') }
      it { is_expected.to be_a Nayyar::State }
      it "will raise error if the state isn't found" do
        expect { described_class.find_by!(pcode: 'FOOBAR') }.to raise_error Nayyar::StateNotFound
      end
    end

    describe '.find_by_**indices**' do
      it 'returns state when it finds it' do
        valid_queries.each do |index, query|
          expect(described_class.send("find_by_#{index}", query)).to be_a Nayyar::State
        end
      end
      it "returns nil when it can't be found" do
        invalid_queries.each do |index, query|
          expect(described_class.send("find_by_#{index}", query)).to be_nil
        end
      end
    end

    describe '.find_by_**indices**!' do
      it 'returns state when it finds it' do
        valid_queries.each do |index, query|
          expect(described_class.send("find_by_#{index}!", query)).to be_a Nayyar::State
        end
      end
      it "raise error when it can't be found" do
        invalid_queries.each do |index, query|
          expect { described_class.send("find_by_#{index}!", query) }.to raise_error Nayyar::StateNotFound
        end
      end
    end
  end

  let(:state) do
    described_class.new(pcode: 'MMR000',
                        name: 'Fake State',
                        my_name: 'ပြည်နယ်အတု',
                        iso: 'MM-00',
                        alpha3: 'FKE')
  end
  describe '#initialize' do
    it 'allows to create a state by providing hash data' do
      expect(state.data).not_to be nil
    end
  end
  describe 'attributes' do
    let(:attributes) { %i[iso pcode name my_name alpha3] }
    it 'allows its attributes to be accessed by methods' do
      attributes.each do |method|
        expect(state).to respond_to method
      end
    end
    it 'allows its attributes to be accessed as keys' do
      attributes.each do |key|
        expect(state[key]).not_to be_nil
      end
    end
  end

  describe '#districts' do
    let(:state) { Nayyar::State.find_by_pcode 'MMR001' }
    subject { state.districts }
    it 'return a list of districts under given state' do
      expect(subject.length).to be > 0
      expect(subject.first).to be_a Nayyar::District
      subject.each do |district|
        expect(district.state.pcode).to eq(state.pcode)
      end
    end
  end
end
