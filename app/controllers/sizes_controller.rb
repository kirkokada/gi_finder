class SizesController < ApplicationController
	before_action :authenticate_user!
	before_action :is_admin?
	before_action :find_brand

  def new
  	@size = @brand.sizes.build()
  end

  def create
  	@size = @brand.sizes.build(size_params)
  	if @size.save
  		flash[:success] = "Size added."
  		redirect_to @brand
  	else
  		render :new
  	end
  end

  def edit
  	@size = @brand.sizes.find(params[:id])
  	render 'new'
  end

  def update
  	@size = @brand.sizes.find(params[:id])
  	if @size.update_attributes(size_params)
  		flash[:success] = "Size updated."
  		redirect_to @brand
  	else
  		render 'new'
  	end
  end

  def destroy
  	@brand.sizes.find(params[:id]).destroy
  	flash[:success] = "Size destroyed."
  	redirect_to @brand
  end

  def index
    @sizes = @brand.sizes
    respond_to do |format|
      format.html
      format.csv do 
        send_data @sizes.to_csv, filename: "#{@brand.slug}_sizes.csv"
      end
    end
  end

  def import
    Size.import(params[:file], brand_id: @brand.id)
    redirect_to @brand
  end

  private

  def size_params
  	params.require(:size).permit(:name, :max_height, :min_height, :max_weight, :min_weight)
  end

  def find_brand
  	@brand = Brand.friendly.find(params[:brand_id])
  end
end
