class IndexController < ApplicationController
  def index
    @products = Product.order(:title)
  end

  def request_handler
    Product.handle_product(params[:url])
    redirect_to root_path
  end
end
