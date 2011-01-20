require 'frank'
require 'test/unit'
require 'rack/test'

set :environment, :test

class FrankTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end
  
  def test_index
    get '/'
    assert last_response.ok?
    assert last_response.body.include?('Hello, I\'m Arfon Smith')
    assert_equal 'public, max-age=300', last_response.headers['Cache-Control']
  end

  def test_thesis_renders_thesis_page
    get '/thesis?'
    assert last_response.ok?
    assert last_response.body.include?('Arfon Smith PhD Thesis')
  end
  
  def test_404
    get '/blah'
    assert last_response.not_found?
    assert last_response.body.include?('404 Page not found')
  end
end