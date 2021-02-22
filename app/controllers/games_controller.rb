# Import for api
require 'open-uri'
require 'json'

# Constant
SIZE = 10

class GamesController < ApplicationController
  # Create a random grid of letters
  def new
    @letters = []
    letter_array = ('A'..'Z').to_a
    SIZE.times do
      @letters << letter_array[rand(letter_array.length)]
    end
    $start_time = Time.now
  end

  # Affiche the score for the user
  def score
    end_time = Time.now
    word = params[:word]
    grid = params[:letter_grid].split(',')
    # World not in the grid
    @resultat = "Sorry but #{word} can't build out of #{grid.join(', ')}" unless world_in_grid(word, grid)

    @resultat = "Sorry but #{word} does not seem to be an english word" unless english_word(word)
    if english_word(word) && world_in_grid(word, grid)
      score = word.length - (end_time - $start_time)
      @resultat = "Congratulation #{word} is a valid english word, your score is #{score}"
    end
  end

  private

  def world_in_grid(word, grid)
    letters = word.split('')
    letters.all? do |letter|
      letters.count(letter) <= grid.count(letter.upcase)
    end
  end

  def english_word(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    result_api = open(url).read
    result_parse = JSON.parse(result_api.to_s)
    result_parse['found']
  end
end
