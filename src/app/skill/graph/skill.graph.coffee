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
).directive("skillGraph", ($window, SkillSetGraph)->

  restrict: "E"
  replace: true
  template: "<div class='skill-graph' />"
  scope:
    skillSet: "="
  link: (scope, element, attr)->

    root = {name: "_root"}
    tree = d3.layout.tree()
      .size([100,100])

    nodeWidth = 10

    svg = d3.select(element[0]).append("svg")
    g = svg.append("g")

    xScale = d3.scale.linear().domain([0,100])
    yScale = d3.scale.linear().domain([-nodeWidth,100+nodeWidth])
    diagonal = d3.svg.diagonal()
      .projection (d)->[xScale(d.x), yScale(d.y)]

    draw = (tree)->
      width = parseInt(svg.style('width'), 10)
      height = width
      console.log "Width: #{width}, Height: #{height}"

      xScale.range([0,width])
      yScale.range([0,height])

      nodes = tree.nodes(root)

      link = g.selectAll("path.link")
        .data(tree.links(nodes))
      link.enter()
        .append("path")
        .attr("class", "link")
      link.attr("d", diagonal)

      node = g.selectAll("g.node")
        .data(nodes)
      nodeEnter = node.enter()
        .append("g")
        .attr("class", "node")
      nodeEnter.append("rect")
      nodeEnter.append("text")
      node.attr("transform", (d) ->
        console.log d
        "translate(" + xScale(d.x) + "," + yScale(d.y) + ")"
      )

      w = xScale(nodeWidth)-xScale(0)
      h = yScale(nodeWidth)-yScale(0)
      rect = node.selectAll("rect")
      rect
        .attr("width", w)
        .attr("height", h)
        .attr("x", -w/2)
        .attr("y", -h/2)
        .attr("rx", w/10)
        .attr("ry", h/10)

      node.selectAll("text")
        .attr("dx", 0)
        .attr("dy", 0)
        .attr("text-anchor", "middle")
        .text (d) ->
          d.name

    scope.$watch "skillSet", (value)->
      if not value? then return
      graph = new SkillSetGraph(scope.skillSet)

      nodeMap = {}

      ###
      Define a children accessor function that asks the SkillSetGraph for a given
      skill's sequels.
      Note that we have to wrap the slugs in an object because the tree layout
      expects to get objects.  (Would love to find out I'm wrong about this and just
      use slugs directly)
      ###
      tree.children( (d)->
        _.map(if d is root
          graph.leaves
        else
          graph.getSequels(d.name)
        , (slug)->
          if not nodeMap[slug]? then nodeMap[slug] = {name: slug}
          nodeMap[slug]
        )
      )

      draw(tree)

    angular.element($window).on 'resize', () -> draw(tree)


).controller("SkillGraphCtrl", SkillGraphController = ($scope) ->

)