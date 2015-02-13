ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "minitest/reporters"
Minitest::Reporters.use!

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
