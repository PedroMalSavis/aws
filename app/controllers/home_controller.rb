class HomeController < ApplicationController

  def index
    @posts = Post.all.order(created_at: :desc)
    @products = Product.all
  end

  def test
  end
end
