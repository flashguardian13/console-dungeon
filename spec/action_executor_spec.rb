require_relative '../lib/action_executor.rb'

describe ActionExecutor do
  before do
    @escape_action_template = ActionTemplate.new
    @escape_action_template.name = 'Escape'
    @escape_action_template.id = :escape
    @escape_action_template.method = :remove

    @actor = Actor.new
    @actor.id = :test_actor

    @battle = Battle.new

    @escape_action = Action.new(@escape_action_template)
    @escape_action.caller = @battle
    @escape_action.args = [@actor.id]
  end

  it 'executes actions' do
    @battle.add_to_team(@actor.id, :heroes)
    ActionExecutor.execute(@escape_action)
    expect(@battle.has_actor?(@actor.id)).to be false
  end
end
