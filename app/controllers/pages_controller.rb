class PagesController < ApplicationController
  def home
  end

  def search
  	@sizes = Size.search(weight: params[:weight], height: params[:height])
  end
end
