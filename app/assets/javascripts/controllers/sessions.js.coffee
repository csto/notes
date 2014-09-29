app = angular.module('Todos')

app.service 'Flash', ['$timeout', ($timeout) ->
  flash = {}
  flash.messages = []
  
  _.mixin
    capitalize: (string) ->
      string.charAt(0).toUpperCase() + string.substring(1).toLowerCase()
  
  flash.add = (message) ->
    console.log _.indexOf(flash.messages, message) == -1
    if _.indexOf(flash.messages, message) == -1
      flash.messages.push(message)
      flash.remove(message)
      
  flash.add_error = (error) ->
    for key in _.keys(error.errors)
      message = "#{_(key).capitalize()} #{error.errors[key]}" 
      flash.add message
    
  flash.remove = (message) ->
    $timeout ->
      flash.messages = _.without(flash.messages, message)
    , 5000
    
  return flash
]

app.controller 'FlashCtrl', ['$scope', 'Flash', ($scope, Flash) ->
  $scope.flash_messages = Flash.messages
  
  $scope.$watch(
    ->
      Flash.messages
    , ->
      $scope.flash_messages = Flash.messages
  )
]

app.factory "User", ["$resource", ($resource) ->
  $resource("/users/:id", {id: "@id"}, {update: {method: "PUT"}})
]

app.controller 'SessionsCtrl', ['$rootScope', '$scope', '$location', '$http', 'Auth', 'Flash', 'User', ($rootScope, $scope, $location, $http, Auth, Flash, User) ->
  
  console.log 'SessionsCtrl loaded'
  
  $scope.current_action = $location.search().action || 'sign-in'
  
  $scope.update = ->
    User.update({id: 7, user: $scope.user})
  
  $scope.loggedInLayout = ->
    Auth.isAuthenticated()
     
  $scope.register = () ->
    credentials =
      email: $scope.email
      password: $scope.password
      password_confirmation: $scope.password
      token: 'cz96N_8QIJbN06pdq5TSaQ'

    if $scope.email && $scope.password
      Auth.register(credentials).then((user) ->
        Flash.add 'Welcome!'
        $location.url '/notes'
      , (error) ->
        console.log error
        Flash.add 'Invalid email or password.'
      )
    else
      if !$scope.email
        Flash.add 'Please enter your email.'
      if !$scope.password
        Flash.add 'Please enter your password.'
      
  $scope.login = ->
    console.log 'logging in'
    credentials = 
      email: $scope.email
      password: $scope.password
      
    console.log credentials
    
    if $scope.email && $scope.password
      Auth.login(credentials).then((user) ->
        console.log 'okk'
        Flash.add 'Logged in successfully'
        $location.url '/notes'
      , (error) ->
        console.log error
        Flash.add 'Invalid email or password.'
      )
    else
      if !$scope.email
        Flash.add 'Please enter your email.'
      if !$scope.password
        Flash.add 'Please enter your password.'


    # Registration failed...
    $scope.$on "devise:new-registration", (event, user) ->
      console.log event

      
  $scope.logout = ->
    Auth.logout().then((oldUser) ->
      console.log 'logged out'
      Flash.add 'Logged out'
      $location.url '/'
    )
      
  $scope.resetPassword = ->
    $http(
      method: 'POST',
      url: '/users/password',
      data:
        user:
          email: $scope.email
    ).success(
      (data) ->
        console.log data
        $scope.messageSent = true
    ).error(
      (error) ->
        console.log error
        Flash.add_error error
    )
    
  $scope.updatePassword = ->
    console.log $location.search()
    $http(
      method: 'PUT',
      url: '/users/password',
      data:
        user:
          reset_password_token: $location.search().reset_password_token,
          password: $scope.password,
          password_confirmation: $scope.password
    ).success(
      (data) ->
        console.log 'success'
        Flash.add("Password successfully updated.")
        Auth.login(credentials).then((user) ->
          console.log 'okk'
          Flash.add 'Logged in successfully'
          $location.url '/notes'
        , (error) ->
          console.log error
          Flash.add 'Invalid email or password.'
        )
        
    ).error(
      (error) ->
        console.log error
        Flash.add("Password #{error.errors.password}")
    )
]



