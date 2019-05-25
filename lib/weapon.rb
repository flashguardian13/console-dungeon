require_relative 'equipment.rb'

class Weapon < Equipment
  attr_reader :damage, :threat_range

  def set_damage(dice)
    @damage = dice
  end

  def set_threat_range(range)
    @threat_range = range
  end
end
