class BrowsersController < ApplicationController
  def index
    @browsers = Browser.all
  end

  def show
    @browser = Browser.where(id: params[:id]).first
  end

  def edit
    @browser = Browser.where(id: params[:id]).first
  end

  def update
    @browser = Browser.where(id: params[:id]).first
    if @browser.update_attributes(params[:browser])
      redirect_to @browser
    else
      render :edit
    end
  end

  def new
    @browser = Browser.new
  end

  def create
    @browser = Browser.new params[:browser]
    if @browser.save
      redirect_to @browser
    else
      render :new
    end
  end

  def destroy
    @browser = Browser.find params[:id]
    if @browser.destroy
      redirect_to '/browsers'
    else
      redirect_to :back
    end
  end
end
