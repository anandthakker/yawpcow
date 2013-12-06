###
This is the module that will get pulled in by the yawpcow (main app) module
###
angular.module("yawpcow.skill", ["yawpcow.skill.main", "yawpcow.skill.list"])

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
  "decipher.tags"
  "ui.bootstrap.typeahead"
  "firebase"
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
SkillController = ($log, $scope, $state, $stateParams, skillResourceUrl, angularFire) ->
  $log.debug "SkillController"
  $scope.skillList = {}
  ref = new Firebase(skillResourceUrl)
  angularFire(ref, $scope, 'skillList').then ()->
    $log.debug  $scope.skillList

).controller("SkillViewEditCtrl",
SkillViewEditController = ($log, $scope, $state, $stateParams, skillResourceUrl, angularFire) ->
  $log.debug "SkillViewEditController"
  $scope.slug = $stateParams.skillTitle
  ref = new Firebase(skillResourceUrl + "/" + $scope.slug)
  angularFire(ref, $scope, 'skill').then ()->
    $log.debug $scope.skill
    if not $scope.skill.tags?
      $scope.skill.tags = []
    if not $scope.skill.prereqs?
      $scope.skill.prereqs = []

  $scope.edit = () -> $state.go('skill.edit')
  $scope.view = () -> $state.go('skill.view')
  $scope.tagList = ["HTML", "CSS", "concept"]
  $scope.prereqList = Object.keys($scope.skillList)
)