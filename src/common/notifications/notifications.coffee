angular.module("notifications", [
]).factory("notificationService", ()->

  q = []

  remove = (obj) ->
    i = q.indexOf(obj)
    if i < 0 then throw new Error("Can't find notification to remove")
    q.splice(i,1)
    obj

  notificationService =
    ###
    Add a notification to the queue.
    @param {Object} notification - should have "message" and "details" properties.
    @param {String} type - tbd
    ###
    add: (notification, type)->
      noteObject =
        message: notification.message ? (""+notification)
        details: notification.details ? (""+notification)
        type: type
        value: notification
        $remove: () -> remove(noteObject)

      q.push(noteObject)

    list: ()->
      q
)