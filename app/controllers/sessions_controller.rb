class SessionsController < ApplicationController
  def index
    @sessions = Session.order(:updated_at).reverse_order.limit(50)
  end

  def show
    @session = Session.find params[:id]
  end
end
