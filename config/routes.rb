Rails.application.routes.draw do

  root 'home#index'

  resources :surveys, shallow: true, only: [:index, :show] do
    resources :documents, only: [:show, :update] do
      resources :flags, only: [:create, :update]
      patch 'responses', on: :member
    end
  end

  devise_for :users, :controllers => { :registrations => :registrations }

end
