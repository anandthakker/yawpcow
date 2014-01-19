angular.module("yawpcow.links.resource", [
  "firebase"
]).factory('Links', ($log, linksResourceUrl, $firebase, Slug, $q, $rootScope) ->

  listDeferred = $q.defer()
  listPromise = listDeferred.promise

  baseRef = new Firebase(linksResourceUrl)
  links = $firebase(baseRef)

  links.$on "loaded", ()->
    listDeferred.resolve()

  Links =
    list: ()->
      deferred = $q.defer()
      listPromise = listPromise.then ()->
        deferred.resolve(links.$getIndex())
      deferred.promise

    new: ()->
      description: null
      url: null

    add: (link)->
      links.$add(link).then (ref)->
        ref.name()

    get: (id)->
      links[id]

    bind: (scope, name, id) ->
      link = links.$child(id)
      link.$bind(scope, name).then (unbind)->
        link

    save: (id)->
      links.$save(id)

    delete: (id)->
      links.$remove(id)

)