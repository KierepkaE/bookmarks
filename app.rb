require 'sinatra/base'
require 'pg'
require 'uri'
require 'sinatra/flash'
require_relative './lib/bookmark.rb'
require_relative './lib/comment.rb'
require_relative './lib/user.rb'
require_relative './database_connection_setup.rb'


class BookmarkManager < Sinatra::Base

  enable :sessions, :method_override
  register Sinatra::Flash

  get '/' do
    'Bookmark Manager'
    erb:'main/index'
  end

  get '/bookmarks' do
    @user = User.find(user_id: session[:user_id])
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

  get '/bookmarks/:id/tags/new' do
    @bookmark_id = params[:id]
    erb :'/tags/new'
  end

   post '/bookmarks/:id/tags' do
    tag = Tag.create(content: params[:tag])
    BookmarkTag.create(bookmark_id: params[:id], tag_id: tag.id)
    redirect '/bookmarks'
  end

  get '/tags/:id/bookmarks' do
    @tag = Tag.find(id: params['id'])
    erb :'tags/index'
  end

  get '/users/new' do
    erb:'users/new'
  end

  post '/users' do
   user =  User.create(email: params[:email], password: params[:password])
   session[:user_id] = user.id
    redirect '/bookmarks'
  end

  get '/sessions/new' do
    erb :'sessions/new'
  end

  post '/sessions' do
    user = User.authenticate(email: params[:email], password: params[:password])
    if user
      session[:user_id] = user.id
      redirect('/bookmarks')
    else
      flash[:notice] = 'Please check your email or password.'
      redirect('/sessions/new')
    end
  end

  run! if app_file == $0
end