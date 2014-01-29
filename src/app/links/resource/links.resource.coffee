angular.module("yawpcow.links.resource", [
  "firebase"
  "firebase.connection"
]).factory('Links', ($log, firebaseRef, $firebase, Slug, $q, $rootScope) ->

  listDeferred = $q.defer()
  listPromise = listDeferred.promise

  # TODO: refactor database so that "v1" is parent, so that modules like this one
  # don't need to be aware of it.
  baseRef = firebaseRef().child("skills").child("v1")
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