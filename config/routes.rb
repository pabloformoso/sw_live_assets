Rails.application.routes.draw do
  root to: "home#index"
  get "/live_assets/:action", to: "live_assets"
end 
