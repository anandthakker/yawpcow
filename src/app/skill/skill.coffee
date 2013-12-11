###
This is the module that will get pulled in by the yawpcow (main app) module
###
angular.module("yawpcow.skill", ["yawpcow.skill.main", "yawpcow.skill.list", "yawpcow.skill.graph"])

###
This is separated from yawpcow.skill so that we can have child module .list
depend on .main.  Needed so that $stateProvider can set up skill.list as a child
state from a different module.
###
angular.module("yawpcow.skill.main", [
  "ui.router"
  "yawpcow.skill.resource"
  "yawpcow.skill.taglist"
  "ngSanitize"
  "textAngular"
  "yawpcow.tags"
  "yawpcow.keyCommands"
]
).config(config = ($stateProvider) ->
  $stateProvider.state "skill",
    abstract: true
    url: "/skill"
    views:
      main:
        controller: "SkillCtrl"
        template: "<ui-view/>"
    data:
      pageTitle: "Skill"

  $stateProvider.state "skill.view",
    url: "/:skillTitle/view"
    controller: "SkillViewEditCtrl"
    templateUrl: "skill/view.tpl.html"
    data:
      pageTitle: "Skill"

  $stateProvider.state "skill.edit",
    url: "/:skillTitle/edit"
    controller: "SkillViewEditCtrl"
    templateUrl: "skill/edit.tpl.html"
    data:
      pageTitle: "Edit Skill"

).controller("SkillCtrl",
SkillController = ($log, $scope, $state, $stateParams, skillSet) ->
  $log.debug "SkillController"
  skillSet.list($scope, 'skillList')
  $scope.prereqList = skillSet.prereqList
  $scope.tagList = skillSet.tagList
).controller("SkillViewEditCtrl",
SkillViewEditController = ($log, $scope, $state, $stateParams, skillSet) ->
  $log.debug "SkillViewEditController"
  $scope.slug = $stateParams.skillTitle
  skillSet.get($scope, 'skill', $scope.slug)
)


