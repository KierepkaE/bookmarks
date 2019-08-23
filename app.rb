require 'sinatra/base'
require 'pg'
require_relative './lib/Bookmark.rb'


class BookmarkManager < Sinatra::Base

  enable :sessions, :method_override

  get '/' do
    'Bookmark Manager'
    erb:'main/index'
  end

  get '/bookmarks' do
    @bookmarks = Bookmark.all
     erb:'bookmarks/index'
  end

  get '/bookmarks/new' do
    erb:'bookmarks/new'
  end

  post '/bookmarks' do
    @bookmarks = Bookmark.create(url: params[:url],title: params[:title])
     redirect '/bookmarks'
  end

  delete '/bookmarks/:id' do
   Bookmark.delete(id: params[:id])
    redirect '/bookmarks'
  end



  run! if app_file == $0
end