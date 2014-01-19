angular.module("yawpcow.skill.list", [
  "ui.router"
  "slugifier"
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
SkillListController = ($scope, Skills) ->
  $scope.selected = {}
  $scope.delete = (slugOrList) ->
    Skills.delete(slugOrList)
)
