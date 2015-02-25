require 'test_helper'

class BrandShowPageTest < ActionDispatch::IntegrationTest
	def setup
		@brand = FactoryGirl.create(:brand)
	end

	context 'as non-signed in user' do

		context 'after setting instagram user name' do
			
			setup do
				VCR.use_cassette 'brand_after_ig_username_save' do
					@brand.instagram_username = @brand.name
					@brand.save
				end
				VCR.use_cassette 'brand#show_with_ig_username' do
					get brand_path(@brand)
					assert_response :success
				end
			end

			should 'show instagram profile picture' do
				assert_select 'img[src=?]', @brand.profile_picture
			end

			should 'not show admin links' do
				assert_select 'a[href=?]', edit_brand_path(@brand), count: 0
				assert_select 'a[href=?]', new_brand_size_path(@brand), count: 0
			end

			should 'show tagged media from instagram' do
				feed_items = assigns(:feed_items)
				assert_not feed_items.empty?
				assert_select 'div.feed_item'
			end
		end

		context 'without setting instagram username' do
			setup do
				VCR.use_cassette'brand#show_without_ig_username' do
					get brand_path(@brand)
					assert_response :success
				end
			end

			should 'not show admin links' do
				assert_select "a[href=?]", edit_brand_path(@brand), count: 0
				assert_select "a[href=?]", new_brand_size_path(@brand), count: 0
			end

			should 'show tagged media from instagram' do
				feed_items = assigns(:feed_items)
				assert_not feed_items.empty?
				assert_match @brand.usernameify(@brand.name), response.body
			end
		end

		context 'when no Instagram tags are found' do
			setup do
				VCR.use_cassette 'brand_show_no_tags' do
					@brand.name = "No Tags for Old Men and Stuff 2077"
					@brand.save
					get brand_path(@brand)
				end
			end

			should 'get page' do
				assert_response :success
			end

			should 'not show feed items' do
				assert_select 'div.feed_item', count: 0
			end
		end
	end

	context 'as admin user' do
		setup do
			sign_in FactoryGirl.create(:user, admin: true)
			VCR.use_cassette'brand#show_without_ig_username' do
				get brand_path(@brand)
				assert_response :success
			end
		end

		should 'show admin links' do
			assert_select "a[href=?]", edit_brand_path(@brand)
			assert_select "a[href=?]", new_brand_size_path(@brand)
		end
	end
end
