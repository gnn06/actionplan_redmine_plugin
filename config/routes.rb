# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html
get 'plan',                   to: 'plan#index'
get 'plan/:id/new',           to: 'plan#new'
get 'issues/:id/plan',        to: 'plan#show'
get 'issues/:id/plan/new',    to: 'subtask#new', as: :subtask
