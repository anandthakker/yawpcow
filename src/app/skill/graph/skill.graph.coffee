angular.module("yawpcow.skill.graph", [
  "ui.router"
  "yawpcow.skill.main"
]).config( ($stateProvider)->
  $stateProvider.state "skill.graph",
  url: "/graph"
  controller: "SkillGraphCtrl"
  templateUrl: "skill/graph/graph.tpl.html"
  data:
    pageTitle: "Skill Tree"

).factory("SkillSetGraph", () ->

  class SkillSetGraph
    constructor: (@skillMap)->
      @sequelMap = {}
      @unknownPrereqs = []
      @leaves = []
      @skills = 0

      # Initialize reverse map, save leaves in an array and count the
      # total number of skills.
      for slug, skill of @skillMap
        @leaves.push(slug) if (not skill.prereqs?) or skill.prereqs.length == 0
        @sequelMap[slug] = []
        @skills++

      # Construct the reverse mapping: i.e., from skills to those that
      # depend on them as prerequisites. (slugified name -> slugified name)
      for slug, skill of @skillMap
        for prereq in (skill.prereqs ? [])
          if not @sequelMap[prereq]?
            @unknownPrereqs.push prereq
            @sequelMap[prereq] = []
          @sequelMap[prereq].push(slug)

      # Stratify skills into levels based on distance from leaves.
      level = @leaves.slice()
      @levels = while(level.length > 0)
        prev = level.slice()
        level = []
        for slug in prev
          level.concat(skillMap[slug].prereqs)
        level = _.uniq level
        prev


    getPrereqs: (skillSlug)->
      @skillMap[skillSlug].prereqs

    getSequels: (skillSlug)->
      @sequelMap[skillSlug]

    getLongestHeight: (skillSlug) =>
      skill = @skillMap[skillSlug]
      if skill.prereqs.length == 0
        0
      else
        1 + _.max(skill.prereqs, @getLongestHeight)
).directive("skillGraph", (SkillSetGraph)->

  restrict: "E"
  replace: true
  template: "<div/>"
  scope:
    skillSet: "="
  link: (scope, element, attr)->
    scope.$watch "skillSet", (value)->
      if not value? then return
      graph = new SkillSetGraph(scope.skillSet)


      nodeMap = {}
      root = {name: "_root"}

      g = d3.select(element[0]).append("svg")
        .attr("width", 400)
        .attr("height", 300)
        .append("g")
        .attr("transform", "translate(40,0)")

      tree = d3.layout.tree()
        .size([300,150])
        .children( (d)->
          _.map(if d is root
            graph.leaves
          else
            graph.getSequels(d.name)
          , (slug)->
            if not nodeMap[slug]? then nodeMap[slug] = {name: slug}
            nodeMap[slug]
          )
        )

      diagonal = d3.svg.diagonal()
        .projection (d)->[d.y, d.x]

      nodes = tree.nodes(root)

      link = g.selectAll("pathlink")
        .data(tree.links(nodes))
        .enter()
        .append("path")
        .attr("class", "link")
        .attr("d", diagonal)

      node = g.selectAll("g.node")
        .data(nodes)
        .enter()
        .append("g")
        .attr("transform", (d) ->
          "translate(" + d.y + "," + d.x + ")"
        )

      node.append("circle").attr "r", 4.5

      node.append("text")
        .attr("dx", (d) ->
          if d.children then -8 else 8
        )
        .attr("dy", 3).attr("text-anchor", (d) ->
          if d.children then "end" else "start"
        )
        .text (d) ->
          d.name
).controller("SkillGraphCtrl", SkillGraphController = ($scope) ->

)