class GamesController < ApplicationController
  def new
    @letters = []
    10.times do
    @letters << ('A'...'Z').to_a.sample
    end
  end

  def included?(word, letters)
    valid = true
    word.upcase.split('').each do |letter| 
      if letters.include?(letter) 
        a = letters.index(letter)
        letters.delete_at(a)
      else
        valid = false
      end
    end
    valid
  end

  def parsing(parameter)
    url = "https://wagon-dictionary.herokuapp.com/#{parameter}"
    uri = URI(url)
    response = Net::HTTP.get(uri)
    JSON.parse(response)
  end

  def score
    @word = params[:word]
    @letters = params[:letters].split(' ')
    @result = ''
    res = parsing(@word)
    if res['found'] && included?(@word, @letters)
      @result = "Congratulations #{@word} is valid"
    elsif !included?(@word, @letters)
      @result = "#{@word} can't be build from #{params[:letters]}"
    else
      @result = "#{@word} is not a valid option"
    end
  end
end
