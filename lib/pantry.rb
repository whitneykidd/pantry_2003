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

  def enough_ingredients_for?(recipe)
    ingredients = recipe.ingredients_required
    ingredients.all? { |ingredient, required| @stock[ingredient] >= required }
  end
end
