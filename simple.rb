require 'rubygems'
require 'extensions/all'
require 'sinatra'
require 'simple_record'

AWS_ACCESS_KEY_ID='AKIAIAFEKFHWPNPTZGZQ'
AWS_SECRET_ACCESS_KEY='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'
SimpleRecord.establish_connection(AWS_ACCESS_KEY_ID,AWS_SECRET_ACCESS_KEY)
SimpleRecord::Base.set_domain_prefix("arfon_frank_")

class Person < SimpleRecord::Base
  has_attributes :name, :age
end

get '/' do
  start_time = Time.now
  (1..100).each do |i|
    person = Person.new(:name => "#{i}_name", :age => i)
    person.save
  end
  "#{Time.now - start_time}"
end

get '/count' do 
  "#{Person.find(:count)}"
end

get '/all' do
  persons = Person.all
  array = []
  persons.each { |p| array << {'name' => p.name, 'age' => p.age} }
  "#{array.to_s}"
end

get '/delete' do
  Person.all.each {|p| p.destroy}
  # Person.destroy_all(:conditions => ['created_at > ?', 3.weeks.ago])
end