angular.module("yawpcow.tags", []
).directive "ycTagSelect", ($timeout, $log) ->
  restrict: "E"
  replace: true
  template: '<input type="text">'
  scope:
    model: "="
    tags: "="
  link: (scope, element, attrs) ->
    scope.$watch 'model', (value) ->
      if typeof value is 'string' then value = value.split(',')
      element.select2 "val", value  if value isnt undefined
    , true

    element.bind "change", ->
      value = element.select2("val")
      scope.$apply () ->
        scope.model = value

    $timeout ->
      element.select2
        tags: scope.tags
        tokenSeparators: [",", " "]

      element.select2 "val", scope.model  if scope.model isnt undefined
