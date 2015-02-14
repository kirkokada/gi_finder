require 'test_helper'

class SizesControllerTest < ActionController::TestCase
	include Devise::TestHelpers

	def setup
		@brand = FactoryGirl.create(:brand)
		@user =  FactoryGirl.create(:user)
	end

  test "should redirect protected actions when not signed in" do
  	get :new, brand_id: @brand.id
  	assert_redirected_to new_user_session_path
  	get :edit, id: 1, brand_id: @brand.id
  	assert_redirected_to new_user_session_path
  	post :create, brand_id: @brand.id
  	assert_redirected_to new_user_session_path
  	patch :update, id: 1, brand_id: @brand.id
  	assert_redirected_to new_user_session_path
  	delete :destroy, id: 1, brand_id: @brand.id
  	assert_redirected_to new_user_session_path
    get :index, brand_id: @brand.id
    assert_redirected_to new_user_session_path
  end

  test "should redirect protected actions when not admin" do
  	sign_in @user
  	get :new, brand_id: @brand.id
  	assert_redirected_to root_url
  	get :edit, id: 1, brand_id: @brand.id
  	assert_redirected_to root_url
  	post :create, brand_id: @brand.id
  	assert_redirected_to root_url
  	patch :update, id: 1, brand_id: @brand.id
  	assert_redirected_to root_url
  	delete :destroy, id: 1, brand_id: @brand.id
  	assert_redirected_to root_url
    get :index, brand_id: @brand.id
    assert_redirected_to root_url
  end
end
