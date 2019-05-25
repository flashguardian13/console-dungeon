require_relative '../lib/weapon.rb'

describe Weapon do
  before(:all) do
    @test_die_code = Dice.from_str('1d6')
    @test_weapon = Weapon.new
    @test_weapon.set_damage(@test_die_code)
    @test_weapon.set_threat_range(19)
  end

  it 'has a damage die code' do
    expect(@test_weapon.damage).to eq(@test_die_code)
  end

  it 'has a threat range' do
    expect(@test_weapon.threat_range).to eq(19)
  end
end
