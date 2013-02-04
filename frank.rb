%w{rubygems sinatra erb crack open-uri hashie date twitter}.each { |dep| require dep }

Twitter.configure do |config|
  config.consumer_key = ENV['TWITTER_CONSUMER_KEY']
  config.consumer_secret = ENV['TWITTER_CONSUMER_SECRET']
  config.oauth_token = ENV['TWITTER_OAUTH_TOKEN']
  config.oauth_token_secret = ENV['TWITTER_OAUTH_SECRET']
end

class Tweet < Hashie::Dash
  property :id
  property :text
  property :date
  
  def url
    "http://twitter.com/arfon/status/#{self.id}"
  end
  
  def auto_linked_text
    self.text.gsub /((https?:\/\/|www\.)([-\w\.]+)+(:\d+)?(\/([\w\/_\.]*(\?\S+)?)?)?)/, %Q{<a href="\\1">\\1</a>}
  end
  
  def self.parse_recent_tweets
    begin
      tweets = Twitter.user_timeline('arfon', :count => 50).select {|t| !t.retweet? }.slice(0,5)
      tweets.collect { |p| Tweet.new(:id => p.id, :text => p.text, :date => p.created_at)}
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
  
  def url_matches?(requested)
    # need the second condition because of my previous love affair with hyphens
    self.raw_title.downcase == requested || self.raw_title.downcase.gsub('-', '_') == requested
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
    status 404
    File.read 'views/404.html' 
  end
end

# this method looks at all of the static HTML files in 'views/posts' and checks if the URL being requested matches any of the files
before do
  # cache views for 30 minutes (Heroku Varnish cache)
  response.headers['Cache-Control'] = 'public, max-age=900'
  # build list of posts from 
  files = Dir.glob('views/posts/*.html')
  @posts = []
  files.each do |file|
    title_and_date = file.gsub('views/posts/', '').split('.')
    @posts << Post.new(:raw_title => title_and_date[0], :raw_posted_at => title_and_date[1])
  end
    
  @posts = @posts.sort { |a,b| b.posted_at <=> a.posted_at }  
  
  requested = request.path_info.gsub('/', '')
  @posts.each do |post|
    if post.url_matches?(requested)
      @post = post
    end
  end
end