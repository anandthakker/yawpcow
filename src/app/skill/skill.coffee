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
  "yawpcow.links.inputs"
  "yawpcow.links.resource"
  "yawpcow.skill.taglist"
  "ngSanitize"
  "textAngular"
  "taginput"
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
    controller: ($scope, $stateParams)->
      $scope.slug = $stateParams.skillTitle
    template: """
    <a ng-href="#/skill/{{slug}}/edit"
      ng-show-auth="login" role="admin"
      yc-key="e">
      Edit
    </a>
    <skill slug="slug">
    """
    data:
      pageTitle: "Skill"

  $stateProvider.state "skill.edit",
    url: "/:skillTitle/edit"
    controller: "SkillEditCtrl"
    templateUrl: "skill/edit/edit.tpl.html"
    data:
      pageTitle: "Edit Skill"



).directive("skill", (Skills, Links)->
  restrict: 'E'
  templateUrl: "skill/view/view.tpl.html"
  replace: true
  scope:
    slug: "="
  link: (scope, element, attr)->
    scope.getLink = (id) ->
      Links.get(id)

    scope.get = (slug) -> Skills.get(slug)

    scope.getTagClasses = (slug)->
      tags = Skills.get(slug)?.tags ? []
      tags.map (tag)->"tag-"+tag


).directive("addSkill", ($log, $timeout, Skills, $state) ->
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
      Skills.create(scope.title).then (slug) ->
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
SkillController = ($log, $scope, $state, $stateParams, Skills, Links) ->
  $log.debug "SkillController"

  Skills.list().then (list) ->
    $scope.prereqList = Skills.prereqList
    $scope.tagList = Skills.tagList
    $scope.slugs = list.filter (slug)->
      (Skills.get(slug).tags ? []).indexOf("hidden") < 0
    
  $scope.get = Skills.get


).controller("SkillEditCtrl",
SkillEditController = ($log, $scope, $state, $stateParams, Skills, $window) ->
  $log.debug "SkillViewEditController"
  $scope.slug = $stateParams.skillTitle
  Skills.bind($scope, 'skill', $scope.slug)

  $scope.rename = () ->
    newTitle = $window.prompt("New title:")
    if not newTitle? then return
    Skills.rename($scope.slug, newTitle).then (newSlug) ->
      $state.go("skill.edit", {skillTitle: newSlug})
    , (error) -> error

  ###
  TBD: the actual update logic here should go into the Skills API.
  ###
  $scope.moveUp = (list, index) ->
    temp = list[index-1]
    list[index-1] = list[index]
    list[index] = temp

  $scope.addReading = (id) ->
    Skills.addReading($scope.skill, id)

  $scope.removeReading = (id) ->
    Skills.removeReading($scope.skill, id)

  $scope.addPractice = (id) ->
    Skills.addPractice($scope.skill, id)

  $scope.removePractice = (id) ->
    Skills.removePractice($scope.skill, id)
)


