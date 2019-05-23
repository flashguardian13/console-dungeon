require_relative 'menu.rb'

class Battle
  def initialize
    @teams = Hash.new { |h, k| h[k] = [] }
    @removed_heroes = []
    @removed_non_heroes = []
  end

  def add_to_team(actor_id, team)
    raise "Expected Actor id, but received #{actor_id}!" unless actor_id.is_a?(Symbol)
    @teams[team] << actor_id
  end

  def get_team(team)
    @teams[team].map { |id| ObjectRegistry.actors.find(id) }
  end

  def clear
    @teams.clear
  end

  def remove(actor_id)
    raise "Expected Actor id, but received #{actor_id}!" unless actor_id.is_a?(Symbol)
    @teams.each do |team, actor_ids|
      result = actor_ids.delete(actor_id)
      next unless result
      if team == :heroes
        @removed_heroes.push(actor_id)
      else
        @removed_non_heroes.push(actor_id)
      end
    end
  end

  def has_actor?(actor_id)
    raise "Expected Actor id, but received #{actor_id}!" unless actor_id.is_a?(Symbol)
    @teams.values.any? { |ids| ids.include?(actor_id) }
  end

  def status
    if get_team(:heroes).all? { |actor| actor.incapacitated? }
      return @removed_heroes.any? ? :retreat : :defeat
    end

    non_heroes = []
    @teams.each do |team, actor_ids|
      non_heroes.concat(actor_ids) unless team == :heroes
    end
    non_heroes.map! { |id| ObjectRegistry.actors.find(id) }

    if non_heroes.all? { |actor| actor.incapacitated? }
      return :victory
    end

    :active
  end

  def action_menu_for(actor_id)
    {
      'Strike' => :strike
    }
  end

  def target_menu
    menu = {}
    @teams.each do |team, actor_ids|
      actor_ids.each do |actor_id|
        actor = ObjectRegistry.actors.find(actor_id)
        menu[actor.name] = actor_id
      end
    end
  end

  def run
    puts "Fight!"

    turn_order = roll_initiative

    while status == :active
      current_actor = turn_order.pop
      turn_order.unshift(current_actor)

      choice = do_menu("#{current_actor}'s Turn", action_menu_for(current_actor))

      case choice
      when :strike
        target_id = do_menu("#{choice} whom?", target_menu)
        attacker = ObjectRegistry.actors.find(current_actor)
        target = ObjectRegistry.actors.find(target_id)
        attacker.strike(target)
      else
        puts "What do you mean, #{choice}?"
      end
    end

    puts "Fight ended: #{status}"
  end
end
