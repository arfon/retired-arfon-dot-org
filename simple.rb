require 'rubygems'
require 'sinatra'
require 'erb'

get '/?' do
  File.read 'views/index.html'
end

get '/thesis?' do
  File.read 'views/thesis.html'
end

get '/autoscaling-on-aws-without-bundling-amis' do
  File.read 'views/posts/autoscaling-on-aws-without-bundling-amis.html'
end

get '/scaling-galaxy-zoo-with-sqs' do
  File.read 'views/posts/scaling-galaxy-zoo-with-sqs.html'
end

get '/a-first-look-at-the-amazon-relational-database-service' do
  File.read 'views/posts/a-first-look-at-the-amazon-relational-database-service.html'
end

