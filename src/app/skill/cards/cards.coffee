angular.module("yawpcow.skill.cards", [
  "ui.router"
  "yawpcow.skill.main"
]).config( ($stateProvider)->
  $stateProvider.state "skill.cards",
  url: "/cards"
  controller: "SkillCardsCtrl"
  templateUrl: "skill/cards/cards.tpl.html"
  data:
    pageTitle: "Skills"
).directive("skillCard", (Skills)->
  restrict: 'E'
  templateUrl: "skill/view/view.tpl.html"
  replace: true
  link: (scope, element, attrs) ->
    scope.skill = Skills.get(scope.slug)
).controller("SkillCardsCtrl", SkillCardsController = ($scope, Skills) ->
  Skills.list().then (list) ->
    $scope.slugs = list
)