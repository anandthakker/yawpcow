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

).directive("skillListEntry", ($parse) ->
  restrict: 'E'
  templateUrl: 'skill/list/skill.listentry.tpl.html'
  replace: true
  scope:
    slug: "="
    skill: "="
    viewUrl: "@"
    editUrl: "@"
  link: (scope, element, attr) ->
    scope.edit = (slug)->
    scope.delete = (slug)->


).directive("newSkill", ($log, $parse, $timeout) ->
  restrict: 'E'
  templateUrl: 'skill/list/skill.new.tpl.html'
  replace: true
  scope:
    create: "="
  link: (scope, element, attr) ->
    cancelAdd = ()->
      scope.adding = false
      scope.add = startAdd
    startAdd = ()->
      scope.adding = true
      element.find('input').bind 'blur', () -> scope.$apply () ->
        cancelAdd()
      scope.add = finishAdd
      $timeout ()->
        element.find('input')[0].focus()
    finishAdd = (title)->
      scope.create(scope.title)

    element.bind 'click', () -> scope.$apply () -> if not scope.adding then scope.add()

    element.find('input').bind 'keyup', (e) -> scope.$apply () ->
      if(e.which == 13)
        scope.add()
      else if(e.which == 27)
        cancelAdd()
    scope.add = startAdd
    scope.adding = false

).controller("SkillListCtrl",
SkillListController = ($scope, $state, $stateParams, skillResourceUrl, Slug) ->

  $scope.add = (title)->
    skill =
      title: title
      prereqs: []
      tags: []
      content: ""
    slug = Slug.slugify(title)
    $scope.skillList[slug] = skill
    $state.go('skill.edit', {skillTitle: slug})

  $scope.rename = ()->
)
