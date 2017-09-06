require './hangman.rb'
require './player.rb'

def get_name
  puts "What is your name?"
  name = gets.chomp
  name
end

def save_game?(player, game)
  puts "Save game? (y)es or (n)o"
  decision = gets.chomp.downcase
  while !decision == "y" || !decision == "n"
    puts "Enter y or n"
    decision = gets.chomp.downcase
  end
  if decision == "y"
    File.open("./saves/game.json", "w") { |file| file.puts game.to_json }
    File.open("./saves/player.json", "w") { |file| file.puts player.to_json }
    puts "Game saved!"
    exit(0)
  end
end

puts "Load previous game? (y)es or (n)o"
decision = gets.chomp.downcase
while !decision == "y" || !decision == "n"
  puts "Enter y or n"
  decision = gets.chomp.downcase
end
if decision == "y"
  game = Hangman.from_json(File.read("./saves/game.json"))
  player = Player.from_json(File.read("./saves/player.json"))
else
  game = Hangman.new
  player = Player.new(get_name)
end
puts "Welcome, #{player.name}! Welcome to Hangman, let's begin!"
while game.moves > 0 || game.check_if_won
  game.show_moves_remaining
  game.show_incorrect
  player.make_guess
  game.check_guess(player.guess)
  game.moves -= 1
  game.show_progress
  save_game?(player, game)
end
if game.check_if_won
  puts "#{player.name} won!"
else
  puts "#{player.name} lost!"
end
