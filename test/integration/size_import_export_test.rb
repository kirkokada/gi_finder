require 'test_helper'

class SizeImportExportTest < ActionDispatch::IntegrationTest
  def setup
  	@user = FactoryGirl.create(:user, admin: true)
  	@brand = FactoryGirl.create(:brand)
  	sign_in @user
  end

  test 'should successfully import and export valid csv' do
  	file = fixture_file('sizes.csv', 'text/csv')
  	assert_difference "@brand.sizes.count", 3 do
  		post import_brand_sizes_path(@brand), file: file
  	end
  	assert_redirected_to @brand
  	get brand_sizes_path(@brand), format: :csv
  	assert_response :success
  end

  test 'should only import records for the associated brand' do
  	csv_rows = <<-eos.gsub(/^ {4}/, '')
  	brand_id,name,min_height,max_height,min_weight,max_weight
  	20,size,40,1,1,1
  	eos
  	file = Tempfile.new('wrong_brand_size.csv')
  	file.write(csv_rows)
  	file.rewind
  	assert_no_difference 'Size.count' do
  		post import_brand_sizes_path(@brand), 
  		     file: Rack::Test::UploadedFile.new(file, 'text/csv')
  	end
  end

  context 'import via brand slug' do
    setup do
      csv_rows = <<-eos.gsub(/^ {8}/, '')
        brand_slug,name,min_height,max_height,min_weight,max_weight
        #{@brand.slug},A1,65,70,130,150
        eos
      @file = Tempfile.new(['import', '.csv']) # ensures '.csv' filepath ending
      @file.write(csv_rows)
      @file.rewind
      @file = Rack::Test::UploadedFile.new(@file, 'text/csv')
    end

    should 'create new size' do
      assert_difference 'Size.count', 1 do
        post size_imports_path, size_import: { file: @file }
      end
    end

    should 'have the right association' do
      post size_imports_path, size_import: { file: @file }
      assert_equal @brand, Size.last.brand
    end
  end
end
