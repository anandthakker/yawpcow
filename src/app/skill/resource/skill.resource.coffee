
angular.module("yawpcow.skill.resource", [
  "slugifier"
  "firebase"
]
).config(config = () ->
).factory('Skills', ($log, skillResourceUrl, $firebase, Slug, $q, $rootScope) ->

  baseRef = new Firebase(skillResourceUrl)

  skillMap = $firebase(baseRef)
  listDeferred = $q.defer()
  listPromise = listDeferred.promise

  prereqs = []
  tags = []
  graph = new dagreD3.Digraph()

  buildGraph = ()->
    console.log dagreD3
    list = skillMap.$getIndex()
    for slug in list
      graph.addNode(slug)

    graph.eachNode (slug)->
      return if not skillMap[slug]?.prereqs?
      for prereq in skillMap[slug].prereqs
        graph.addEdge(null, prereq, slug)


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

  skillMap.$on "loaded", ()->
    $log.debug "Skill list loaded"
    buildGraph()
    updatePrereqs()
    updateTags()
    listDeferred.resolve()

  i = 0
  skillMap.$on "change", () ->
    updatePrereqs()
    updateTags()



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
    @returns {Object} A promise that resolves to an ordered list of skill id's (slugs)
    ###
    list: () ->
      deferred = $q.defer()
      listPromise = listPromise.then ()->
        deferred.resolve(graphlib.alg.topsort(graph))
      deferred.promise

    ###
    @returns {Object} A promise that resolves to an object mapping slug->skill object.
    ###
    map: () ->
      deferred = $q.defer()
      listPromise = listPromise.then ()->
        deferred.resolve(skillMap)
      deferred.promise



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
      skillMap.$save(slug)

      deferred.promise

    ###
    Get a particular skill

    @param {String} slug The slugified name of the skill to fetch

    @returns {Object} a skill object
    ###
    get: (slug) ->
      skillMap[slug]

    ###
    Bind a skill object to the given scope.

    @returns {Object} a promise that will be resolved with the bound skill.
    ###
    bind: (scope, name, slug) ->
      skill = skillMap.$child(slug)
      skill.$bind(scope, name).then (unbind)->
        skill


    ###
    Update reading and practice lists
    ###
    addReading: (skill, linkId)->
      if not skill.reading?
        skill.reading = []
      skill.reading.push(linkId)

    removeReading: (skill, linkId)->
      index = skill.reading.indexOf(linkId)
      if skill.reading? and index >= 0
        skill.reading.splice(index,1)

    addPractice: (skill, linkId)->
      if not skill.practice?
        skill.practice = []
      skill.practice.push(linkId)

    removePractice: (skill, linkId)->
      index = skill.practice.indexOf(linkId)
      if skill.practice? and index >= 0
        skill.practice.splice(index,1)


    ###
    Save a skill remotely.
    @returns {Object} A promise that is resolved once data is saved to server.
    ###
    save: (slug) ->
      skillMap.$save(slug)

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
          skillMap.$save(s)

      for slug in slugs
        skillMap.$remove(slug)

    ###
    Rename the given skill.

    @param {String} slug The (current) slug for the skill we want to rename.
    @param {String} newTitle

    @eturns {Object} A promise that resolves to the new slug.
    ###
    rename: (slug, newTitle) ->
      skill = skillMap[slug]
      if not skill? then throw {message: "Could not find #{slug}.", list: skillMap}

      newSlug = Slug.slugify(newTitle)
      skillMap[newSlug] = skill
      skill.title = newTitle

      deferred = $q.defer()
      baseRef.on "child_added", wait = (snapshot) ->
        if snapshot.name() isnt newSlug then return
        baseRef.off "child_added", wait
        deferred.resolve(newSlug)

      skillMap.$remove(slug)

      # Remap prerequisites to new slug.
      for s, skill of skillMap
        if skill.prereqs?
          i = skill.prereqs.indexOf(slug)
          if i>=0 then skill.prereqs[i] = newSlug
          skillMap.$save(s)


      deferred.promise
)