Rails.application.routes.draw do
  get "leaves/index"
  get "leaves/show"
  get "leaves/new"
  get "leaves/create"
  get "leaves/edit"
  get "leaves/update"
  get "leaves/delete"
  get "leaves/destroy"

  get "leaves/leave_action"
  post "leaves/leave_action"



  get "sessions/index"
  get "sessions/show"
  get "sessions/new"
  get "sessions/create"
  get "sessions/edit"
  get "sessions/update"
  get "sessions/delete"
  get "sessions/destroy"
  get "sessions/admin_page"
  post "sessions/admin_page"
  get "sessions/month_record"
  post "sessions/month_record"
  get "sessions/user_record"
  post "sessions/user_record"
  get "sessions/name_search"
  post "sessions/name_search"
  get "sessions/status_search"
  post "sessions/status_search"
  get "sessions/getQuota"
  post "sessions/getQuota"
  
  get "users/index"
  post "users/show"
  
  get "users/new"
  post "users/create"

  get "users/edit"
  post "users/update"

  get "users/delete"
  post "users/destroy"

  root 'sessions#new'

  #resources :leaves
  resources :users
  resources :sessions
  match ':controller(/:action(/:id))(.:format)', :via =>[:get,:post]

end
