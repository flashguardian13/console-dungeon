require_relative '../lib/action.rb'

describe Action do
  before do
    @actor = Actor.new
    @actor.id = :test_actor

    @test_action_template = ActionTemplate.new
    @test_action = Action.new(@test_action_template)
    @test_action.caller = @actor
  end

  it 'requires an action template to instantiate' do
    expect(@test_action.template).to eq(@test_action_template)
    expect { Action.new(:foo) }.to raise_error(ArgumentError)
  end

  it 'has the object performing the action' do
    expect(@test_action.caller).to eq(@actor)
  end

  it 'has one or more arguments' do
    expect(@test_action.args).to be_instance_of(Array)
  end
end
