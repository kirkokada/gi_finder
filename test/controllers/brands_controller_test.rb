require 'test_helper'

class BrandsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  test "should redirect protected actions when not signed in" do
  	get :new
  	assert_redirected_to new_user_session_path
  	get :edit, id: 1
  	assert_redirected_to new_user_session_path
  	post :create
  	assert_redirected_to new_user_session_path
  	patch :update, id: 1
  	assert_redirected_to new_user_session_path
  	get :index
  	assert_redirected_to new_user_session_path
  end

  test "should redirect protected actions when not admin" do
  	sign_in FactoryGirl.create(:user, admin: false)
  	get :new
  	assert_redirected_to root_url
  	get :edit, id: 1
  	assert_redirected_to root_url
  	post :create
  	assert_redirected_to root_url
  	patch :update, id: 1
  	assert_redirected_to root_url
  	get :index
  	assert_redirected_to root_url
  end
end
