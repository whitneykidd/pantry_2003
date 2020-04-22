require 'simplecov'
SimpleCov.start
require 'rspec'
require 'pry'
require './lib/ingredient'
require './lib/recipe'
require './lib/pantry'
require './lib/cook_book'


RSpec.configure do |config|
  config.default_formatter = 'doc'
  config.mock_with :mocha
end

RSpec.describe 'Pantry Spec Harness' do
  before :each do
    @cheese = Ingredient.new(name: "Cheese", unit: "oz", calories: 100)
    @mac = Ingredient.new(name: "Macaroni", unit: "oz", calories: 30)
    @beef = Ingredient.new({name: "Ground Beef", unit: "oz", calories: 100})
    @bun = Ingredient.new({name: "Bun", unit: "g", calories: 75})
    @pantry = Pantry.new
    @mac_and_cheese = Recipe.new("Mac and Cheese")
    @burger = Recipe.new("Cheese Burger")
  end

  describe 'Iteration 1' do
    it '1. Ingredient Creation' do
      expect(Ingredient).to respond_to(:new).with(3).argument
      expect(@cheese).to be_instance_of(Ingredient)
      expect(@cheese).to respond_to(:name).with(0).argument
      expect(@cheese.name).to eq('Cheese')
      expect(@cheese).to respond_to(:unit).with(0).argument
      expect(@cheese.unit).to eq('oz')
      expect(@cheese).to respond_to(:calories).with(0).argument
      expect(@cheese.calories).to eq(100)
    end

    it '2. Pantry Creation' do
      expect(Pantry).to respond_to(:new).with(0).argument
      expect(@pantry).to be_instance_of(Pantry)
      expect(@pantry).to respond_to(:stock).with(0).argument
      expect(@pantry.stock).to eq({})
    end

    it '3. Pantry #stock_check' do
      expect(@pantry).to respond_to(:stock_check).with(1).argument
      expect(@pantry.stock_check(@cheese)).to eq(0)
    end

    it '4. Pantry #restock' do
      expect(@pantry).to respond_to(:restock).with(2).argument
      @pantry.restock(@cheese, 5)
      @pantry.restock(@cheese, 10)
      expect(@pantry.stock_check(@cheese)).to eq(15)
    end
  end

  describe 'Iteration 2' do
    before :each do
      @cookbook = CookBook.new
    end

    it '5. Recipe and CookBook Creation' do
      expect(Recipe).to respond_to(:new).with(1).argument
      expect(@mac_and_cheese).to be_instance_of(Recipe)
      expect(@mac_and_cheese).to respond_to(:name).with(0).argument
      expect(@mac_and_cheese.name).to eq('Mac and Cheese')
      expect(@mac_and_cheese).to respond_to(:ingredients_required).with(0).argument
      expect(@mac_and_cheese.ingredients_required).to eq({})
      expect(CookBook).to respond_to(:new).with(0).argument
      expect(@cookbook).to be_instance_of(CookBook)
      expect(@cookbook).to respond_to(:recipes).with(0).argument
      expect(@cookbook.recipes).to eq([])
    end


    it '6. Recipe #add_ingredient' do
      expect(@mac_and_cheese).to respond_to(:add_ingredient).with(2).argument
      @mac_and_cheese.add_ingredient(@cheese, 2)
      @mac_and_cheese.add_ingredient(@cheese, 4)
      @mac_and_cheese.add_ingredient(@mac, 8)
      expect(@mac_and_cheese.ingredients_required).to eq({@cheese => 6, @mac => 8})
    end

    it '7. Recipe #ingredients' do
      @mac_and_cheese.add_ingredient(@cheese, 2)
      @mac_and_cheese.add_ingredient(@mac, 8)

      expect(@mac_and_cheese).to respond_to(:ingredients).with(0).argument
      expect(@mac_and_cheese.ingredients).to eq([@cheese, @mac])
    end

    it '8. Cookbook #add_recipe' do
      expect(@cookbook).to respond_to(:add_recipe).with(1).argument
      @cookbook.add_recipe(@mac_and_cheese)
      @cookbook.add_recipe(@burger)
      expect(@cookbook.recipes).to eq([@mac_and_cheese, @burger])
    end
  end

  describe 'Iteration 3' do
    before :each do
      @cookbook = CookBook.new
      @mac_and_cheese.add_ingredient(@cheese, 2)
      @mac_and_cheese.add_ingredient(@mac, 20)
      @burger.add_ingredient(@cheese, 2)
      @burger.add_ingredient(@beef, 4)
      @burger.add_ingredient(@bun, 1)
      @cookbook.add_recipe(@mac_and_cheese)
      @cookbook.add_recipe(@burger)
    end

    it '9. Recipe #total_calories' do
      @mac_and_cheese.add_ingredient(@cheese, 2)
      @mac_and_cheese.add_ingredient(@mac, 8)

      expect(@mac_and_cheese).to respond_to(:total_calories).with(0).argument
      expect(@mac_and_cheese.total_calories).to eq(1240)
      expect(@burger.total_calories).to eq(675)
    end

    it '10. Cookbook #ingredients' do
      expect(@cookbook).to respond_to(:ingredients).with(0).argument
      expect(@cookbook.ingredients).to eq(["Cheese", "Macaroni", "Ground Beef", "Bun"])
    end

    it '11. CookBook highest_calorie_meal' do
      expect(@cookbook).to respond_to(:highest_calorie_meal).with(0).argument
      expect(@cookbook.highest_calorie_meal).to eq(@mac_and_cheese)
    end

    it '12. Pantry #enough_ingredients_for?' do
      expect(@pantry).to respond_to(:enough_ingredients_for?).with(1).argument
      @pantry.restock(@cheese, 5)
      expect(@pantry.enough_ingredients_for?(@mac_and_cheese)).to eq(false)
      @pantry.restock(@mac, 7)
      expect(@pantry.enough_ingredients_for?(@mac_and_cheese)).to eq(false)
      @pantry.restock(@mac, 14)
      expect(@pantry.enough_ingredients_for?(@mac_and_cheese)).to eq(true)
    end
  end

  describe 'Iteration 4' do
    before :each do
      Date.stubs(:today).returns(Date.new(2020, 04, 12))
      @cookbook = CookBook.new
      @cheese = Ingredient.new(name: "Cheese", unit: "C", calories: 100)
      @mac = Ingredient.new(name: "Macaroni", unit: "oz", calories: 30)
      @mac_and_cheese = Recipe.new("Mac and Cheese")
      @mac_and_cheese.add_ingredient(@cheese, 2)
      @mac_and_cheese.add_ingredient(@mac, 8)
      @ground_beef = Ingredient.new(name: "Beef", unit: "oz", calories: 100)
      @bun = Ingredient.new(name: "Bun", unit: "g", calories: 1)
      @burger = Recipe.new("Burger")
      @burger.add_ingredient(@ground_beef, 4)
      @burger.add_ingredient(@bun, 100)
    end

    it '14 CookBook #date' do
      expect(@cookbook.date).to eq("04-12-2020")
    end

    it '13. Cookbook #summary' do
      @cookbook.add_recipe(@mac_and_cheese)
      @cookbook.add_recipe(@burger)

      expected = [
        {
          name: "Mac and Cheese",
          details: {
            ingredients: [
              {ingredient: "Macaroni", amount: "8 oz"},
              {ingredient: "Cheese", amount: "2 C"}
            ],
            total_calories: 440
          }
        },
        {
        name: "Burger",
        details: {
          ingredients: [
            {ingredient: "Beef", amount: "4 oz"},
            {ingredient: "Bun", amount: "100 g"}
          ],
          total_calories: 500
          }
        }
      ]

      expect(@cookbook).to respond_to(:summary).with(0).argument
      expect(@cookbook.summary).to eq(expected)
    end
  end
end
