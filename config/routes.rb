Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    resources :microposts
    resources :users
  end
end
