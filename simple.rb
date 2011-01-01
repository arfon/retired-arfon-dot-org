require 'rubygems'
require 'sinatra'
require 'erb'

get '/?' do
  erb :index
end

get '/autoscaling-on-aws-without-bundling-amis' do
  erb 'posts/autoscaling-on-aws-without-bundling-amis'.to_sym
end

