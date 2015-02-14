require 'test_helper'

class BrandImportingExportingTest < ActionDispatch::IntegrationTest
	def setup
		@user = FactoryGirl.create(:user, admin: true)
		sign_in @user
	end

	test 'should successfully import and export csv' do
		file = fixture_file('brands.csv', 'text/csv')
		assert_difference "Brand.count", 3 do
			post import_brands_path, file: file
		end
		assert_redirected_to brands_url
		get brands_path, format: :csv
		assert_equal CSV.parse(file), CSV.parse(response.body)
	end
end
