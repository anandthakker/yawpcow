
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

        # These are linear in the # of skills, which is fine as long as we
        # don't call them on every edit.
        updatePrereqs = () ->
          prereqs.length = 0
          prereqs.push.apply prereqs, (slug for slug,skill of skillList)
        updateTags = () ->
          tags.length = 0
          tags.push.apply tags, _.compose(
            _.uniq,
            _.compact,
            _.flatten,
            ((array)->_.pluck(array,'tags')),
            _.values
          ) skillList

        updatePrereqs()
        updateTags()

        baseRef.on "child_added", ->
          updatePrereqs()
          updateTags()

        baseRef.on "child_removed", ->
          updatePrereqs()
          updateTags()

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
      skillPromise = angularFire(skillRef = baseRef.child(skillSlug), scope, name
      ).then (disassociate)->
        console.log skillSlug
        skill = scope[name]
        if not skill.tags? then skill.tags = []
        if not skill.prereqs? then skill.prereqs = []
        $log.debug skill

        skill # return skill to next promise
      , (error) -> error


    ###
    Rename the given skill.

    @param {String} slug The (current) slug for the skill we want to rename.
    @param {String} newTitle

    @eturns {Object} the new slug.
    ###
    rename: (slug, newTitle) ->
      newSlug = Slug.slugify(newTitle)
      skill = skillList[slug]
      skillList[newSlug] = skill
      console.log "Rename"
      console.log slug
      console.log skillList
      skill.title = newTitle
      delete skillList[slug]

      for s, skill of skillList
        if skill.prereqs?
          i = skill.prereqs.indexOf(slug)
          if i>=0 then skill.prereqs[i] = newSlug

      deferred = $q.defer()

      baseRef.on "child_added", wait = (snapshot) ->
        if snapshot.name() isnt newSlug then return
        baseRef.off "child_added", wait
        deferred.resolve(newSlug)

      deferred.promise
)