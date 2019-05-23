require_relative '../lib/paper_doll.rb'

describe PaperDoll do
  before(:all) do
    strength_buff = AttributeSet.new
    strength_buff[:strength] = 4

    ring_of_strength = Equipment.new
    ring_of_strength.id = :ring_of_strength
    ring_of_strength.slot = :ring
    ring_of_strength.attributes = strength_buff
    ObjectRegistry.items.add(ring_of_strength)

    intelligence_buff = AttributeSet.new
    intelligence_buff[:intelligence] = 2

    ring_of_intelligence = Equipment.new
    ring_of_intelligence.id = :ring_of_intelligence
    ring_of_intelligence.slot = :ring
    ring_of_intelligence.attributes = intelligence_buff
    ObjectRegistry.items.add(ring_of_intelligence)
  end

  after(:all) do
    ObjectRegistry.items.clear
  end

  before do
    @test_paper_doll = PaperDoll.new
  end

  after do
    @test_paper_doll.clear_slots
  end

  it 'has one or more equipment slots' do
    @test_paper_doll.add_slots(:ring, :ring)
    expect(@test_paper_doll.slots.map { |s| s.slot }).to match_array([:ring, :ring])
    @test_paper_doll.add_slots(:neck)
    expect(@test_paper_doll.slots.map { |s| s.slot }).to match_array([:ring, :ring, :neck])
    @test_paper_doll.remove_slots(:ring)
    expect(@test_paper_doll.slots.map { |s| s.slot }).to match_array([:ring, :neck])
    @test_paper_doll.clear_slots
    expect(@test_paper_doll.slots).to be_empty
  end

  it 'can roll up the attributes of all equipped items' do
    @test_paper_doll.add_slots(:ring, :ring)
    @test_paper_doll.equip(:ring_of_strength)
    @test_paper_doll.equip(:ring_of_intelligence)
    all_buffs = @test_paper_doll.attributes
    expect(all_buffs[:strength]).to eq(4)
    expect(all_buffs[:intelligence]).to eq(2)
  end

  it 'raises an error when unable to equip something due to no empty slots' do
    expect { @test_paper_doll.equip(:ring_of_strength) }.to raise_error(EquipmentError)
  end
end