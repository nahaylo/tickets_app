Rails.application.routes.draw do

  root 'ticket#create'

  get 'ticket/:hex' => 'ticket#view', as: :view_ticket
  get 'create' => 'ticket#create', as: :create_ticket
  post 'new' => 'ticket#new', as: :new_ticket
  post 'update/:hex' => 'ticket#update', as: :update_ticket

  devise_for :users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

end
