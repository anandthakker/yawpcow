angular.module("yawpcow.assignments", [
  "ui.router"
]).config(config = ($stateProvider) ->
  $stateProvider.state "assignments",
    url: "/assignments"
    views:
      main:
        controller: "AssCtrl"
        templateUrl: "assignments/assignments.tpl.html"

    data:
      pageTitle: "Assignments"

).controller "AssCtrl", AssCtrl = ($scope) ->
  