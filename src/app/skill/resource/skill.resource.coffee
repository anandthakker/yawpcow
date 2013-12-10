
angular.module("yawpcow.skill.resource", [
  "slugifier"
  "firebase"
]
).config(config = () ->
).factory('skillSet', ($log, skillResourceUrl, angularFire, Slug, $q) ->
  # No need to make this a class for now, since we only need a singleton.


  baseRef = new Firebase(skillResourceUrl)
  skillList = {}
  prereqs = []
  tags = []

  skillSet =
    ###
    @property A list of legitimate prerequisites.
    ###
    prereqList: prereqs

    ###
    @property A list of legitimate tags.
    ###
    tagList: tags

    ###
    Get the skill list and bind it to the given property (name) of the given scope.
    (this is an artifact of angularFire's API--not necessarily how i'd have designed it, but
    worth it not to reinvent the wheel)

    @param {Object} scope The scope to which to bind the skill list
    @param {String} name The name to bind the skill list to in the given scope.

    @returns {Object} a promise that yields the skillList (a slug->skill object map)
    ###
    list: (scope, name) ->
      listPromise = angularFire(baseRef, scope, name
      ).then (disassociate)->
        skillList = scope[name]
        $log.debug ["skillList", skillList]

        # TODO: update on changes to skill list
        prereqs.push.apply prereqs, (slug for slug,skill of skillList)

        # TODO: update on changes to a skill
        tags.push.apply tags, _.compose(
          _.uniq,
          _.compact,
          _.flatten,
          ((array)->_.pluck(array,'tags')),
          _.values
        ) skillList

        $log.debug ["prereqs", prereqs]
        $log.debug ["tags", tags]

        skillList

      , (error)->error


    ###
    Get a particular skill and bind it to the given property (name) of the given scope.

    @param {Object} scope The scope to which to bind the skill list
    @param {String} name The name to bind the skill list to in the given scope.
    @param {String} skillSlug The slugified name of the skill to fetch

    @returns {Object} a promise that yields the skill object
    ###
    get: (scope, name, skillSlug) ->
      skillPromise = angularFire(baseRef.child(skillSlug), scope, name
      ).then (disassociate)->
        skill = scope[name]
        if not skill.tags? then skill.tags = []
        if not skill.prereqs? then skill.prereqs = []
        $log.debug skill
        skill # return skill to next promise
      , (error) -> error

)