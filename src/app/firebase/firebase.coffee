angular.module("firebase.connection", [
  "firebase.offline"
]).factory("firebaseRef_live", (firebaseUrl)->
  ref = new Firebase(firebaseUrl)
).factory("firebaseInfo", ($rootScope, firebaseRef_live)->

  info =
    connected = false

  firebaseRef_live.child(".info").on "value", (snap)->
    newInfo = snap.val()
    if info.connected isnt newInfo.connected
      info.connected = newInfo.connected
      if info.connected
        $rootScope.$broadcast("firebaseInfo:connected")
      else
        $rootScope.$broadcast("firebaseInfo:disconnected")

  info

).factory("firebaseRef", (firebaseInfo, firebaseRef_live, firebaseOffline)->

  # not sure about this.
  offlineRef = new Firebase("http://dummy.firebaseio.com/")

  offlineRef.set(firebaseOffline)

  ()->
    if firebaseInfo.connected
      firebaseRef_live
    else
      offlineRef
)