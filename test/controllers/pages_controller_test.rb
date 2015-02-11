require 'test_helper'

class PagesControllerTest < ActionController::TestCase
	include Devise::TestHelpers

	def setup
		@user = users(:marcelo)
	end

  test "should get home" do
    get :home
    assert_response :success
  end
end
