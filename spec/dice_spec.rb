require_relative '../lib/dice.rb'

describe Dice do
  before(:all) do
    @test_dice = Dice.from_str('2d6+3')
  end

  describe '.from_str' do
    it 'returns a correct Dice object' do
      expect(@test_dice.to_s).to eq('2d6+3')
    end
  end

  describe '#roll' do
    it 'returns a correct value' do
      expect(@test_dice).to receive(:rand).with(1..6).exactly(6).times
      allow(@test_dice).to receive(:rand).and_return(1, 2, 3, 4, 5, 6)
      expect(@test_dice.roll).to eq(6)
      expect(@test_dice.roll).to eq(10)
      expect(@test_dice.roll).to eq(14)
    end
  end
end
