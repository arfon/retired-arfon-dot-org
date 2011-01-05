require 'rubygems'
require 'sinatra'
require 'erb'
require 'crack'
require 'open-uri'
require 'hashie'
require 'date'

class Tweet < Hashie::Dash
  property :id
  property :text
  property :date
  
  def url
    "http://twitter.com/arfon/status/#{self.id}"
  end
  
  def self.parse_recent_tweets
    begin
      file = open('http://twitter.com/statuses/user_timeline/617243.json')
      parsed = Crack::JSON.parse(file.read).slice(0,5)
      parsed.collect { |p| Tweet.new(:id => p['id'], :text => p['text'], :date => DateTime.parse(p['created_at']))}
    rescue
      return false
    end
  end
end

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
  @tweets = Tweet.parse_recent_tweets
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
  response.headers['Cache-Control'] = 'public, max-age=300'
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