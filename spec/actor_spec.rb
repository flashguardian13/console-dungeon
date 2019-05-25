require_relative '../lib/actor.rb'

describe Actor do
  before(:all) do
    @test_actor = Actor.new
    @test_actor.name = 'Anonymous Bosh'
    @test_actor.id = :test_actor_id
    @test_actor.movement = 2
  end

  it 'has an id' do
    expect(@test_actor.id).to eq(:test_actor_id)
  end

  it 'has a name' do
    expect(@test_actor.name).to eq('Anonymous Bosh')
  end

  it 'has a base set of attributes' do
    expect(@test_actor.attributes).to be_instance_of(AttributeSet)
  end

  it 'has a paper doll' do
    expect(@test_actor.paper_doll).to be_instance_of(PaperDoll)
  end

  it 'has an inventory' do
    expect(@test_actor.inventory).to be_instance_of(Inventory)
  end

  it 'has a list of actions' do
    expect(@test_actor.actions).to be_instance_of(Array)
  end

  it 'is incapacitated when health is below zero' do
    @test_actor.attributes[:hit_points] = 1
    expect(@test_actor).not_to be_incapacitated
    @test_actor.attributes[:hit_points] = 0
    expect(@test_actor).not_to be_incapacitated
    @test_actor.attributes[:hit_points] = -1
    expect(@test_actor).to be_incapacitated
  end

  it 'can perform some actions each round' do
    expect(@test_actor.movement).to eq(2)
  end

  describe '.modifier' do
    it 'returns the modifier for an attribute' do
      [
        [2, -4], [3, -4], [4, -3], [5, -3], [6, -2], [7, -2],
        [8, -1], [9, -1], [10, 0], [11, 0], [12, 1], [13, 1],
        [14, 2], [15, 2], [16, 3], [17, 3], [18, 4], [19, 4],
        [20, 5]
      ].each do |attribute, modifier|
        expect(Actor.modifier(attribute)).to eq(modifier)
      end
    end
  end

  describe '.good_attack_bonus' do
    it 'returns the correct attack bonus' do
      (0..12).each { |level| expect(Actor.good_attack_bonus(level)).to eq(level) }
    end
  end

  describe '.average_attack_bonus' do
    it 'returns the correct attack bonus' do
      [
        [0, 0], [1, 0], [2, 1], [3, 2], [4, 3], [5, 3],
        [6, 4], [7, 5], [8, 6], [9, 6], [10, 7], [11, 8],
        [12, 9]
      ].each { |level, bonus| expect(Actor.average_attack_bonus(level)).to eq(bonus) }
    end
  end

  describe '.poor_attack_bonus' do
    it 'returns the correct attack bonus' do
      [
        [0, 0], [1, 0], [2, 1], [3, 1], [4, 2], [5, 2],
        [6, 3], [7, 3], [8, 4], [9, 4], [10, 5], [11, 5],
        [12, 6]
      ].each { |level, bonus| expect(Actor.poor_attack_bonus(level)).to eq(bonus) }
    end
  end

  describe '.good_caster_level' do
    it 'returns the correct attack bonus' do
      (0..12).each { |level| expect(Actor.good_caster_level(level)).to eq(level) }
    end
  end

  describe '.poor_caster_level' do
    it 'returns the correct attack bonus' do
      [
        [0, 0], [1, 0], [2, 1], [3, 1], [4, 2], [5, 2],
        [6, 3], [7, 3], [8, 4], [9, 4], [10, 5], [11, 5],
        [12, 6]
      ].each { |level, bonus| expect(Actor.poor_caster_level(level)).to eq(bonus) }
    end
  end

  describe '.level_for_experience' do
    it 'returns the level earned by the given amount of experience' do
      [
        [-1, 1], [0, 1], [9, 1], [99, 1], [999, 1],
        [1000, 2], [3000, 3], [6000, 4], [10000, 5], [15000, 6], [21000, 7],
        [28000, 8], [36000, 9], [45000, 10], [55000, 11], [66000, 12], [78000, 13],
        [91000, 14]
      ].each { |exp, level| expect(Actor.level_for_experience(exp)).to eq(level) }
    end
  end

  describe '.experience_for_level' do
    it 'returns the experience required to attain the given level' do
      (1..20).each do |level|
        exp = Actor.experience_for_level(level)
        expect(Actor.level_for_experience(exp)).to eq(level)
      end
    end
  end

  describe '.good_hit_points' do
    it 'returns the correct amount of hit points' do
      [
        [1, 4, 5, 8],
        [1, 6, 4, 8],
        [1, 8, 3, 9],
        [1, 10, 2, 9],
        [1, 12, 1, 10],
        [2, 4, 5, 16],
        [4, 6, 4, 32],
        [8, 8, 3, 72],
        [16, 10, 2, 144],
        [32, 12, 1, 320],
        [20, 4, 0, 60],
        [20, 4, -1, 40],
        [20, 4, -2, 20],
        [20, 4, -3, 20],
        [20, 4, -4, 20]
      ].each do |hit_dice, hit_die_size, con_mod, expected|
        expect(Actor.good_hit_points(hit_dice, hit_die_size, con_mod)).to eq(expected)
      end
    end
  end

  describe '.average_hit_points' do
    it 'returns the correct amount of hit points' do
      [
        [1, 4, 5, 7],
        [1, 6, 4, 7],
        [1, 8, 3, 7],
        [1, 10, 2, 7],
        [1, 12, 1, 7],
        [2, 4, 5, 14],
        [4, 6, 4, 28],
        [8, 8, 3, 56],
        [16, 10, 2, 112],
        [32, 12, 1, 224],
        [20, 4, 0, 40],
        [20, 4, -1, 20],
        [20, 4, -2, 20],
        [20, 4, -3, 20],
        [20, 4, -4, 20]
      ].each do |hit_dice, hit_die_size, con_mod, expected|
        expect(Actor.average_hit_points(hit_dice, hit_die_size, con_mod)).to eq(expected)
      end
    end
  end

  it 'has a variety of attributes' do
    attr_actor = Actor.new

    attr_actor.attributes[:strength] = 8
    attr_actor.attributes[:dexterity] = 9
    attr_actor.attributes[:constitution] = 14
    attr_actor.attributes[:intelligence] = 7
    attr_actor.attributes[:wisdom] = 12
    attr_actor.attributes[:charisma] = 13

    attr_actor.attributes[:fighter_level] = 3
    attr_actor.attributes[:rogue_level] = 3
    attr_actor.attributes[:sorceror_level] = 3

    attr_actor.attributes[:experience] = Actor.experience_for_level(9)
    attr_actor.attributes[:max_hit_points] = Actor.good_hit_points(3, 10, 2) + Actor.good_hit_points(3, 8, 2) + Actor.good_hit_points(3, 6, 2)

    expect(attr_actor[:strength]).to eq(8)
    expect(attr_actor[:dexterity]).to eq(9)
    expect(attr_actor[:constitution]).to eq(14)
    expect(attr_actor[:intelligence]).to eq(7)
    expect(attr_actor[:wisdom]).to eq(12)
    expect(attr_actor[:charisma]).to eq(13)

    expect(attr_actor[:fighter_level]).to eq(3)
    expect(attr_actor[:rogue_level]).to eq(3)
    expect(attr_actor[:sorceror_level]).to eq(3)
    expect(attr_actor[:oracle_level]).to eq(0)
    expect(attr_actor[:experience]).to eq(36000)

    expect(attr_actor[:strength_modifier]).to eq(-1)
    expect(attr_actor[:dexterity_modifier]).to eq(-1)
    expect(attr_actor[:constitution_modifier]).to eq(2)
    expect(attr_actor[:intelligence_modifier]).to eq(-2)
    expect(attr_actor[:wisdom_modifier]).to eq(1)
    expect(attr_actor[:charisma_modifier]).to eq(1)

    expect(attr_actor[:armor_class]).to eq(9)

    expect(attr_actor[:initiative]).to eq(-1)

    expect(attr_actor[:base_attack_bonus]).to eq(6)
    expect(attr_actor[:combat_maneuver_bonus]).to eq(5)
    expect(attr_actor[:combat_maneuver_defense]).to eq(14)

    expect(attr_actor[:caster_level]).to eq(3)
    expect(attr_actor[:hit_dice]).to eq(9)

    expect(attr_actor[:max_hit_points]).to eq(69)
  end

  describe '#melee_attack' do
    before do
      @attacker = Actor.new

      @target = Actor.new
      @target.attributes[:hit_points] = 1

      @weapon = Weapon.new
      @weapon.set_damage(Dice.from_str('1d6'))
      @weapon.set_threat_range(20)
    end

    it 'always misses on a natural 1' do
      @attacker.attributes[:fighter_level] = 30
      allow(@attacker).to receive(:rand).and_return(1)
      expect { @attacker.melee_attack(@target, @weapon) }.not_to change { @target[:hit_points] }
    end

    it 'always hits on a natural 20' do
      @attacker.attributes[:fighter_level] = 0
      @target.attributes[:dexterity] = 40
      allow(@attacker).to receive(:rand).and_return(20)
      expect { @attacker.melee_attack(@target, @weapon) }.to change { @target[:hit_points] }
    end
  end
end
