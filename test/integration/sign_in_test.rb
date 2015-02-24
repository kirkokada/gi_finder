require 'test_helper'

class SignInTest < ActionDispatch::IntegrationTest

	def setup
		@user = FactoryGirl.create(:user)
	end

	test 'should sign in with username' do
		# Test of the sign_in helper method, which uses username as login
		sign_in @user 
		get root_path
		# assert_select 'a[href=?]', destroy_user_session_path
	end

	test 'should sign in with email' do
		post user_session_path, user: { login:    @user.email,
		                                password: @user.password }
		get root_path
		# assert_select 'a[href=?]', destroy_user_session_path
	end
end
