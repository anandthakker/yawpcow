angular.module("yawpcow.links", [
  "yawpcow.links.resource"
]).directive("ycLinkInput", (Links)->
  restrict: "E"
  replace: true
  template: """
    <div>
      <input class="col-sm-5" type="text" ng-model="linkObject.description">
      <input class="col-sm-5" type="text" ng-model="linkObject.url">
      <button class="btn btn-link" ng-click="remove()">Remove</button>
    </div>
  """
  scope:
    linkId: "="
    onRemove: "="

  link: (scope, element, attrs) ->
    Links.bind(scope, 'linkObject', scope.linkId)
    scope.remove = ()->
      scope.onRemove(scope.linkId)

).directive("ycAddLinkInput", (Links)->
  restrict: "E"
  replace: true
  template: """
    <div>
      <input class="col-sm-5" type="text" placeholder="Description"
        ng-model="linkObject.description">
      <input class="col-sm-5" type="text" placeholder="URL"
        ng-model="linkObject.url">
      <button class="btn btn-link" ng-click="add()">Add</button>
    </div>
  """
  scope:
    onAdded: "="

  link: (scope, element, attrs) ->
    scope.add = ()->
      Links.add(scope.linkObject).then (id)->
        if(scope.onAdded?)
          scope.onAdded(id, scope.linkObject)

      element.find("input")[0].focus()

    element.find("input").on "keydown", (e) ->
      if e.which == 13
        e.preventDefault()
        e.stopPropagation()
        scope.add()

    scope.linkObject = Links.new()


)