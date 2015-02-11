require 'test_helper'

class SignInTest < ActionDispatch::IntegrationTest

	def setup
		@user = users(:marcelo)
	end

	test 'should sign in with username' do
		post user_session_path, user: { login:    @user.username, 
		                                password: 'password'} 
		get root_path
		assert_select 'a[href=?]', destroy_user_session_path
	end

	test 'should sign in with email' do
		post user_session_path, user: { login:    @user.email,
		                                password: 'password'}
	end
end
