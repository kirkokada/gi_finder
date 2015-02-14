require 'test_helper'

class SizeTest < ActiveSupport::TestCase
  def setup
  	@brand = Brand.create(name: "Example Brand", url: "http://examplebrand.com")
  	@size = @brand.sizes.build(name: "A1", 
  		                         min_height: 62,
  		                         max_height: 65,
  		                         min_weight: 110,
  		                         max_weight: 145)
  end

  test 'should be valid' do
  	assert @size.valid?
  end

  test 'name should be unique for brand' do
  	dup_size = @size.dup
  	@size.name.downcase
  	@size.save
  	assert_not dup_size.valid?
  end

  test 'min weight should be a non-negative number' do
  	@size.min_weight = 'a'
  	assert_not @size.valid?
  	@size.min_weight = -1
  	assert_not @size.valid?
  end

  test 'max weight should be a non-negative number' do
  	@size.max_weight = 'a'
  	assert_not @size.valid?
  	@size.max_weight = -1
  	assert_not @size.valid?
  end

  test 'min height should be a non-negative number' do
  	@size.min_height = 'a'
  	assert_not @size.valid?
  	@size.min_height = -1
  	assert_not @size.valid?
  end

  test 'max height should be a non-negative number' do
  	@size.max_height = 'a'
  	assert_not @size.valid?
  	@size.max_height = -1
  	assert_not @size.valid?
  end
end
