require 'test_helper'

class PagesControllerTest < ActionController::TestCase
	include Devise::TestHelpers

	def setup
		@user = FactoryGirl.create(:user)
	end

  test "should get home" do
    get :home
    assert_response :success
  end
end
