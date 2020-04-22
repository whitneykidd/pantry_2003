class Pantry
  attr_reader :stock
  def initialize
    @stock = Hash.new(0)
  end

  def stock_check(ingredient)
    @stock[ingredient]
  end

  def restock(ingredient, quantity)
    if @stock.keys.include?(ingredient)
      @stock[ingredient] += quantity
    else
      @stock[ingredient] = quantity
    end
  end
end
