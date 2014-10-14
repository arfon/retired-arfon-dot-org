require File.expand_path('../../frank', __FILE__)
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
    assert_equal 'public, max-age=900', last_response.headers['Cache-Control']
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

  def test_posts
    get '/posts'
    assert last_response.ok?
    assert last_response.body.include?('Weakly Typed - The Online Home of Arfon Smith')
  end
end

class PostTest < Test::Unit::TestCase
  def test_methods
    post = Post.new
    %w{ raw_title raw_posted_at file_name title posted_at formatted_posted_at url_matches? }.each { |method| assert post.respond_to?(method)}
  end

  def mock_post
    Post.new(:raw_posted_at => '2009-06-09', :raw_title => 'Hello-Arfon')
  end

  def test_file_name
    post = mock_post
    assert_equal "views/posts/#{post.raw_title}.#{post.raw_posted_at}.html", post.file_name
  end

  def test_url
    post = mock_post
    assert_equal 'Hello Arfon', post.title
  end

  def test_posted_at
    post = mock_post
    assert post.posted_at.is_a?(DateTime)
  end

  def test_formatted_posted_at
    post = mock_post
    assert_equal '09 June 2009', post.formatted_posted_at
  end

  def test_url_matches?
    post = mock_post
    assert post.url_matches?('hello_arfon')
    assert post.url_matches?('hello-arfon')
  end
end

class TweetTest < Test::Unit::TestCase
  def test_class_methods
    assert Tweet.respond_to?(:parse_recent_tweets)
  end

  def test_methods
    @tweet = Tweet.new
    %w{ id text date url }.each { |method| assert @tweet.respond_to?(method)}
  end

  def test_url
    tweet = Tweet.new(:id => '1234')
    assert "http://twitter.com/arfon/status/#{tweet.id}", tweet.url
  end
end
