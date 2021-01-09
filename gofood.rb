class Food
  attr_reader :name
  def initialize(name, price, vegan, tags, healthy, origin)
    @name = name
    @price = price
    @vegan = vegan
    @tags = tags
    @healthy = healthy
    @origin = origin
  end

  def to_s
    "#{@name} Rp #{@price} #{@vegan} tags: #{@tags.join(', ')} #{@healthy} #{@origin}"
  end
end

class Drink
  attr_reader :name
  def initialize(name, price, size, hot, caffeine, tags, origin)
    @name = name
    @price = price
    @size = size
    @hot = hot
    @caffeine = caffeine
    @tags = tags
    @origin = origin
  end

  def to_s
    "#{@name} Rp #{@price} #{@size} #{@hot} #{@caffeine} tags: #{@tags.join(', ')} #{@origin}"
  end
end

puts "Welcome to Go-Food \nPlease enter one of the following commands: \ncreate_menu \nadd_food \nadd_drink \ngive_recommendations"

begin
  input = gets.chomp
  command, *args = input.split(" ")
  preference = {}
  recommendations = {}
  
  if command == 'create_menu'
    puts "Created #{args[0]} menu"
    menu = []
  elsif command == 'add_food'
    name = args[0]
    price = args[1].to_i
    vegan = args[2]
    tags = args[3..-3]
    healthy = args[-2]
    origin = args[-1]

    food = Food.new(name, price, vegan, tags, healthy, origin)
    menu << food
    puts "#{food.name} added"

  elsif command == 'add_drink'
    name = args[0]
    price = args[1].to_i
    size = args[2]
    hot = args[3]
    caffeine = args[4]
    tags = args[5..-2]
    origin = args[-1]

    drink = Drink.new(name, price, size, hot, caffeine, tags, origin)
    menu << drink
    puts "#{drink.name} added"

  elsif command == 'list_menu'
    for item in menu.each
      puts item
    end

  elsif command == 'give_recommendations'
    puts "Do you want to drink or eat?"
    preference[:type] = gets.chomp

    puts "What flavor do you prefer?"
    preference[:flavor] = gets.chomp

    puts "How much budget do you have?"
    budget = gets.chomp
    min_budget, max_budget = budget.split("-")
    preference[:min_budget] = min_budget.to_i
    preference[:max_budget] = max_budget.to_i

    for item in menu
      case preference[:type]
      when "eat"
        puts item.tags.include?(preference[:flavor])
        puts preference[:min_budget] <= item.price
        puts preference[:max_budget] >= item.price
        recommendations << item if item.tags.include?(preference[:flavor]) && (preference[:min_budget] <= item.price && preference[:max_budget] >= item.price)
      end
    end

    if recommendations == nil
      puts "Sorry, we don't have anything to recommend to you."
    else
      puts "Recommendations for you:"
      recommendations.each do [recommendation]
        puts recommendation.name
      end
    end

  else puts "Invalid command. Please try again."
  end

end while command != 'exit'