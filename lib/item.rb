require_relative 'registerable.rb'

class Item
  include Registerable
  attr_accessor :name, :size, :weight, :value
end
