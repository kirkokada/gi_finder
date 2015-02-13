require 'test_helper'

class BrandTest < ActiveSupport::TestCase
  def setup
  	@brand = Brand.new(name:"Example Gi Brand", url:"http://examplegibrand.com" )
  end

  test 'should be valid' do
  	assert @brand.valid?
  end

  test 'url should be present' do
  	@brand.url = nil
  	assert_not @brand.valid?
  end

  test 'url should be properly formatted' do
  	%w[br@nd,com br%n#-gov br0;nc|.com].each do |url|
  		@brand.url = url
  		assert_not @brand.valid?, "#{url} should not be valid"
  	end
  end

  test 'should append "http://" if missing' do
  	@brand.url.delete!('http://')
  	@brand.save!
  	assert @brand.reload.url.include?('http://')
  end

  test 'should import csv' do
  	file = fixture_file('test.csv', 'text/csv')
  	assert_difference 'Brand.count', 3 do
	  	Brand.import(file)
  	end
  end
end
