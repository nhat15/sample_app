Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"
    resources :users, only: [:new, :show, :create]
    get "/help", to:"static_pages#help"
    get "/about", to:"static_pages#about"
    get "/contact", to:"static_pages#contact"
    get "/signup", to: "users#new"
  end
end
