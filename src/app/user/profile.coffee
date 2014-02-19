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

).factory("Profile", ($firebase, firebaseRef, $timeout, $filter)->

  Profile =
    get: (uid)->
      profile = $firebase(firebaseRef().child("users").child(uid))

      profile.completedReadings ?= []
      profile.completedPractice ?= []
      profile.completedSkills ?= []

      profile

    create: (id, email, callback) ->
      firebaseRef().child("users").child(id).set
        email: email
        name: $filter("firstPartOfEmail")(email)
      , (err) ->
        if callback
          $timeout ->
            callback err

)