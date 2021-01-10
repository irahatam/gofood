class Food
  attr_reader :name, :price, :tags

  def init(name, price, vegan, tags, healthy, origin)
    @name = name
    @price = price
    @vegan = vegan
    @tags = tags
    @healthy = healthy
    @origin = origin
  end

  def to_s
    "#{@name} Rp #{@price} #{@vegan} tags:#{@tags.join(', ')}, #{@healthy}, #{@origin}"
  end
end

class Drink
  attr_reader :name, :price, :tags

  def init(name, price, size, temp, caffeine, tags, origin)
    @name = name
    @price = price
    @size = size
    @temp = temp
    @caffeine = caffeine
    @tags = tags
    @origin = origin
  end

  def to_s
    "#{@name} Rp #{@price} #{@size} #{@temp} #{@caffeine} tags:#{@tags.join(', ')}, #{@origin}"
  end
end

class Recommender
  attr_reader :menu

  def initialize
    @menu = []
    @preference = {}
    @recommendations = []
  end

  def prompt_preference
    puts "Do you want to drink or eat?"
    @preference[:type] = gets.chomp

    puts "What flavor do you prefer?"
    @preference[:flavor] = gets.chomp

    puts "How much budget do you have?"
    budget = gets.chomp
    min_budget, max_budget = budget.split("-")
    @preference[:min_budget] = min_budget.to_i
    @preference[:max_budget] = max_budget.to_i
  end  

  def recommend
    for item in @menu
      case @preference[:type]
      when "eat"
        @recommendations << item if item.tags.include?(@preference[:flavor]) && (@preference[:min_budget] <= item.price && @preference[:max_budget] >= item.price)
      end
    end
  end

  def print_recommendation
    if @recommendations == nil
      puts "Sorry we don't have any recommendations for you"
    else
      puts "Recommendations for you:"
      @recommendations.each do |recommendation|
        puts recommendation.name
      end
    end
  end
end

class CommandParser
  def init
    @recommender = Recommender.new
  end

  def run
    puts "Welcome to GoFood"

    begin
      input = gets.chomp
      command, *args = input.split(" ")

      case command
      when 'create_menu'
        puts "created #{args[0]} menu"
      when 'add_food'
        execute_add_food(args)
      when 'add_drink'
        execute_add_drink(args)
      when 'list_menu'
        execute_list_menu
      when 'give_recommendations'
        execute_give_recommendations
      end
    end while command != 'exit'
  end

  def execute_add_food(args)
    name = args[0]
    price = args[1].to_i
    vegan = args[2]
    tags = args[3..-3]
    healthy = args[-2]
    origin = args[-1]

    food = Food.new(name, price, vegan, tags, healthy, origin)
    @recommender.menu << food

    puts "#{food.name} added"  
  end

  def execute_add_drink(args)
    name = args[0]
    price = args[1].to_i
    size = args[2]
    temp = args[3]
    caffeine = args[4]
    tags = args[5..-2]
    origin = args[-1]

    drink = Drink.new(name, price, size, temp, caffeine, tags, origin)
    @recommender.menu << drink
    puts "#{drink.name} added"
  end
  
  def execute_list_menu
    for item in @recommender.menu
      puts item
    end
  end

  def execute_give_recommendations
    @recommender.prompt_preference
    @recommender.recommend
    @recommender.print_recommendation
  end
end

command_parser = CommandParser.new
command_parser.run
