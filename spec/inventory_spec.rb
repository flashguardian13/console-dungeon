require_relative '../lib/inventory.rb'

describe Inventory do
  before(:all) do
    @health_potion = Item.new
    @health_potion.id = :health_potion
    @health_potion.name = 'Health Potion'
    @health_potion.size = 1
    @health_potion.weight = 1
    @health_potion.value = 50
    ObjectRegistry.items.add(@health_potion)

    @gold_piece = Item.new
    @gold_piece.id = :gold_piece
    @gold_piece.name = 'Gold Piece'
    @gold_piece.size = 1
    @gold_piece.weight = 1
    @gold_piece.value = 1
    ObjectRegistry.items.add(@gold_piece)

    @longsword = Equipment.new
    @longsword.id = :longsword
    @longsword.name = 'Longsword'
    @longsword.size = 5
    @longsword.weight = 5
    @longsword.value = 10
    @longsword.slot = :hand
    ObjectRegistry.items.add(@longsword)
  end

  after(:all) do
    ObjectRegistry.items.clear
  end

  before do
    @test_inventory = Inventory.new
  end

  after do
    @test_inventory.clear
  end

  it 'can add items' do
    @test_inventory.add_item(:gold_piece, 10)
    @test_inventory.add_item(:longsword, 1)
    @test_inventory.add_item(:health_potion, 3)
    @test_inventory.add_item(:gold_piece, 25)

    expect(@test_inventory.count(:gold_piece)).to eq(35)
    expect(@test_inventory.count(:longsword)).to eq(1)
    expect(@test_inventory.count(:health_potion)).to eq(3)
  end

  it 'can remove items' do
    @test_inventory.add_item(:gold_piece, 50)
    @test_inventory.add_item(:longsword, 1)
    @test_inventory.add_item(:health_potion, 3)

    expect(@test_inventory.remove_item(:gold_piece, 10)).to eq(10)
    expect(@test_inventory.remove_item(:longsword, 2)).to eq(1)
    expect(@test_inventory.remove_item(:health_potion, 1)).to eq(1)

    expect(@test_inventory.count(:gold_piece)).to eq(40)
    expect(@test_inventory.count(:longsword)).to eq(0)
    expect(@test_inventory.count(:health_potion)).to eq(2)
  end
end
