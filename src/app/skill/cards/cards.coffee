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
).directive("skillCard", ()->
  restrict: 'E'
  templateUrl: "skill/view/view.tpl.html"
  replace: true
).controller("SkillCardsCtrl", SkillCardsController = ($scope) ->

)