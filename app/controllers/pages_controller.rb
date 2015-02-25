class PagesController < ApplicationController
  def home
  end

  def search
  	@sizes = Size.search(weight: params[:weight], height: params[:height])
  	             .paginate(page: params[:page], per_page: 10)
  end

  def about
  	
  end
end
