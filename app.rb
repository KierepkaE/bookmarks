require 'sinatra/base'
require 'pg'
require 'uri'
require 'sinatra/flash'
require_relative './lib/bookmark.rb'
require_relative './lib/comment.rb'
require_relative './database_connection_setup.rb'


class BookmarkManager < Sinatra::Base

  enable :sessions, :method_override
  register Sinatra::Flash

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
    flash[:notice] = "Please submit a valid URL" unless Bookmark.create(url: params[:url], title: params[:title])
     redirect '/bookmarks'
  end

  delete '/bookmarks/:id' do
   Bookmark.delete(id: params[:id])
    redirect '/bookmarks'
  end


  get '/bookmarks/:id/edit' do
    @bookmark = Bookmark.find(id: params[:id])
    erb:'bookmarks/edit'
  end

  patch '/bookmarks/:id' do
   Bookmark.update(url: params[:url], title: params[:title], id: params[:id])
    redirect '/bookmarks'
  end

  get '/bookmarks/:id/comments/new' do
    @bookmark_id = params[:id]
    erb :'comments/new'
  end

   post '/bookmarks/:id/comments' do
    Comment.create(bookmark_id: params[:id], text: params[:comment])
    redirect '/bookmarks'
  end

  run! if app_file == $0
end