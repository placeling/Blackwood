require 'subdomain'

Blackwood::Application.routes.draw do

  match "category/:category" => redirect("/category/%{category}/list")
  match "category/:category/list" => 'home#list'
  match "category/:category/map" => 'home#map'
  match "category/:category/mapdata" => 'home#mapdata'
  match "places/:id" => "home#place"
  match "ping" => 'home#ping'
  match "/style" => 'home#style'

  constraints(Subdomain) do
    match '/' => 'home#index'
  end

  mount Resque::Server, :at => "/resque"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
