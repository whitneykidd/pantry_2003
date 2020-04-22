class CookBook
  attr_reader :recipes
  def initialize
    @recipes = []
  end

  def add_recipe(recipe)
    @recipes << recipe
  end

  def ingredients
    ingredients = @recipes.flat_map do |recipe|
      recipe.ingredients
    end
    ingredients.map do |ingredient|
      ingredient.name
    end.uniq
  end

  def highest_calorie_meal
    @recipes.max_by { |recipe| recipe.total_calories }
  end
end
