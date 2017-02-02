class ProductsController < ApplicationController
  def index
    page = params[:page] || 1
    @products = Product.includes(:sessions).page(page).per(20)
  end

  def show
    @product = Product.where(id: params[:id]).first
  end

  def edit
    @product = Product.where(id: params[:id]).first
  end

  def update
    @product = Product.where(id: params[:id]).first
    if @product.update_attributes(params[:product])
      redirect_to @product
    else
      render :edit
    end
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new params[:product]
    if @product.save
      redirect_to @product
    else
      render :new
    end
  end

  def destroy
    @product = Product.find params[:id]
    if @product.destroy
      redirect_to '/products'
    else
      redirect_to :back
    end
  end
end
