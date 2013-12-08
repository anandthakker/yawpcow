
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
    prereqList: prereqs
    tagList: tags

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

    get: (scope, name, skillSlug) ->
      skillPromise = angularFire(baseRef.child(skillSlug), scope, name
      ).then (skill)->
        if not skill.tags? then skill.tags = []
        if not skill.prereqs? then skill.prereqs = []
        $log.debug skill
        skill # return skill to next promise
      , (error) -> error

)