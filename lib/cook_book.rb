require 'date'
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

  def date
    Date.today.strftime('%m-%d-%Y')
  end

  def summary
    summary = []
    @recipes.each do |recipe|
      summary << {name: recipe.name,
        details: {ingredients: [{ingredient: 'tbd', amount: 'tbd'}]}}
    end
    summary
  end
end
