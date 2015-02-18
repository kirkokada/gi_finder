require 'test_helper'

class SearchTest < ActionDispatch::IntegrationTest			
	def setup
		@brand_1 = FactoryGirl.create(:brand, name: "Brand 1",
			                                    url: "http://brand1.com")
		@brand_2 = FactoryGirl.create(:brand, name: "Brand 2",
			                                    url: "http://brand2.com")
		@size_1 = FactoryGirl.create(:size, brand: @brand_1,
																				name: "A1",
			                                  min_height: 60,
			                                  max_height: 65,
			                                  min_weight: 100,
			                                  max_weight: 130)
		@size_2 = FactoryGirl.create(:size, brand: @brand_2,
																				name: "A2",
			                                  min_height: 65,
			                                  max_height: 70,
			                                  min_weight: 130,
			                                  max_weight: 160)
	end

	test "should return only matching sizes" do
		get search_path, height: @size_2.max_height, 
		                     weight: @size_2.max_weight
		sizes = assigns(:sizes)
		assert_not sizes.nil?
		assert_not sizes.include?(@size_1)
		assert sizes.include?(@size_2)
	end

	test "should not return anything if no matches" do
		# An impossibly large person
		get search_path, height: 100,
		                 weight: 500
		sizes = assigns(:sizes)
		assert sizes.empty?
	end
end
