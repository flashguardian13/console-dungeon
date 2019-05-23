class ActionExecutor
  def self.execute(action)
    action.caller.public_send(action.template.method, *action.args)
  end
end
