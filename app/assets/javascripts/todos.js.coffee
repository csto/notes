app = angular.module "Todos", ["ngSanitize", "ngAnimate", "ngResource", 'ngRoute', "ngTouch", 'Devise', 'ng-rails-csrf', 'ui.bootstrap', 'ui.sortable', 'duScroll', 'angularFileUpload']

app.config ['$routeProvider', ($routeProvider) ->
  $routeProvider.
    when('/notes/',
      templateUrl: 'assets/notes/index.html',
      resolve: 
        auth: mainCtrl.authorize
    ).
    when('/account',
      templateUrl: 'assets/sessions/index.html'
    ).
    when('/', 
      templateUrl: 'assets/pages/landing.html'
    ).
    otherwise(
      redirectTo: '/'
    )
]

mainCtrl = app.controller 'MainCtrl', ['$scope', 'Auth', 'Flash', '$location', ($scope, Auth, Flash, $location) ->
  console.log 'MainCtrl loaded'
  
  $scope.loggedInLayout = ->
    return $location.path() != '/' ? true : false

  $scope.$on 'devise:unauthorized', (event, xhr, deferred) ->
    console.log 'devise thing'
    deferred.resolve(error)

]

mainCtrl.authorize = (Auth, $location, Flash) ->
  Auth.currentUser().then((user) ->
    console.log user
  , (error) ->
    console.log 'unauthenticated'
    if $location.path() != '/'
      Flash.add('Not authorized.')
      $location.url('/')
  )


app.config ['AuthProvider', (AuthProvider) ->
  AuthProvider.ignoreAuth(true)
]