require './hangman'
require 'sinatra'
require 'sinatra/reloader'

configure do
  enable :sessions
end

get "/" do
  session["game"] = Hangman.new
  moves_left = session["game"].moves
  correct = session["game"].show_progress
  incorrect = ""
  erb :index, :locals => {:moves_left => moves_left, :correct => correct, :incorrect => incorrect}
end

post "/" do
  game = session["game"]
  if game.check_if_won || game.moves == 0
    redirect "/game_over"
  end
  guess = params["guess"]
  game.moves -= 1 unless not_valid_guess(guess)
  moves_left = game.moves
  guess = params["guess"]
  game.check_guess(guess) unless not_valid_guess(guess)
  correct = game.show_progress
  incorrect = game.show_incorrect
  erb :index, :locals => {:moves_left => moves_left, :correct => correct, :incorrect => incorrect}
end

get "/game_over" do
  game = session["game"]
  message = ""
  if game.check_if_won
   message += "Congrats, you won!"
 else
   message += "Too bad, you lost!"
 end
 erb :game_over, :locals => {:message => message}
end

helpers do

  def not_valid_guess(guess)
    if guess.nil? || !guess.match(/^[[:alpha:]]$/) || session["game"].incorrect.include?(guess)
      return true
    else
      return false
    end
  end

end
