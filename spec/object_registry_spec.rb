require_relative '../lib/object_registry.rb'

describe ObjectRegistry do
  before do
    @test_register = ObjectRegistry.new

    @gold_piece = Item.new
    @gold_piece.id = :gold_piece
  end

  after do
    @test_register.clear
  end

  it 'has an items register' do
    expect(ObjectRegistry.items).to be_instance_of(ObjectRegistry)
  end

  it 'complains if the id of an added object is not unique' do
    @test_register.add(@gold_piece)
    expect { @test_register.add(@gold_piece) }.to raise_error(ObjectRegistryError)
  end

  it 'returns objects with a matching id' do
    @test_register.add(@gold_piece)
    expect(@test_register.find(:gold_piece)).to eq(@gold_piece)
  end
end
