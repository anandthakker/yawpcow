angular.module("yawpcow.about", [
  "ui.router"
  "placeholders"
  "ui.bootstrap"
]).config(config = ($stateProvider) ->
  $stateProvider.state "about",
    url: "/about"
    views:
      main:
        controller: "AboutCtrl"
        templateUrl: "about/about.tpl.html"

    data:
      pageTitle: "What is It?"

).controller "AboutCtrl", AboutCtrl = ($scope) ->
  