require_relative 'item.rb'
require_relative 'paper_doll.rb'
require_relative 'action.rb'

class Equipment < Item
  def slot
    @slot
  end

  def slot=(value)
    raise ArgumentError.new("Invalid slot: #{value.inspect}") unless PaperDoll::Slot::WHITELIST.include?(value)
    @slot = value
  end

  def attributes
    @attributes
  end

  def attributes=(attr)
    raise ArgumentError.new("Expected AttributeSet, found #{attr.inspect}!") unless attr.instance_of?(AttributeSet)
    @attributes = attr
  end

  def action
    @action
  end

  def action=(the_action_id)
    @action = the_action_id
  end
end
