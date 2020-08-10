require 'open-uri'
require 'json'

class GamesController < ApplicationController

  def new
    @letters = generate_grid(10).join
    @start_time = Time.now
  end

  def score
    start_time = Time.parse(params[:start_time])
    end_time = Time.now
    @guess = params[:guess].upcase
    @letters = params[:letters]
    if included?(@guess, @letters)
      if english_word?(@guess)
        @message = "Congratulations #{@guess} is a valid English word!"
      else
        @message = "#{@guess} is not an English word"
      end
    else
      @message = "Sorry but #{@guess} can't be built out of #{@letters}"
    end

    @time = end_time - start_time
  end

  private

  def generate_grid(grid_size)
    Array.new(grid_size) { ('A'..'Z').to_a[rand(26)] }
  end

  def included?(guess, grid)
    guess.chars.all? { |letter| guess.count(letter) <= grid.count(letter) }
  end

  def english_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    return json['found']
  end
end
