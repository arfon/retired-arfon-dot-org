require 'rubygems'
require 'sinatra'
require 'erb'

get '/?' do
  erb :index
end

get '/thesis?' do
  File.read 'views/thesis.html'
end

get '/*' do
  if @post
    File.read "views/posts/#{@post}.html"
  else
    File.read 'views/404.html'
  end
end

before do
  files = Dir.glob('views/posts/*.html')
  @posts = files.collect { |f| f.gsub('views/posts/', '').split('.').first }
  requested = request.path_info.gsub('/', '')
  @posts.each do |post|
    if post == requested
      @post = post
    end
  end
end

class String
  def titlecase
    non_capitalized = %w{of etc and by the for on is at to but nor or a via}
    gsub(/\b[a-z]+/){ |w| non_capitalized.include?(w) ? w : w.capitalize  }.sub(/^[a-z]/){|l| l.upcase }.sub(/\b[a-z][^\s]*?$/){|l| l.capitalize }
  end
end