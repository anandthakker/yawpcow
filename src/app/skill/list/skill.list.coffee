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

).directive("newSkill", ($log, $timeout, Slug, $state) ->
  restrict: 'E'
  templateUrl: 'skill/list/skill.new.tpl.html'
  replace: true
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
