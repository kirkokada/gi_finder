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

  test 'should have brand_id' do
    @size.brand_id = nil
    assert_not @size.valid?
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

  context 'search' do
    
    setup do
      @size_1 = @brand.sizes.create(name: "A1", 
                                    min_height: 62,
                                    max_height: 65,
                                    min_weight: 110,
                                    max_weight: 145)
      @size_2 = @brand.sizes.create(name: "A2", 
                                    min_height: 63,
                                    max_height: 68,
                                    min_weight: 130,
                                    max_weight: 160)
    end

    should "not return sizes that don't match measurements" do
      results = Size.search(height: 200, weight: 900)
      assert results.empty?
    end

    should "only return matching sizes" do
      results = Size.search(height: 62, weight: 110)
      assert_equal @size_1, results.first
      assert_not results.include?(@size_2)
    end

    should "return sizes in order of closeness to max measurements" do
      results = Size.search(height: 64, weight: 140)
      assert @size_1, results.first
      assert @size_2, results.last
    end
  end
end
