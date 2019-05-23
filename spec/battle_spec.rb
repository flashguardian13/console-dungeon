require_relative '../lib/battle.rb'

describe Battle do
  before(:all) do
    @hero1 = Actor.new
    @hero1.id = :hero1

    @hero2 = Actor.new
    @hero2.id = :hero2

    @enemy1 = Actor.new
    @enemy1.id = :enemy1

    @enemy2 = Actor.new
    @enemy2.id = :enemy2

    @rogue1 = Actor.new
    @rogue1.id = :rogue1

    @rogue2 = Actor.new
    @rogue2.id = :rogue2

    [@hero1, @hero2, @enemy1, @enemy2, @rogue1, @rogue2].each do |actor|
      actor.attributes[:hit_points] = 1
      ObjectRegistry.actors.add(actor)
    end
  end

  after(:all) do
    ObjectRegistry.actors.clear
  end

  before do
    @test_battle = Battle.new

    @test_battle.add_to_team(@hero1.id, :heroes)
    @test_battle.add_to_team(@hero2.id, :heroes)

    @test_battle.add_to_team(@enemy1.id, :enemies)
    @test_battle.add_to_team(@enemy2.id, :enemies)

    @test_battle.add_to_team(@rogue1.id, :rogues)
    @test_battle.add_to_team(@rogue2.id, :rogues)
  end

  after do
    @test_battle.clear
  end

  it 'has one or more actors on one or more teams' do
    expect(@test_battle.get_team(:heroes)).to match_array([@hero1, @hero2])
    expect(@test_battle.get_team(:enemies)).to match_array([@enemy1, @enemy2])
    expect(@test_battle.get_team(:rogues)).to match_array([@rogue1, @rogue2])
  end

  describe '#status' do
    before do
      [@hero1, @hero2, @enemy1, @enemy2, @rogue1, @rogue2].each do |actor|
        actor.attributes[:hit_points] = 1
      end
    end

    context 'when at least one hero and one non-hero are still active' do
      it 'says fight is still active' do
        @hero1.attributes[:hit_points] = -1
        @enemy2.attributes[:hit_points] = -1
        expect(@test_battle.status).to eq(:active)
      end
    end

    context 'when all heroes are incapacitated' do
      context 'but at least one hero has escaped' do
        it 'says fight ended in retreat' do
          @hero1.attributes[:hit_points] = -1
          @test_battle.remove(@hero2.id)
          expect(@test_battle.status).to eq(:retreat)
        end
      end

      context 'and no heroes have escaped' do
        it 'says fight ended in defeat' do
          @hero1.attributes[:hit_points] = -1
          @hero2.attributes[:hit_points] = -1
          expect(@test_battle.status).to eq(:defeat)
        end
      end
    end

    context 'when all non-heroes are incapacitated' do
      it 'says fight ended in victory' do
        @enemy1.attributes[:hit_points] = -1
        @enemy2.attributes[:hit_points] = -1
        @rogue1.attributes[:hit_points] = -1
        @rogue2.attributes[:hit_points] = -1
        expect(@test_battle.status).to eq(:victory)
      end
    end
  end

  describe '#has_actor?' do
    it 'returns true only if the battle includes the actor' do
      expect(@test_battle.has_actor?(@hero1.id)).to be true
      expect(@test_battle.has_actor?(:nonexistent_actor)).to be false
    end
  end

  it 'can build action menus for actors' do
    @test_battle.action_menu_for(@hero1)
  end

  it 'can build targeting menus for actors and actions' do
  end

  it 'can generate a random turn order' do
  end
end
