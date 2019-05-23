require_relative 'equipment_error.rb'

class PaperDoll
  class Slot
    WHITELIST = %w{ring neck hand}.map { |x| x.to_sym }

    attr_accessor :slot, :equipment_id

    def initialize(slot)
      raise ArgumentError.new("Invalid slot: #{slot.inspect}") unless WHITELIST.include?(slot)
      @slot = slot
      @equipment_id = nil
    end

    def empty?
      @equipment_id == nil
    end
  end

  attr_reader :slots

  def initialize
    @slots = []
  end

  def add_slots(*slots_to_add)
    @slots.concat(slots_to_add.map { |slot| Slot.new(slot) })
  end

  def remove_slots(*slots_to_remove)
    equipment_removed = slots_to_remove.map do |slot|
      matching_slots = @slots.select { |s| s.slot == slot }
      empty_matching_slots = matching_slots.select { |s| s.empty? }
      if empty_matching_slots.any?
        @slots.delete(empty_matching_slots.first).equipment_id
      elsif matching_slots.any?
        @slots.delete(matching_slots.first).equipment_id
      end
    end
    equipment_removed.compact
  end

  def clear_slots
    equipment_removed = @slots.map { |s| s.equipment_id }
    @slots.clear
    equipment_removed.compact
  end

  def equip(equipment_id)
    equipment = ObjectRegistry.items.find(equipment_id)
    empty_matching_slots = @slots.select { |s| s.slot == equipment.slot && s.empty? }
    if empty_matching_slots.any?
      empty_matching_slots.first.equipment_id = equipment_id
    else
      raise EquipmentError.new("Unable to equip #{equipment.name}: no empty #{equipment.slot} slots available")
    end
  end

  def attributes
    all_attributes = AttributeSet.new
    @slots.each do |slot|
      equipment = ObjectRegistry.items.find(slot.equipment_id)
      all_attributes += equipment.attributes
    end
    all_attributes
  end
end
