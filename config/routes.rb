ActionController::Routing::Routes.draw do |map|
  map.resources :neighborhoods

  map.resources :memberships, :member => {:unsuscribe => :delete, :suscribe => :post}

  map.resources :transacts

  map.resources :groups, 
    :member => { :join => :post, 
                 :leave => :post, 
                 :members => :get, 
                 :invite => :get,
                 :invite_them => :post,
                 :photos => :get,
                 :new_photo => :post,
                 :save_photo => :post,
                 :delete_photo => :delete } do |group|
    group.resources :memberships
  end

  map.resources :broadcast_emails

  map.resources :bids

  map.twitter_oauth_client '/reqs/twitter_oauth_client', :controller => "reqs", :action => "twitter_oauth_client"
  map.twitter_oauth_callback '/reqs/twitter_oauth_callback', :controller => "reqs", :action => "twitter_oauth_callback"

  map.resources :reqs do |req|
    req.resources :bids
  end

  map.resources :offers

  map.resources :categories

  map.resources :categories, :has_many => [:reqs, :offers, :people]

  map.resources :neighborhoods, :has_many => [:reqs, :offers, :people]

  map.resources :events, :member => { :attend => :get, 
                                      :unattend => :get } do |event|
    event.resources :comments
  end

  map.resources :preferences
  map.resources :searches
  map.resources :activities
  map.resources :connections

  map.resources :photos
  map.open_id_complete 'session', :controller => "sessions", :action => "create", :requirements => { :method => :get }
  map.resource :session
  map.resources :messages, :collection => { :sent => :get, :trash => :get },
                           :member => { :reply => :get, :undestroy => :put }

  map.resources :people, :member => { :verify_email => :get,
                                      :common_contacts => :get }


  map.connect 'people/verify/:id', :controller => 'people',
                                    :action => 'verify_email'

  # person rather than people is deliberate; avoid conflict with resource mappings
  map.reset_password_form '/person/reset_password_form', :controller => 'people', :action => 'reset_password_form'
  map.reset_password 'person/reset_password/:email', :controller => 'people', :action => 'reset_password'
  map.connect '/do_reset_password', :controller => 'people', :action => 'do_reset_password'

  map.resources :people, :member => {:groups => :get, 
    :admin_groups => :get, :request_memberships => :get, :invitations => :get} do |person|
     person.resources :messages
     person.resources :accounts
     person.resources :exchanges
     person.resources :addresses
     person.resources :photos
     person.resources :connections
     person.resources :comments
  end
  map.namespace :admin do |admin|
    admin.resources :people, :active_scaffold => true
    admin.resources :preferences, :broadcast_emails, :feed_posts
    admin.resources :groups
    admin.resources :forums do |forums|
      forums.resources :topics do |topic|
        topic.resources :posts
      end
    end    
  end
  map.resources :blogs do |blog|
    blog.resources :posts do |post|
        post.resources :comments
    end
  end

  map.resources :forums do |forums|
    forums.resources :topics do |topic|
      topic.resources :posts
    end
  end
  
  map.signup '/signup', :controller => 'people', :action => 'new'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.home '/', :controller => 'home'
  map.refreshblog '/refreshblog', :controller => 'home', :action => 'refreshblog'
  map.about '/about', :controller => 'home', :action => 'about'
  map.practice '/practice', :controller => 'home', :action => 'practice'
  map.steps '/steps', :controller => 'home', :action => 'steps'
  map.questions '/questions', :controller => 'home', :action => 'questions'
  map.memberships '/memberships', :controller => 'home', :action => 'memberships'
  map.contact '/contact', :controller => 'home', :action => 'contact'
  map.agreement '/agreement', :controller => 'home', :action => 'agreement'

  map.admin_home '/admin/home', :controller => 'home'

  map.resources :oauth_clients
  map.authorize '/oauth/authorize', :controller => 'oauth', :action => 'authorize'
  map.request_token '/oauth/request_token', :controller => 'oauth', :action => 'request_token'
  map.access_token '/oauth/access_token', :controller => 'oauth', :action => 'access_token'
  map.test_request '/oauth/test_request', :controller => 'oauth', :action => 'test_request'
  map.oauth '/oauth', :controller => 'oauth', :action => 'index'

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => "home"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
