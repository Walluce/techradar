Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  root to: "home#show"
  devise_for :users, controllers: { registrations: "registrations" }, path: "account"
  get "/:username", constraints: UsernameConstraint, controller: "users", action: "show"
  resources :users, only: %i[index show], param: :username do
    resources :radars, only: :index, controller: "users/radars"
  end

  resources :radars, except: [:index] do
    resources :blips, controller: "radars/blips", except: :index
  end

  get "/radars/:id/:quadrant", controller: "radars/quadrants", action: "show", as: "radar_quadrant"
  resources :topics, only: %i[show new create]
  resources :bulk_topics, only: %i[new create]
  get "/about", controller: "pages", action: "about"

  namespace "api" do
    namespace "v1" do
      resources :radars, only: :show
    end
  end
end
