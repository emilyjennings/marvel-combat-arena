Rails.application.routes.draw do

  get '/play', to: 'characters#play'
  post '/play', to: 'characters#character_play'
  get '/one_player', to: 'characters#one_player_mode_play'
  post '/one_player', to: 'characters#one_player_mode'
  post '/searchByLetter', to: 'characters#searchByLetter'
  root 'sessions#new'
  #I needed to make a way to post these forms to the controller - for instance below I made a post request to the winner method in the characters controller when a player wants to see the winner
  post '/winner', to: 'characters#winner'
  #The player will get redirected to a new page to see the winner - so I added that view to the pages in the resource below
  get '/searchByLetter', to: 'characters#index'
  get   '/signup', to: 'users#new'
  get   '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'


  resources :characters
  resources :points
  resources :users do
    resources :characters
  end

end
