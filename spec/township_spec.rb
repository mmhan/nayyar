# frozen_string_literal: true

require 'spec_helper'

describe Nayyar::Township do
  describe 'class methods' do
    describe '.all' do
      it 'should return all township' do
        all_districts = described_class.all
        expect(all_districts.length).to be > 0
        expect(all_districts.first).to be_a Nayyar::Township
      end
    end

    describe '.of_district' do
      let(:district) { Nayyar::District.find_by_pcode 'MMR001D001' }
      subject { described_class.of_district district }
      it 'return a list of districts under given district' do
        expect(subject.length).to be > 0
        expect(subject.first).to be_a Nayyar::Township
        subject.each do |township|
          expect(township.district).to eq(district)
        end
      end
    end

    describe '.find_by' do
      subject { described_class.find_by pcode: 'MMR001001' }
      it { is_expected.to be_a Nayyar::Township }
      it "returns nil if it's not found" do
        expect(described_class.find_by(pcode: 'MMR000000')).to be_nil
      end
    end

    describe '.find_by!' do
      subject { described_class.find_by! pcode: 'MMR001001' }
      it { is_expected.to be_a Nayyar::Township }
      it "raise error if it's not found" do
        expect { described_class.find_by! pcode: 'MMR000000' }.to raise_error Nayyar::TownshipNotFound
      end
    end

    let(:valid_queries) { { pcode: 'MMR001001' }  }
    let(:invalid_queries) { { pcode: 'MMR0000000' } }

    describe '.find_by_**indices**' do
      it 'returns state when it finds it' do
        valid_queries.each do |index, query|
          expect(described_class.send("find_by_#{index}", query)).to be_a Nayyar::Township
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
          expect(described_class.send("find_by_#{index}!", query)).to be_a Nayyar::Township
        end
      end
      it "raise error when it can't be found" do
        invalid_queries.each do |index, query|
          expect { described_class.send("find_by_#{index}!", query) }.to raise_error Nayyar::TownshipNotFound
        end
      end
    end
  end

  let(:township) do
    described_class.new(pcode: 'MMR001001', name: 'Myitkyina', my_name: 'မြစ်ကြီးနား', district: 'MMR001D001')
  end

  describe '#initialize' do
    it 'allows to create a township by providing hash data' do
      expect(township.data).not_to be nil
    end
  end
  describe 'attributes' do
    let(:attributes) { %i[pcode name my_name district] }
    it 'allows its attributes to be accessed by methods' do
      attributes.each do |method|
        expect(township).to respond_to method
      end
    end
    it 'allows its attributes to be accessed as keys' do
      attributes.each do |key|
        expect(township[key]).not_to be_nil
      end
    end
  end

  describe '#district' do
    subject { township.district }
    it { is_expected.to be_a Nayyar::District }
    it 'expect it to be a correct state' do
      expect(subject.pcode).to eq('MMR001D001')
    end
  end
end
