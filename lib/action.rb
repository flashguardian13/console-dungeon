require_relative '../lib/action_template.rb'

class Action
  attr_reader :template
  attr_accessor :caller, :args

  def initialize(template)
    raise ArgumentError.new("Expected ActionTemplate, but received #{template}!") unless template.is_a?(ActionTemplate)
    @template = template
    @caller = nil
    @args = []
  end
end
