require 'sinatra'
require 'sinatra/reloader' if development?
require '../Hangman_v2/lib/hangman.rb'

configure do
    enable :sessions
end

get '/' do
    erb :index
end

post '/' do
    session[:hangman] = Hangman.new
    redirect to ('/game')
end

get '/game' do
    erb :game, locals: {secret_word: session[:hangman].secret_word,
        encrypted_word: session[:hangman].encrypted_word,
        lives: session[:hangman].lives,
        incorrect_guesses: session[:hangman].incorrect_guesses}
end

post '/game' do
    letter = params['guessed_letter'].downcase
    session[:hangman].check_guess(letter)
    session[:hangman].decrypt_word(letter)
    if session[:hangman].secret_word == session[:hangman].encrypted_word.join("")
        erb :end_game, locals: {secret_word: session[:hangman].secret_word,
            win: true}
    elsif session[:hangman].lives>0
        erb :game, locals: {secret_word: session[:hangman].secret_word,
            encrypted_word: session[:hangman].encrypted_word,
            lives: session[:hangman].lives,
            incorrect_guesses: session[:hangman].incorrect_guesses}

    else
        erb :end_game, locals: {secret_word: session[:hangman].secret_word,
            win: false}
    end
end