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
SkillListController = ($scope) ->
  $scope.selected = {}
  $scope.delete = (slug) ->
    if(slug)
      delete $scope.skillList[slug]
    else
      for slug, selected of $scope.selected
        if selected
          console.log $scope.skillList[slug]
          delete $scope.skillList[slug]
          delete $scope.selected[slug]
)
