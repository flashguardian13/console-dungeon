class Dice
  def self.from_str(str)
    match_data = str.match(/(?<count>\d+)d(?<sides>\d+)(?<bonus>[-+]\d+)?/)
    count = match_data[:count].to_i
    sides = match_data[:sides].to_i
    bonus = match_data[:bonus].to_i
    Dice.new(count, sides, bonus)
  end

  def initialize(count, sides, bonus)
    @count = count
    @sides = sides
    @bonus = bonus
  end

  def roll
    x = 0
    @count.times { x += rand(1..@sides) }
    x + @bonus
  end

  def to_s
    "#{@count}d#{@sides}#{@bonus >= 0 ? '+' : ''}#{@bonus}"
  end
end
