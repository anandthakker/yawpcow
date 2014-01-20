angular.module("yawpcow", [
  "templates-app"
  "templates-common"
  "yawpcow.login"
  "yawpcow.home"
  "yawpcow.skill"
  "yawpcow.about"
  "ui.router"
  "ui.route"
  "waitForAuth"
  "ui.bootstrap.collapse"
  "ui.bootstrap.dropdownToggle"
  "yawpcow.keyCommands"
]).config(myAppConfig = ($stateProvider, $urlRouterProvider, $logProvider) ->
  $urlRouterProvider.otherwise "/home"
  $logProvider.debugEnabled true
).run(run = (loginService, $rootScope)->
  loginService.init()
).value('skillResourceUrl', 'https://yawpcow.firebaseio.com/skills/v1'
).value('linksResourceUrl', 'https://yawpcow.firebaseio.com/links/v1'
).value('firebaseUrl', 'https://yawpcow.firebaseio.com'
).controller "AppCtrl", AppCtrl = ($scope, $location, keyCommands, $log) ->
  
  $scope.keyCommandGlossary = keyCommands.glossary

  logEvent = (eventName) ->
    $scope.$on eventName, (event, param)->
      $log.debug eventName
      $log.debug event
      $log.debug param
  _.each [
  ],logEvent

  $scope.$on "$stateChangeSuccess", (event, toState, toParams, fromState, fromParams) ->
    if toState?.data?.pageTitle?
      $scope.pageTitle = toState.data.pageTitle + " | yawpcow"
