require_relative 'registerable.rb'
require_relative 'action.rb'

class ActionTemplate
  include Registerable
  attr_accessor :name, :move_cost
  attr_accessor :caller, :method, :args

  def possible?(actor, context)
    return false if actor.movement < @move_cost
    true
  end

  def populate(actor, context)
    action = Action.new(self)

    case @caller
    when :context
      action.caller = context
    else
      raise "Unexpected caller type: #{@caller}"
    end

    action.args = @args.map do |arg|
      case arg
      when :actor
        actor.id
      else
        raise "Unexpected arg type: #{arg}"
      end
    end

    actor.movement -= @move_cost

    action
  end
end
