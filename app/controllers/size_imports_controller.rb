class SizeImportsController < ApplicationController
	before_action :authenticate_user!
	before_action :is_admin?

  def new
  	@size_import = SizeImport.new
  end

  def create
  	@size_import = SizeImport.new(params[:size_import])
  	if @size_import.save
  		flash[:success] = "Size import successful"
  		redirect_to brands_path
  	else
  		render :new
  	end
  end
end
