Rails.application.routes.draw do
  
  root to: 'welcome#index'
  get :home, to: 'pages#home'

  get 'analytics', to: 'pages#analytics'
  get 'articles/search', to: 'articles#search'
  post 'pages/save_query', to: 'pages#save_query'

  resources :articles, only: [:show,:index] do
    collection do
      get :search
    end
  end

  get 'analytics/global', to: 'analytics#global', as: 'global_analytics'
  get 'analytics/user', to: 'analytics#user', as: 'user_analytics'
  post 'welcome/consent', to: 'welcome#consent', as: 'give_consent'
  post 'pages/leave', to: 'pages#leave', as: 'leave'
end