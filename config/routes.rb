Rails.application.routes.draw do
  namespace :v1 do
    post 'user/check_status', to: 'users#check_status'
  end
end
