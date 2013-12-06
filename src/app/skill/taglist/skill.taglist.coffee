angular.module("yawpcow.skill.taglist", []
).directive("taglist", ($parse) ->
  restrict: 'E'
  templateUrl: 'skill/taglist/skill.taglist.tpl.html'
  replace: true
  scope:
    tags: "="
    label: "@"
  link: (scope, element, attr) ->
)