require_relative '../lib/action_template.rb'

describe ActionTemplate do
  before do
    @escape_action_template = ActionTemplate.new

    @escape_action_template.name = 'Escape'
    @escape_action_template.id = :escape
    @escape_action_template.move_cost = 2

    @escape_action_template.caller = :context
    @escape_action_template.method = :remove
    @escape_action_template.args = [:actor]

    @actor = Actor.new
    @actor.movement = 2

    @actor_without_moves = Actor.new
    @actor_without_moves.movement = 1

    @battle = Battle.new
  end

  it 'has a name' do
    expect(@escape_action_template.name).to eq('Escape')
  end

  it 'has an id' do
    expect(@escape_action_template.id).to eq(:escape)
  end

  it 'has a movement cost' do
    expect(@escape_action_template.move_cost).to eq(2)
  end

  it 'has a method caller' do
    expect(@escape_action_template.caller).to eq(:context)
  end

  it 'has a method' do
    expect(@escape_action_template.method).to eq(:remove)
  end

  it 'has one or more args' do
    expect(@escape_action_template.args).to eq([:actor])
  end

  describe '#possible?' do
    it 'returns true if the actor can perform the action' do
      expect(@escape_action_template.possible?(@actor, @battle)).to be true
    end

    it 'returns false if the actor cannot perform the action' do
      expect(@escape_action_template.possible?(@actor_without_moves, @battle)).to be false
    end
  end

  describe '#populate' do
    it 'expects an actor and a situational context' do
      expect { @escape_action_template.populate(@actor, @battle) }.not_to raise_error
    end

    it 'returns an action' do
      result = @escape_action_template.populate(@actor, @battle)
      expect(result).to be_instance_of(Action)
      expect(result.caller).to eq(@battle)
      expect(result.args).to eq([@actor.id])
    end

    it 'deducts any movement cost from the actor' do
      @escape_action_template.populate(@actor, @battle)
      expect(@actor.movement).to eq(0)
    end
  end
end
