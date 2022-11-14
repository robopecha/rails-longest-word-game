class GamesController < ApplicationController
  require 'json'
  require 'open-uri'

  def generate_grid(grid_size)
    Array.new(grid_size) { ('A'..'Z').to_a.sample }
  end

  def new
    @letters = generate_grid(10)
  end

  def score
    @answer = params[:answer]
    @letters = params[:letters]
    @result = score_and_message(@answer, @letters)
  end

  def included?(guess, grid)
    guess.chars.all? { |letter| guess.count(letter) <= grid.count(letter) }
  end

  def score_and_message(attempt, grid)
    if included?(attempt.upcase, grid)
      if english_word?(attempt)
        "well done"
      else
        "not an english word"
      end
    else
      "not in the grid"
    end
  end

  def english_word?(word)
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    return json['found']
  end
end
