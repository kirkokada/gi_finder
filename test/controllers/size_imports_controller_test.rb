require 'test_helper'

class SizeImportsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

	context 'Without signing in' do
		
		context ', get sizeimports#new' do
			setup do
				get :new
			end

			should 'redirect to sign in' do
				assert_redirected_to new_user_session_path
			end
		end

		context ', post sizeimports#create' do
			setup do
				post :create
			end

			should 'redirect to root' do
				assert_redirected_to new_user_session_path
			end
		end

		context 'as an admin,' do
			setup do
				sign_in FactoryGirl.create(:user, admin: false)
			end

			context 'get sizeimports#new' do
				setup do
					get :new
				end

				should 'redirect to root' do
					assert_redirected_to root_path
				end
			end

			context 'post sizeimports#create' do
				setup do
					post :create
				end

				should 'redirect to root' do
					assert_redirected_to root_path
				end
			end
		end
	end
end
