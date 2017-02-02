require 'spec_helper'

RSpec.describe ProductsController do
  context 'index' do
    it 'returns 200' do
      get :index
      assert_response 200
    end

    it 'gets the products' do
      get :index
      expect(assigns[:products]).not_to be_nil
    end
  end
end
