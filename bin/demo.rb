require_relative '../lib/actor.rb'
require_relative '../lib/battle.rb'
require_relative '../lib/object_registry.rb'

if __FILE__ == $PROGRAM_NAME
  player = Actor.new
  player.id = :player
  player.name = 'Player'
  ObjectRegistry.actors.add(player)

  goblin = Actor.new
  goblin.id = :goblin
  goblin.name = 'Goblin'
  ObjectRegistry.actors.add(goblin)

  battle = Battle.new
  battle.add_to_team(player.id, :heroes)
  battle.add_to_team(goblin.id, :enemies)

  battle.run
end
