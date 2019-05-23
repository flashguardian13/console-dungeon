class Inventory
  def initialize
    @items = Hash.new { |h, k| h[k] = 0 }
  end

  def add_item(item_id, count = 1)
    @items[item_id] += count
  end

  def remove_item(item_id, count = 1)
    if @items[item_id] < count
      removed = @items[item_id]
      @items[item_id] = 0
      removed
    else
      @items[item_id] -= count
      count
    end
  end

  def count(item_id)
    @items[item_id]
  end

  def clear
    @items.clear
  end
end
