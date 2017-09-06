class Player
  require 'json'
  attr_accessor :name, :guess
  def initialize(name, guess="")
    @name = name
    @guess = guess
  end

  def make_guess
    puts "Select a letter: "
    move = gets.chomp.downcase
    while !move.match(/[A-Za-z]/)
      puts "Please select alphabetic character."
      move = gets.chomp.downcase
    end
    @guess = move
  end

  def to_json
    JSON.dump({
      :name => @name,
      :guess => @guess
      })
  end

  def self.from_json(string)
    data = JSON.load(string)
    self.new(data['name'], data['guess'])
  end
end
