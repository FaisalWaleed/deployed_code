class ProxiesController < ApplicationController
  def index
    @proxy_count = ProxyUrl.active_count
    @proxies = Proxy.all
  end

  def show
    @proxy = Proxy.where(id: params[:id]).first
  end

  def edit
    @proxy = Proxy.where(id: params[:id]).first
  end

  def update
    @proxy = Proxy.where(id: params[:id]).first
    if @proxy.update_attributes(params[:proxy])
      redirect_to @proxy
    else
      render :edit
    end
  end

  def new
    @proxy = Proxy.new
  end

  def create
    @proxy = Proxy.new params[:proxy]
    if @proxy.save
      redirect_to @proxy
    else
      render :new
    end
  end

  def reset
    ProxyUrl.update_all(burnt: false)
    redirect_to action: :index
  end
end
