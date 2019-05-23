require_relative '../lib/item.rb'

describe Item do
  before do
    @test_item = Item.new
  end

  it 'has an id' do
    @test_item.id = :potion
    expect(@test_item.id).to eq(:potion)
  end

  it 'has a name' do
    @test_item.name = 'Potion'
    expect(@test_item.name).to eq('Potion')
  end

  it 'has a size' do
    @test_item.size = 2
    expect(@test_item.size).to eq(2)
  end

  it 'has a weight' do
    @test_item.weight = 0.1
    expect(@test_item.weight).to eq(0.1)
  end

  it 'has a value' do
    @test_item.value = 50
    expect(@test_item.value).to eq(50)
  end
end
