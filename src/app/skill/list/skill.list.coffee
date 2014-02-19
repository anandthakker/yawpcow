angular.module("yawpcow.skill.list", [
  "ui.router"
  "slugifier"
  "yawpcow.links.resource"
  "yawpcow.skill.main"
  "yawpcow.skill.taglist"
  "yawpcow.keyCommands"
]
).config( ($stateProvider) ->
  $stateProvider.state "skill.list",
    url: "/list"
    controller: "SkillListCtrl"
    templateUrl: "skill/list/list.tpl.html"
    data:
      pageTitle: "Skills"

).controller("SkillListCtrl",
SkillListController = ($scope, Skills, Links) ->
  $scope.selected = {}
  $scope.delete = (slugOrList) ->
    Skills.delete(slugOrList)

  $scope.toggleShowCompleted = ()->
    $scope.showingCompleted = !$scope.showingCompleted

  $scope.contains = _.contains
)
