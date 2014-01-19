
angular.module("yawpcow.skill.resource", [
  "slugifier"
  "firebase"
]
).config(config = () ->
).factory('Skills', ($log, skillResourceUrl, angularFire, Slug, $q, $rootScope) ->

  baseRef = new Firebase(skillResourceUrl)
  skillMap = {}
  prereqs = []
  tags = []

  name = "skillMap"

  update = ()->
    $log.debug "Updating skill list"
    skillMap = $rootScope[name]

    # These are linear in the # of skills, which is fine as long as we
    # don't call them on every edit.
    updatePrereqs = () ->
      prereqs.length = 0
      prereqs.push.apply prereqs, (slug for slug,skill of skillMap)
    updateTags = () ->
      tags.length = 0
      tags.push.apply tags, _.compose(
        _.uniq,
        _.compact,
        _.flatten,
        ((array)->_.pluck(array,'tags')),
        _.values
      ) skillMap

    updatePrereqs()
    updateTags()

    baseRef.on "child_added", ->
      updatePrereqs()
      updateTags()

    baseRef.on "child_removed", ->
      updatePrereqs()
      updateTags()

    skillMap

  angularFire(baseRef, $rootScope, name).then (disassociate)->
    $rootScope.$watch name, (newValue,oldValue) ->
      if newValue?
        update()

  Skills =
    ###
    @property A list of legitimate prerequisites.
    ###
    prereqList: prereqs

    ###
    @property A list of legitimate tags.
    ###
    tagList: tags


    ###
    @property
    ###
    map: skillMap


    ###
    Create a new skill with the given title.

    @param {String} title
    @returns {Object} A promise that yields the slug of the new skill.
    ###
    create: (title) ->
      skill =
        title: title
        prereqs: []
        tags: []
        content: ""
      slug = Slug.slugify(title)

      deferred = $q.defer()
      baseRef.on "child_added", wait = (snapshot) ->
        if snapshot.name() isnt slug then return
        baseRef.off "child_added", wait
        deferred.resolve(slug)

      skillMap[slug] = skill

      deferred.promise


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
    Delete the given skill, and remove any prerequisite dependencies on it.

    TODO: return a promise object that resolves when the delete is over.
    ###

    delete: (slugOrList) ->
      slugs = if slugOrList instanceof Array then slugOrList else [slugOrList]
      for s, skill of skillMap
        #no need to fix prereqs from skills we're deleting.
        continue unless slugs.indexOf(s) < 0

        if skill.prereqs?
          skill.prereqs = _.difference(skill.prereqs, slugs)

      for slug in slugs
        delete skillMap[slug]

    ###
    Rename the given skill.

    @param {String} slug The (current) slug for the skill we want to rename.
    @param {String} newTitle

    @eturns {Object} the new slug.
    ###
    rename: (slug, newTitle) ->
      skill = skillMap[slug]
      if not skill? then throw {message: "Could not find #{slug}.", list: skillMap}

      newSlug = Slug.slugify(newTitle)
      skillMap[newSlug] = skill
      skill.title = newTitle
      delete skillMap[slug]

      for s, skill of skillMap
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