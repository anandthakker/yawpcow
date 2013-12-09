angular.module("yawpcow", [
  "templates-app"
  "templates-common"
  "yawpcow.home"
  "yawpcow.skill"
  "yawpcow.about"
  "ui.router"
  "ui.route"
  "yawpcow.keyCommands"
]).config(myAppConfig = ($stateProvider, $urlRouterProvider, $logProvider) ->
  $urlRouterProvider.otherwise "/home"
  $logProvider.debugEnabled true
).run(run = ->
).value('skillResourceUrl', 'https://yawpcow.firebaseio.com/skills/v1'
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
    if angular.isDefined(toState.data.pageTitle)
      $scope.pageTitle = toState.data.pageTitle + " | yawpcow"
