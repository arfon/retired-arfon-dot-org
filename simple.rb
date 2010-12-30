require 'sinatra'
require 'simple_record'

AWS_ACCESS_KEY_ID='AKIAIAFEKFHWPNPTZGZQ'
AWS_SECRET_ACCESS_KEY='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'
SimpleRecord.establish_connection(AWS_ACCESS_KEY_ID,AWS_SECRET_ACCESS_KEY)

class Person < SimpleRecord::Base
  has_attributes :name, :age
end

get '/' do
  start_time = Time.now
  (1..1000).each do |i|
    Person.create(:name => "#{i_name}", :age => i)
  end
  "#{Time.now - start_time}"
end

get '/count' do
  "There are: #{Person.count} Persons"
end