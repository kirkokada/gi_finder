require 'test_helper'

class SizesTest < ActionDispatch::IntegrationTest
	def setup
		@user = FactoryGirl.create(:user, admin: true)
		@brand = FactoryGirl.create(:brand)
		@size = FactoryGirl.create(:size, brand: @brand)
		sign_in @user
	end

	test 'new size with invalid information' do
		get new_brand_size_path(@brand)
		assert_select 'h2', text: "New Size"
		assert_no_difference "@brand.sizes.count" do
			post brand_sizes_path(@brand), size: { name: "",
	                                           min_height: 0,
                                             max_height: -1,
	                                           min_weight: 0,
	                                           max_weight: 0
	                                         }
    end
    size = assigns(:size)
		assert_not size.errors.empty?
		assert_template 'new'
	end

	test 'new size with valid information' do
		get new_brand_size_path(@brand)
		assert_select 'h2', text: "New Size"
		assert_difference "@brand.sizes.count", 1 do		
			post brand_sizes_path(@brand), size: { name: "Size",
                                             min_height: 60,
                                             max_height: 70,
                                             min_weight: 140,
                                             max_weight: 150
                                           }
		end
    size = assigns(:size)
		assert size.errors.empty?
		assert_redirected_to @brand
	end

	test 'edit size with invalid information' do
		get edit_brand_size_path(@brand, @size)
		assert_select 'h2', text: "Edit Size"
		patch brand_size_path(@brand, @size), size: { name: "",
                                                  min_height: 0,
                                                  max_height: -1,
                                                  min_weight: 0,
                                                  max_weight: 0
                                                }
    size = assigns(:size)
		assert_not size.errors.empty?
		assert_template 'new'
	end

	test 'edit size with valid information' do
		patch brand_size_path(@brand, @size), size: { name: "A69",
                                                  min_height: 100,
                                                  max_height: 150,
                                                  min_weight: 300,
                                                  max_weight: 500
                                                }
    size = assigns(:size)
		assert size.errors.empty?
		assert_redirected_to @brand
	end

	test 'delete size' do
		assert_difference '@brand.sizes.count', -1 do
			delete brand_size_path(@brand, @size)
		end
		assert_not_includes @brand.sizes, @size
	end
end
