require 'rubygems'
require 'sinatra'
require 'erb'

get '/?' do
  erb :index
end

get '/thesis?' do
  erb :thesis
end

get '/autoscaling-on-aws-without-bundling-amis' do
  erb 'posts/autoscaling-on-aws-without-bundling-amis'.to_sym
end

get '/scaling-galaxy-zoo-with-sqs' do
  erb 'posts/scaling-galaxy-zoo-with-sqs'.to_sym
end

get '/a-first-look-at-the-amazon-relational-database-service' do
  erb 'posts/a-first-look-at-the-amazon-relational-database-service'.to_sym
end

