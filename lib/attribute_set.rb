class AttributeSet < Hash
  WHITELIST = %w(
    strength dexterity constitution intelligence wisdom charisma
    hit_points max_hit_points
    fighter_level rogue_level oracle_level sorceror_level
    experience
  ).map { |x| x.to_sym }

  def []=(attribute, value)
    raise ArgumentError.new("Attribute #{attribute.inspect} is not in the whitelist.") unless WHITELIST.include?(attribute)
    super(attribute, value)
  end

  def +(other)
    all_keys = self.keys | other.keys
    all_values =  all_keys.map do |key|
                    value = 0
                    value += self.fetch(key, 0)
                    value += other.fetch(key, 0)
                    value
                  end
    AttributeSet[[all_keys, all_values].transpose]
  end
end
