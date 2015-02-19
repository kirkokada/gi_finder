require 'test_helper'

class SearchTest < ActionDispatch::IntegrationTest
	context "search by height and weight"	do
		setup do
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
				                                  min_height: 66,
				                                  max_height: 70,
				                                  min_weight: 131,
				                                  max_weight: 160)
		end

		context 'with matching sizes' do
			setup do
				get search_path height: @size_1.max_height, 
	                      weight: @size_1.max_weight
	      @sizes = assigns(:sizes)
			end

			should 'not return non-matching sizes' do
				assert_not @sizes.include?(@size_2)
			end

			should 'return matching sizes' do
				assert @sizes.include?(@size_1)
			end
		end

		context "seach with no matching sizes" do
			setup do
				get search_path, height: 100,
				                 weight: 500
				@sizes = assigns(:sizes)			
			end
			
			should 'not return any sizes' do
				assert @sizes.empty?
			end
		end
	end
end
