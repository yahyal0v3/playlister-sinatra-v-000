require 'rack-flash'

class SongsController < ApplicationController
  enable :sessions
  use Rack::Flash

  get '/songs' do
    @songs = Song.all
    erb :'/songs/index'
  end

  get '/songs/new' do
    erb :'/songs/new'
  end

  post '/songs' do
    @song = Song.create(params[:song])

    if Artist.find_by(params[:artist])
      artist = Artist.find_by(params[:artist])
    else
      artist = Artist.create(params[:artist])
    end 
    artist.songs << @song
    artist.save

    params[:genres].each do |genre|
      @song.genres << Genre.find(genre)
    end

    flash[:message] = "Successfully created song."
    redirect "/songs/#{@song.slug}"
  end

  get '/songs/:slug' do
    @song = Song.find_by_slug(params[:slug])
    erb :'/songs/show'
  end

end