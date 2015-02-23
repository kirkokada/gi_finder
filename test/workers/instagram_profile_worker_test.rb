require 'test_helper'

class InstagramProfileWorkerTest < ActiveSupport::TestCase
	setup do
		@brand = FactoryGirl.create(:brand)
	end

	should 'set brand profile picture' do
		@brand.update_column(:instagram_username, "brand")
		VCR.use_cassette 'user_search' do
			InstagramProfileWorker.perform_async(@brand.id)
		end	
		assert_match '.jpg', @brand.reload.profile_picture
	end
end