Rails.application.routes.draw do
  resources :products, only: [:show]

  get 'index/index'
  post 'index/request_handler'

  root to: 'index#index'
end
