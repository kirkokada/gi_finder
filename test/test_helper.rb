ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "minitest/reporters"
require 'sidekiq/testing'

Minitest::Reporters.use!

Sidekiq::Testing.inline!

VCR.configure do |config|
  config.cassette_library_dir = "test/vcr_cassettes"
  config.hook_into :webmock
  config.allow_http_connections_when_no_cassette = false
  config.filter_sensitive_data '[*REDACTED*]' do 
    ENV['INSTAGRAM_CLIENT_ID'] 
  end
end

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  def sign_in(user)
  	post user_session_path, user: { login: user.username,
  	                                password: 'password'}
  end

  def fixture_file(filename, mime_type)
  	filepath = fixture_path + "/#{filename}"
		Rack::Test::UploadedFile.new(filepath, mime_type)
  end
end


