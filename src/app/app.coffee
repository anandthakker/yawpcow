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
  "notifications"
  "ui.bootstrap.alert"
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
).factory('$exceptionHandler', (notificationService, $log)->
  (exception)->
    cause = exception.cause
    notificationService.add
      message: exception.message ? "Error"
      details: exception.cause
      exception: exception
    , "danger"

    $log.error exception

).controller "AppCtrl", AppCtrl = ($scope, $location, keyCommands, notificationService, $log) ->
  
  $scope.keyCommandGlossary = keyCommands.glossary

  $scope.notifications = notificationService.list()

  $scope.$on "$stateChangeSuccess", (event, toState, toParams, fromState, fromParams) ->
    $scope.pageTitle = (toState.data?.pageTitle ? "") + " | yawpcow"