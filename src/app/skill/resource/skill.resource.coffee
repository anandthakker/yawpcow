
angular.module("yawpcow.skill.resource", [
  "slugifier"
  "firebase"
]
).config(config = () ->
).factory('Skills', (Slug) ->
  
  skillcache = {
    "what-is-html":
      title: "What is HTML?"
      prereqs: []
      tags: ["HTML", "concepts"]
      content: "<p>Blah blah blah</p>"
  }

  Skills = {}
    # list: () ->
    #   collection

    # get: (slug) -> ref(slug)

    # getByTitle: (title) -> Skills.get(Slug.slugify(title))

    # add: (skill) ->

    # save: (skill, cb) -> collection.update(skill, cb)

    # delete: (skill) ->
    #   delete skillcache[Slug.slugify(skill.title)]


)