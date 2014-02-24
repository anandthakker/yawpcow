angular.module("yawpcow.user.profile", [
  "firebase"
  "firebase.connection"
]).filter("firstPartOfEmail", ()->
  ucfirst = (str) ->
    # credits: http://kevin.vanzonneveld.net
    str += ""
    f = str.charAt(0).toUpperCase()
    f + str.substr(1)
  firstPartOfEmail = (email) ->
    if email?.indexOf("@") >= 0
      ucfirst email.substr(0, email.indexOf("@"))
    else
      ""+email

).factory("Profile", ($firebase, firebaseRef, $timeout, $filter, $q)->

  Profile =
    create: (uid, email) ->
      deferred = $q.defer()
      firebaseRef().child("users").child(uid)
        .child("email").set email, (err) ->
          if err
            deferred.reject(err)
          else
            deferred.resolve(Profile.get(uid))

      deferred.promise

    get: (uid)->
      deferred = $q.defer()
      ref = firebaseRef().child("users").child(uid)
      ref.on 'value', wait = (snap)->
        return unless snap.val()?
        ref.off 'value', wait #unlisten now that we've got data.
        profile = $firebase(firebaseRef().child("users").child(uid))
        deferred.resolve(profile)

      deferred.promise
)



