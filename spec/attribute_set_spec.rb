require_relative '../lib/attribute_set.rb'

describe AttributeSet do
  before do
    @attributes = AttributeSet.new
  end

  it 'can get and set values' do
    expect(@attributes[:strength]).to eq(nil)
    @attributes[:strength] = 4
    expect(@attributes[:strength]).to eq(4)
  end

  it 'can only be assigned values for whitelisted attributes' do
    expect { @attributes[:strength] = 10 }.not_to raise_error
    expect { @attributes[:manliness] = 10 }.to raise_error(ArgumentError)
  end

  it 'can be added to other attribute sets' do
    @attributes1 = AttributeSet.new
    @attributes1[:hit_points] = 10
    @attributes1[:strength] = 4
    @attributes1[:dexterity] = 7

    @attributes2 = AttributeSet.new
    @attributes2[:hit_points] = 5
    @attributes2[:strength] = 10
    @attributes2[:intelligence] = 18

    @combined_attributes = @attributes1 + @attributes2
    expect(@combined_attributes[:hit_points]).to eq(15)
    expect(@combined_attributes[:strength]).to eq(14)
    expect(@combined_attributes[:dexterity]).to eq(7)
    expect(@combined_attributes[:intelligence]).to eq(18)
    expect(@combined_attributes[:constitution]).to eq(nil)
  end
end
