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
  "Hello, I'm Arfon Smith.  I work at the <a href='http://zooniverse.org' target='_blank'>Zooniverse</a>.  If you need to contact me then you can email me on <a href='mailto:arfon@zooniverse.org'>arfon@zooniverse.org</a> or find me <a href='http://twitter.com/arfon' target='_blank'>on Twitter</a>."
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