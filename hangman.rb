class Hangman
  require 'json'
  attr_accessor :moves, :word, :correct, :incorrect
  def initialize(correct=[], incorrect=[])
    @word = choose_word
    @moves = 10
    @correct = correct
    @incorrect = incorrect
  end

  def check_guess(guess)
    index = 0
    while index < @word.length
      @correct[index] = guess if @word[index] == guess
      index += 1
    end
    @incorrect << guess if !@word.include?(guess)
  end

  def show_progress
    temp = []
    @correct.each {|letter|
      if !letter.nil?
        temp << letter
      else
        temp << "_"
      end
    }
    temp.join("")
    temp
  end

  def choose_word
    list = File.open("5desk.txt").readlines
    list = list.select {|word| word.length >= 5 && word.length <= 12}
    word = list.sample
    word[0..word.length - 2].downcase
  end

  def show_incorrect
    temp = ""
    @incorrect.each do |letter|
      temp += letter + " "
    end
    temp
  end

  def show_moves_remaining
    puts "#{@moves} moves remaining."
  end

  def check_if_won
    @correct.join("") == @word
  end

  def to_json
    JSON.dump({
      :word => @word,
      :moves => @moves,
      :correct => @correct,
      :incorrect => @incorrect
      })
  end

  def self.from_json(string)
    data = JSON.load(string)
    self.new(data['word'], data['moves'], data['correct'], data['incorrect'])
  end
end
