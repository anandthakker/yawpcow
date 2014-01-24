
angular.module("yawpcow.home", [
  "ui.router"
  "ui.bootstrap.collapse"

]).config(config = ($stateProvider) ->
  $stateProvider.state "home",
    url: "/home"
    views:
      main:
        controller: "HomeCtrl"
        templateUrl: "home/home.tpl.html"

    data:
      pageTitle: "Home"

).controller "HomeCtrl", HomeController = ($scope, $state) ->
