
###
Borrowed heavily from:
https://github.com/firebase/angularFire-seed/blob/master/app/js/service.login.js
###
angular.module("yawpcow.login", [
  "ui.router"
  "firebase"
  "firebase.connection"
  "yawpcow.user.profile"
]).config( ($stateProvider)->
  $stateProvider.state "login",
    url: "/login"
    views:
      main:
        controller: "LoginCtrl"
        templateUrl: "user/login.tpl.html"
    data:
      pageTitle: "Login"

  $stateProvider.state "logout",
    url: "/logout"
    views:
      main:
        controller: ($scope, $state, loginService) ->
          loginService.logout()
          $state.go("login", {}, {location: "replace"})
        template: ""

).factory("loginService",
  ($rootScope, $firebaseSimpleLogin, $firebase, firebaseRef, $timeout, $q, Profile)->
    $rootScope.$on "$firebaseSimpleLogin:error", (event, error)->
      throw new Error(error)

    $rootScope.$on "$firebaseSimpleLogin:login", (event, user)->
      role = $firebase(firebaseRef().child("roles").child(user.uid))
      role.$on "loaded", ()->
        $rootScope.$broadcast("loginService:role", role.$value)

      Profile.get(user.uid).then (profile) ->
        profile.$bind($rootScope, "userProfile").then (unbind)->
          $rootScope.$on "$firebaseSimpleLogin:logout", ()->
            unbind()
            delete $rootScope.userProfile

    assertAuth = ->
      throw new Error("Must call loginService.init() before using its methods")  if auth is null

    auth = null

    loginService =
      init: ->
        $rootScope.auth = auth = $firebaseSimpleLogin(firebaseRef())

      login: (email, pass) ->
        assertAuth()
        auth.$login("password",
          email: email
          password: pass
          rememberMe: true
        )

      logout: ->
        assertAuth()
        auth.$logout()

      changePassword: (opts) ->
        assertAuth()
        cb = opts.callback ? ->

        if not opts.oldpass or not opts.newpass
          $timeout ->
            cb "Please enter a password"

        else if opts.newpass isnt opts.confirm
          $timeout ->
            cb "Passwords do not match"

        else
          auth.$changePassword(opts.email, opts.oldpass, opts.newpass).then (->
            cb and cb(null)
          ), cb

      createAccount: (email, pass, callback) ->
        assertAuth()
        auth.$createUser(email, pass)


).controller "LoginCtrl", ($scope, loginService, Profile, $state) ->
  
  # must be logged in before I can write to my profile
  assertValidLoginAttempt = (create)->
    $scope.err = null
    unless $scope.email
      $scope.err = "Please enter an email address"
    else unless $scope.pass
      $scope.err = "Please enter a password"
    else $scope.err = "Passwords do not match"  if create and ($scope.pass isnt $scope.confirm)
    not $scope.err

  $scope.email = null
  $scope.pass = null
  $scope.confirm = null
  $scope.createMode = false

  $scope.login = () ->
    return false unless assertValidLoginAttempt(false)
    loginService.login($scope.email, $scope.pass).then ()->
      $state.go 'home'
    , (err)-> throw new Error(err)

  $scope.createAccount = ->
    $scope.err = null
    return false unless assertValidLoginAttempt(true)
    loginService.createAccount($scope.email, $scope.pass
    ).then((user)->
      loginService.login($scope.email, $scope.pass)
    ).then((user)->
      Profile.create user.uid, user.email
    ).then(()->
      $state.go 'home'
    , (err)-> throw new Error(err))



