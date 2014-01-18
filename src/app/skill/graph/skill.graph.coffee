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

).directive("skillGraph", ($window)->

  ###
  Directive skillGraph

  Renders a graph (http://cpettitt.github.io/project/graphlib) using
  dagre-d3.

  Attributes:
    graph: the graph object
    redraw: directive (link) will set this to a callback that redraws the graph.
    on-node-select: function to be called (with node-id as parameter) when a node is
      selected.
    on-edge-select: function to be called (with edge id as parameter) when an edge is
      selected.
  ###

  restrict: "E"
  replace: true
  template: """
    <div class="graph">
      <svg width="1600">
        <g class="graph-container" transform="translate(20,20)"/>
      </svg>
    </div>
  """

  scope:
    graph: "="
    redraw: "=" # This directive's link function will set
    onNodeSelect: "="
    onEdgeSelect: "="

  link: (scope, element, attr)->

    renderer = new dagreD3.Renderer()
    # renderer.edgeInterpolate('linear')

    # Override post-render to get rid of markers.
    renderer.postRender (graph, root) ->



    layout = dagreD3.layout()
      .nodeSep(5)
      .rankSep(100)

    styleSelected = (svg) ->
      svg.selectAll(".node").classed("selected", (d)->
        scope.graph.node(d).selected
      )
      svg.selectAll(".edgePath").classed("selected", (d)->
        scope.graph.edge(d).selected
      )

    draw = () ->
      graph = scope.graph

      svg = d3.select(element[0]).select("svg")
      rend = renderer.layout(layout).run(graph, svg.select("g"))
      svg.attr("width", rend.graph().width + 40)
        .attr("height", rend.graph().height + 40)
      # svg.call(d3.behavior.zoom().on "zoom", () ->
      #   ev = d3.event
      #   svg.select("g.graph-container")
      #     .attr("transform", "translate(" + ev.translate + ") scale(" + ev.scale + ")")
      # )

      styleSelected(svg)
      svg.selectAll(".edgePath path").on("click", (d,i)->scope.$apply ()->
        edge = graph.edge(d)
        edge.selected = not edge.selected
        styleSelected(svg)
        if scope.onEdgeSelect? then scope.onEdgeSelect(d)
      )
      svg.selectAll(".node").each () ->
        # the data is on the rect elements
        d = d3.select(this).select("rect").datum()
        # but we want to register click on the div label
        d3.select(this).select("div").on("click", ()->scope.$apply ()->
          node = graph.node(d)
          node.selected = not node.selected
          styleSelected(svg)
          if scope.onNodeSelect? then scope.onNodeSelect(d)
        )


    unregister = scope.$watch "graph", (value)->
      if not value? then return
      angular.element($window).on 'resize', () -> scope.$apply () ->
        draw()
      draw()
      unregister()

    scope.redraw = () ->
      draw()


).controller("SkillGraphCtrl", SkillGraphController = ($scope, $state, skillSet) ->


  createEdge = (prereq, skill) ->
    $scope.graph.addEdge(null, prereq, skill,
          skill: skill
          prereq: prereq
          selected: false
    )

  buildGraph = () ->
    $scope.graph = new dagreD3.Digraph()

    for slug, skill of $scope.skillList
      $scope.graph.addNode(slug,
        label: """
        <div>#{skill.title}</div>
        """
        selected: false
      )

    $scope.graph.eachNode (slug)->
      return if not $scope.skillList[slug]?.prereqs?
      for prereq in $scope.skillList[slug].prereqs
        createEdge(prereq, slug)


  ###
  Set up the graph once skillList is populated.
  ###
  $scope.$watch "skillList", (value)->
    if not value? then return
    buildGraph()

  clearSelection = () ->
    for node in $scope.graph.nodes()
      $scope.graph.node(node).selected = false
    for edge in $scope.graph.edges()
      $scope.graph.edge(edge).selected = false
    $scope.redraw()

  $scope.deleteEdges = () ->
    for edgeId in $scope.graph.edges()
      edge = $scope.graph.edge(edgeId)
      if(edge.selected)
        skill = $scope.skillList[edge.skill]
        i = skill.prereqs.indexOf(edge.prereq)
        skill.prereqs.splice(i,1)
        $scope.graph.delEdge(edgeId)
        $scope.redraw()


  # Very primitive "Add an Edge" logic:
  # addingEdge == null --> not in the process of adding an edge.
  # addingEdge == {} or {prereq:___} --> in the process of adding an edge.
  # addingEdge == {prereq:___, skill: ___} --> ready to create the new edge.
  $scope.addingEdge = null
  $scope.pickNode = (slug) ->
    e = $scope.addingEdge
    if e?.prereq?
      e.skill = slug
      $scope.addEdge()
    else if e?
      e.prereq = slug
    else if $scope.deletingNode
      skillSet.delete(slug)
      buildGraph()
    else
      $state.go("skill.view", {skillTitle: slug})

  $scope.addEdge = () ->
    e = $scope.addingEdge
    if e?.skill? and e?.prereq?

      # Add prerequisite to the skill
      skill = $scope.skillList[e.skill]
      if not skill.prereqs? then skill.prereqs = []
      if skill.prereqs.indexOf(e.prereq) >= 0 then return # Bail if prereq exists.
      skill.prereqs.push(e.prereq)

      # Add the edge to the graph
      createEdge(e.prereq, e.skill)

      # Reset/redraw
      $scope.addingEdge = {}
      clearSelection()
      $scope.redraw()

    else if not e?
      $scope.addingEdge = {}

  $scope.cancelAdd = () ->
    $scope.addingEdge = null
    clearSelection()

  $scope.deletingNode = false
)











