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
  "checklist-model"
  "prompt-button"
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
    <div class="container">
      <skill slug="slug" completed-readings="userProfile.completedReadings"
      completed-practice="userProfile.completedPractice"
      completed-skills="userProfile.completedSkills"
      show-completion="userProfile">
    </div>
    """
    data:
      pageTitle: "Skill"

  $stateProvider.state "skill.edit",
    url: "/:skillTitle/edit"
    controller: "SkillEditCtrl"
    templateUrl: "skill/edit/edit.tpl.html"
    data:
      pageTitle: "Edit Skill"



).directive("skill", (Skills, Links, $log)->
  restrict: 'E'
  templateUrl: "skill/view/view.tpl.html"
  replace: true
  scope:
    slug: "="
    completedReadings: "="
    completedPractice: "="
    completedSkills: "="
    showCompletion: "="

  link: (scope, element, attr)->

    scope.contains = _.contains

    scope.getTagClasses = (slug)->
      tags = Skills.get(slug)?.tags ? []
      classes = tags.map (tag)->"tag-"+tag
      # YUCK
      if(scope.completedSkills? and _.contains(scope.completedSkills, slug))
        classes.push("tag-complete")
      classes

    # Just using list() to get a promise, so that we know, once it
    # resolves, that we can safely bind a skill object to the scope.
    Skills.list().then ()->
      scope.skill = Skills.get(scope.slug)
      scope.sequels = Skills.getSequels(scope.slug)

    scope.toggleComplete = ()->
      scope.completedSkills ?= []
      if (i = scope.completedSkills.indexOf(scope.slug)) >= 0
        scope.completedSkills.splice(i,1)
      else
        scope.completedSkills.push(scope.slug)

    scope.getLink = (id) ->
      Links.get(id)

    scope.get = (slug) -> Skills.get(slug)

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


