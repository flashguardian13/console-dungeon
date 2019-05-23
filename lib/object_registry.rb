require_relative 'object_registry_error.rb'

class ObjectRegistry
  @@items = nil
  def self.items
    @@items ||= ObjectRegistry.new
  end

  @@actors = nil
  def self.actors
    @@actors ||= ObjectRegistry.new
  end

  @@actions = nil
  def self.actions
    @@actions ||= ObjectRegistry.new
  end

  def initialize
    @registry = {}
  end

  def clear
    @registry.clear
  end

  def add(item)
    raise ObjectRegistryError.new("Registry already has item with id #{item.id}!") if @registry[item.id]
    @registry[item.id] = item
  end

  def find(id)
    @registry.fetch(id)
  end
end
