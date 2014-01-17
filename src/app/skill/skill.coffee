###
This is the module that will get pulled in by the yawpcow (main app) module
###
angular.module("yawpcow.skill", [
  "yawpcow.skill.main"
  "yawpcow.skill.list"
  "yawpcow.skill.graph"
  "yawpcow.skill.cards"
])

###
This is separated from yawpcow.skill so that we can have child module .list
depend on .main.  Needed so that $stateProvider can set up skill.list as a child
state from a different module.
###
angular.module("yawpcow.skill.main", [
  "ui.router"
  "slugifier"
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
        templateUrl: "skill/skill.tpl.html"
    data:
      pageTitle: "Skill"

  $stateProvider.state "skill.view",
    url: "/:skillTitle/view"
    controller: "SkillViewEditCtrl"
    templateUrl: "skill/view/view.tpl.html"
    data:
      pageTitle: "Skill"

  $stateProvider.state "skill.edit",
    url: "/:skillTitle/edit"
    controller: "SkillViewEditCtrl"
    templateUrl: "skill/edit/edit.tpl.html"
    data:
      pageTitle: "Edit Skill"

).directive("addSkill", ($log, $timeout, Slug, $state) ->
  restrict: 'E'
  templateUrl: 'skill/addskill.tpl.html'
  replace: true
  transclude: true
  link: (scope, element, attr) ->

    startAdd = ()->
      scope.adding = true
      scope.add = finishAdd
      element.find('input').bind 'blur', () -> scope.$apply () ->
        cancelAdd()
      $timeout ()->
        element.find('input')[0].focus()
    cancelAdd = ()->
      scope.adding = false
      scope.add = startAdd
    finishAdd = ()->
      scope.adding = false
      scope.add = startAdd
      skill =
        title: scope.title
        prereqs: []
        tags: []
        content: ""
      slug = Slug.slugify(scope.title)
      scope.skillList[slug] = skill
      # Minor bug: this will navigate to edit before Firebase
      # has updated, so we briefly get a null pointer when that view loads, until
      # angularFire syncs the new skill.
      # Could short-circuit by reading the skill out of skillList, but then
      # I think there's an issue with the skill syncing on changes... worth investigating,
      # though.
      $state.go('skill.edit', {skillTitle: slug})

    element.bind 'click', () -> scope.$apply () -> if not scope.adding then scope.add()

    element.find('input').bind 'keyup', (e) -> scope.$apply () ->
      if(e.which == 13)
        scope.add()
      else if(e.which == 27)
        cancelAdd()
    scope.add = startAdd
    scope.adding = false

).controller("SkillCtrl",
SkillController = ($log, $scope, $state, $stateParams, skillSet) ->
  $log.debug "SkillController"

  # One of the reasons to have a parent state across the different "skill" states
  # is that this controller bind the skill list once, rather than having each
  # view doing it.
  skillSet.list($scope, 'skillList')

  $scope.prereqList = skillSet.prereqList
  $scope.tagList = skillSet.tagList
).controller("SkillViewEditCtrl",
SkillViewEditController = ($log, $scope, $state, $stateParams, skillSet, $window) ->
  $log.debug "SkillViewEditController"
  $scope.slug = $stateParams.skillTitle
  skillSet.get($scope, 'skill', $scope.slug)

  $scope.rename = () ->
    newTitle = $window.prompt("New title:")
    if not newTitle? then return
    newSlug = skillSet.rename($scope.slug, newTitle)
    $state.go("skill.edit", {skillTitle: newSlug})
)


