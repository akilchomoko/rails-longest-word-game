require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = generate_grid(10)
  end

  def score
    @answer = params["answer"]
    @grid = params["grid"].split(" ")
    @result = run_game(@answer, @grid)
    # raise
  end

  private

  def generate_grid(grid_size)
    # TODO: generate random grid of letters
    letters = (1..grid_size).map { rand(65..90).chr }
    letters
  end

  def run_game(attempt, grid)
    # TODO: runs the game and return detailed hash of result (with `:score`, `:message` and `:time` keys)
    score = 0
    return { score: 0, message: "Need to enter some letters!"} if attempt == ""
    return { score: 0, message: "To many letters used!"} if attempt.length > 10
    return { score: 0, message: "Not in the grid!"} unless included?(attempt, grid)

    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    result = JSON.parse(open(url).read)
    return { score: 0, message: "Not an English word"} if result["found"] == false

    # score = attempt.length * ((30 / time.to_i) * 0.5)
    { score: score, message: "Well done, word found!"}
  end

  def included?(attempt, grid)
    # determine if attempt string is found in grid of letters
    result = true
    attempt.upcase.chars.all? do |char|
      index = grid.index(char)
      index.nil? ? result = false : grid.delete_at(index)
      result
    end
  end
end
