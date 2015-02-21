require 'test_helper'

class BrandImportingExportingTest < ActionDispatch::IntegrationTest
	def setup
		@user = FactoryGirl.create(:user, admin: true)
		sign_in @user
		@file = fixture_file('brands.csv', 'text/csv')
	end

	test 'should successfully import csv file' do
		assert_difference "Brand.count", 3 do
			post import_brands_path, file: @file
		end
		assert_redirected_to brands_url
	end

	context 'exported brand list csv file' do
		setup do
			post import_brands_path, file: @file
			get brands_path, format: :csv
		end
		
		should 'contain the accessible attributes' do
			Brand.all.each do |brand|
				Brand.accessible_attributes.each do |attribute|
					assert_match brand.send(attribute).to_s, response.body
				end
			end
		end		
	end
end
