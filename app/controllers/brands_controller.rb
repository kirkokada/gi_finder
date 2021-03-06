class BrandsController < ApplicationController
	before_action :authenticate_user!, except: [:show]
	before_action :is_admin?, except: [:show]

	def new
		@brand = Brand.new()
	end

	def create
		@brand = Brand.new(brand_params)
		if @brand.save
			redirect_to brands_url
		else
			render 'new'
		end
	end

	def edit
		@brand = Brand.friendly.find(params[:id])
	end

	def update
		@brand = Brand.friendly.find(params[:id])
		if @brand.update_attributes(brand_params)
			flash[:success] = "Brand updated."
			redirect_to brands_url
		else
			render 'edit'
		end
	end

	def index
		@brands = Brand.all
		@size_import = SizeImport.new
		respond_to do |format|
			format.html { @brands = @brands.paginate(page: params[:page]) }
			format.csv do 
				send_data(@brands.to_csv)
			end
			format.xls
		end
	end

	def import
		Brand.import(params[:file])
		redirect_to brands_url
	end

	def destroy
		Brand.friendly.find(params[:id]).destroy
		redirect_to brands_url
	end

	def show
		@brand = Brand.friendly.find(params[:id])
		@sizes = @brand.sizes
		@feed_items = @brand.ig_media
	end

	private

		def brand_params
			params.require(:brand).permit(:name, :url, :instagram_username, :profile_picture)
		end
end
