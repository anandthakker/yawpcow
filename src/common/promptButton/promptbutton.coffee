angular.module("prompt-button", [
]).directive("promptButton", ($log, $timeout) ->
  restrict: 'E'
  template: """
<div class="prompt-button">
  <input ng-model="model"  ng-show="promptOpen" type="text" placeholder="{{placeholder}}">
  <button type="button" ng-click="click()">
    <div ng-transclude></div>
  </button>
</div>
"""
  replace: true
  transclude: true
  scope:
    model: "="
    done: "&"
    placeholder: "@"
    
  link: (scope, element, attr) ->

    start = ()->
      scope.promptOpen = true
      scope.click = finish
      element.find('input').bind 'blur', () -> scope.$apply () ->
        cancel()
      $timeout ()->
        element.find('input')[0].focus()

    cancel = ()->
      scope.promptOpen = false
      scope.click = start

    finish = ()->
      scope.promptOpen = false
      scope.click = start
      scope.done()

    element.bind 'click', () -> scope.$apply () -> if not scope.promptOpen then scope.click()

    element.find('input').bind 'keyup', (e) -> scope.$apply () ->
      if(e.which == 13)
        scope.click()
      else if(e.which == 27)
        cancel()

    scope.click = start
    scope.promptOpen = false
    
    scope.placeholder ?= ""
)
