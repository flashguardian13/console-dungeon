require_relative 'attribute_set.rb'
require_relative 'inventory.rb'
require_relative 'paper_doll.rb'
require_relative 'registerable.rb'

class Actor
  include Registerable

  MODIFIER_ATTRIBUTES = {
    :strength_modifier => :strength,
    :dexterity_modifier => :dexterity,
    :constitution_modifier => :constitution,
    :intelligence_modifier => :intelligence,
    :wisdom_modifier => :wisdom,
    :charisma_modifier => :charisma
  }

  GOOD_ATTACK_BONUS_LEVELS = [:fighter_level]
  AVERAGE_ATTACK_BONUS_LEVELS = [:rogue_level, :oracle_level]
  POOR_ATTACK_BONUS_LEVELS = [:sorceror_level]

  GOOD_CASTER_LEVELS = [:sorceror_level, :oracle_level]
  POOR_CASTER_LEVELS = []

  ALL_LEVELS = [:fighter_level, :rogue_level, :oracle_level, :sorceror_level]

  def self.modifier(value)
    value / 2 - 5
  end

  def self.good_attack_bonus(level)
    level
  end

  def self.average_attack_bonus(level)
    level * 3 / 4
  end

  def self.poor_attack_bonus(level)
    level / 2
  end

  def self.good_caster_level(level)
    level
  end

  def self.poor_caster_level(level)
    level / 2
  end

  def self.level_for_experience(exp)
    level = 1
    while exp >= level * 1000
      exp -= level * 1000
      level += 1
    end
    level
  end

  def self.experience_for_level(level)
    exp = 0
    current_level = 1
    while current_level < level
      exp += current_level * 1000
      current_level += 1
    end
    exp
  end

  def self.good_hit_points(dice, die_size, con_bonus)
    dice * [die_size * 3 / 4 + con_bonus, 1].max
  end

  def self.average_hit_points(dice, die_size, con_bonus)
    dice * [die_size / 2 + con_bonus, 1].max
  end

  attr_accessor :name
  attr_reader :attributes, :paper_doll, :inventory, :actions
  attr_accessor :movement

  def initialize
    @attributes = AttributeSet.new
    @paper_doll = PaperDoll.new
    @inventory = Inventory.new
    @actions = []
    @movement = 0
  end

  def incapacitated?
    @attributes[:hit_points] < 0
  end

  def [](attribute)
    value = @attributes.fetch(attribute, 0) + @paper_doll.attributes.fetch(attribute, 0)

    if MODIFIER_ATTRIBUTES.key?(attribute)
      base_attribute = MODIFIER_ATTRIBUTES[attribute]
      value += Actor.modifier(self[base_attribute])
    end

    case attribute
    when :armor_class
      value += 10 + self[:dexterity_modifier]
    when :initiative
      value += self[:dexterity_modifier]
    when :base_attack_bonus
      good_levels = 0
      GOOD_ATTACK_BONUS_LEVELS.each { |level| good_levels += self[level] }
      value += Actor.good_attack_bonus(good_levels)

      average_levels = 0
      AVERAGE_ATTACK_BONUS_LEVELS.each { |level| average_levels += self[level] }
      value += Actor.average_attack_bonus(average_levels)

      poor_levels = 0
      POOR_ATTACK_BONUS_LEVELS.each { |level| poor_levels += self[level] }
      value += Actor.poor_attack_bonus(poor_levels)
    when :combat_maneuver_bonus
      value += self[:base_attack_bonus] + self[:strength_modifier]
    when :combat_maneuver_defense
      value += 10 + self[:base_attack_bonus] + self[:strength_modifier] + self[:dexterity_modifier]
    when :caster_level
      good_levels = 0
      GOOD_CASTER_LEVELS.each { |level| good_levels += self[level] }
      value += Actor.good_caster_level(good_levels)

      poor_levels = 0
      POOR_CASTER_LEVELS.each { |level| poor_levels += self[level] }
      value += Actor.poor_caster_level(poor_levels)
    when :hit_dice
      ALL_LEVELS.each { |level| value += self[level] }
    end

    value
  end

  def melee_attack(other, weapon, out = nil)
    out.puts "#{@name} attacks #{other.name} ..." if out

    roll = rand(1..20)
    result = roll + self[:base_attack_bonus] + self[:strength_modifier]

    if roll < 20 && (result < other[:armor_class] || roll <= 1)
      out.puts "Miss!" if out
    else
      damage = weapon.damage.roll

      if roll >= weapon.threat_range
        confirm_roll = rand(1..20)
        confirm_result = confirm_roll + self[:base_attack_bonus] + self[:strength_modifier]

        if confirm_roll >= 20 || (confirm_roll > 1 && confirm_result >= other[:armor_class])
          out.puts "Critical hit!" if out
          damage += weapon.damage.roll
        end
      end

      out.puts "#{@name} hits and deals #{damage} damage!" if out
      other.attributes[:hit_points] -= damage

      out.puts "#{other.name} is incapacitated!" if out && other.incapacitated?
    end
  end
end
