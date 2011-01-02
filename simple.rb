require 'rubygems'
require 'sinatra'
require 'erb'
require 'hashie'
require 'date'

class Post < Hashie::Dash
  property :raw_title
  property :raw_posted_at
  
  def file_name
    "views/posts/#{self.raw_title}.#{self.raw_posted_at}.html"
  end
  
  def title
    self.raw_title.gsub('-', ' ') 
  end
  
  def posted_at
    DateTime.parse(self.raw_posted_at)
  end
  
  def formatted_posted_at
    self.posted_at.strftime('%d %B %Y')
  end
end

get '/?' do
  erb :index
end

get '/thesis?' do
  File.read 'views/thesis.html'
end

get '/*' do
  if @post
    File.read @post.file_name
  else
    File.read 'views/404.html'
  end
end

before do
  files = Dir.glob('views/posts/*.html')
  @posts = []
  files.each do |file|
    title_and_date = file.gsub('views/posts/', '').split('.')
    @posts << Post.new(:raw_title => title_and_date[0], :raw_posted_at => title_and_date[1])
  end
    
  @posts = @posts.sort { |a,b| b.posted_at <=> a.posted_at }  
  
  requested = request.path_info.gsub('/', '')
  @posts.each do |post|
    if post.raw_title.downcase == requested || post.raw_title.downcase.gsub('-', '_') == requested
      @post = post
    end
  end
end