Botly::Application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  resources :sessions

  resources :products
  resources :proxies do
    collection do
      put :reset
    end
  end
  resources :browsers
  root to: 'dashboard#index'
end
