require_relative '../lib/equipment.rb'

describe Equipment do
  before do
    @test_equipment = Equipment.new
  end

  it 'has an equipment slot' do
    @test_equipment.slot = :ring
    expect(@test_equipment.slot).to eq(:ring)
  end

  it "cannot be assigned a slot that isn't whitelisted" do
    expect { @test_equipment.slot = :foo }.to raise_error(ArgumentError)
  end

  it 'has a set of attributes' do
    test_attributes = AttributeSet.new
    @test_equipment.attributes = test_attributes
    expect(@test_equipment.attributes).to eq(test_attributes)
  end

  it 'may have an associated action' do
    @test_equipment.action = :test_action
    expect(@test_equipment.action).to eq(:test_action)
  end
end
