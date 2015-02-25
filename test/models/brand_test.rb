require 'test_helper'

class BrandTest < ActiveSupport::TestCase
  def setup
  	@brand = Brand.new(name:"Brand", 
                       url:"http://examplegibrand.com" )
  end

  test 'should be valid' do
  	assert @brand.valid?
  end

  context 'url' do
    
    should validate_presence_of(:url)
    
    %w[http://brand.com/ https://brand.com http://www.brand.com].each do |url|
      should allow_value(url).for(:url)
    end

  	%w[http://br@nd,com http/br%n#-gov br0;nc|.com].each do |url|
  		should_not allow_value(url).for(:url)
  	end

    context 'when "http://" prefix is missing' do
      setup do
        @brand.url.delete!('http://')
        @brand.save!
      end

      should 'be saved after appending "http://"' do
        assert @brand.reload.url.include?('http://')
      end
    end
  end

  context 'instagram username' do
    
    context 'when properly formatted' do
      %w[brand brAnd @bran_d].each do |name|
        should allow_value(name).for(:instagram_username)
      end
    end

    context 'when improperly formatted' do
      %w[br@nd brand! bran|)].each do |name|
        should_not allow_value(name).for(:instagram_username)
      end
    end

    context 'after changing' do

      should 'set profile picture' do
        @brand.instagram_username = 'brand'
        VCR.use_cassette 'user_search' do
          @brand.save
          @brand.reload
          assert_not @brand.profile_picture.nil?
        end
      end
    end
  end

  context 'fetching instagram media' do
    
    context 'with an instagram_username' do
      setup do
        @brand.save
        @brand.update_column(:instagram_username, 'brand') # Avoid API call on after_save hook
      end
      should 'get relevant media' do
        VCR.use_cassette 'tag_recent_media' do
          media = @brand.ig_media
          first_item = media.first
          assert first_item.tags.include?(@brand.instagram_username)
        end
      end
    end

    context 'without an instagram username' do
      setup do
        @brand.instagram_username = nil
        @brand.save
      end

      should 'get relevant media' do
        VCR.use_cassette 'tag_recent_media_no_username' do
          media = @brand.ig_media
          first_item = media.first
          assert_includes first_item.tags, @brand.usernameify(@brand.name)
        end
      end
    end

    context 'when search returns no tags' do
      setup do
        @brand.name = "Untaggable Brand Name For Lyfe"
        @brand.save
      end

      should 'return an empty hash' do
        VCR.use_cassette 'tag_recent_media_untagged_name' do
          media = @brand.ig_media
          assert_empty media
        end
      end
    end
  end

  test 'should import csv' do
  	file = fixture_file('brands.csv', 'text/csv')
  	assert_difference 'Brand.count', 3 do
	  	Brand.import(file)
  	end
  end
end
