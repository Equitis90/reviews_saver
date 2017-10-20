class ProductsController < ApplicationController
  def show
    keyword = params[:keyword]
    @reviews = Review.where(product_id: params[:id]).order(:date)
    @reviews = @reviews.where('comment ilike ?', "%#{keyword}%") unless keyword.blank?
  end
end
