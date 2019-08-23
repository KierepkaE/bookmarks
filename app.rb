require 'sinatra/base'
require_relative './lib/Bookmark.rb'


class BookmarkManager < Sinatra::Base
  get '/' do
    'Bookmark Manager'
    erb:'main/index'
  end

  get '/bookmarks' do
    @bookmarks = Bookmark.all
     erb:'bookmarks/index'
  end

  run! if app_file == $0
end