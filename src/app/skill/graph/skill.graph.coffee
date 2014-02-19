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

  Tags:
    If tag-prefix attribute it present, then adds a CSS class for each item
    in a node's `tags` property (expects an array), prefixed by the value
    of tag-prefix, + '-'.  E.G.: tag-prefix="tag" and a node with tag "router"
    would result in CSS class "tag-router" on the rect element for that node.

  Click & Selection:
    Toggles property "selected" on graph and node objects when they're clicked.
    Adds class "selected" to selected edges and nodes.
    Adds class "selected-prerequisite" to the prerequisite nodes (and the
      corresponding edges) of the selected node.
    Adds class "selected-sequel" to the sequel nodes (and the corresponding
      edges) of the selected node.

  Attributes:
    graph: the graph object
    [node-sep: node separation]
    [rank-sep: rank separation]
    redraw: directive (link) will set this to a callback that redraws the graph.
    on-node-click: function to be called (with node-id as parameter) when a node is
      selected or deselected.
    on-edge-click: function to be called (with edge id as parameter) when an edge is
      selected or deselected.
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
    onNodeClick: "="
    onEdgeClick: "="
    tagPrefix: "@"

  link: (scope, element, attr)->

    renderer = new dagreD3.Renderer()
    # renderer.edgeInterpolate('linear')

    # Override post-render to get rid of markers.
    renderer.postRender (graph, root) ->


    nodeSep = 5
    rankSep = 100
    if attr.nodeSep? then nodeSep = parseInt(attr.nodeSep, 10)
    if attr.rankSep? then rankSep = parseInt(attr.rankSep, 10)




    layout = dagreD3.layout()
      .nodeSep(nodeSep)
      .rankSep(rankSep)

    styleSelected = (svg) ->
      gr = scope.graph
      svg.selectAll(".node").classed("selected", (d)->
        gr.node(d).selected
      )
      svg.selectAll(".edgePath").classed("selected", (d)->
        gr.edge(d).selected
      )

      svg.selectAll(".edgePath").classed("selected-prerequisite", (d)->
        return gr.node(gr.target(d)).selected
      )
      svg.selectAll(".node").classed("selected-prerequisite", (d)->
        seqEdges = gr.outEdges(d)
        for e in seqEdges
          if gr.node(gr.target(e)).selected then return true
        false
      )

      svg.selectAll(".edgePath").classed("selected-sequel", (d)->
        return gr.node(gr.source(d)).selected
      )
      svg.selectAll(".node").classed("selected-sequel", (d)->
        preEdges = gr.inEdges(d)
        for e in preEdges
          if gr.node(gr.source(e)).selected then return true
        false
      )


    draw = () ->
      graph = scope.graph

      console.log "draw"
      console.log graph.sources()

      svg = d3.select(element[0]).select("svg")
      rend = renderer.layout(layout).run(graph, svg.select("g"))
      svg.attr("width", rend.graph().width + 40)
        .attr("height", rend.graph().height + 40)

      if scope.tagPrefix?
        svg.selectAll(".node rect").each (d,i)->
          n = graph.node(d)
          return if not n.tags?
          for tag in n.tags
            d3.select(this).classed(scope.tagPrefix + "-" + tag, true)


      styleSelected(svg)
      svg.selectAll(".edgePath path").on("click", (d,i)->scope.$apply ()->
        edge = graph.edge(d)
        edge.selected = not edge.selected
        if scope.onEdgeClick? then scope.onEdgeClick(d)
        styleSelected(svg)
      )
      svg.selectAll(".node").each () ->
        # the data is on the rect elements
        d = d3.select(this).select("rect").datum()
        # but we want to register click on the div label
        d3.select(this).select("div").on("click", ()->scope.$apply ()->
          node = graph.node(d)
          node.selected = not node.selected
          if scope.onNodeClick? then scope.onNodeClick(d)
          styleSelected(svg)
        )

    scope.$watch "graph", (value)->
      if not value? then return
      draw()

    scope.redraw = () ->
      draw()


).controller("SkillGraphCtrl", SkillGraphController = ($scope, $state, Skills, Slug, $rootScope) ->


  completeGraph = null

  $scope.showingCompleted = false
  updateFilteredGraph = ()->
    if ($scope.showingCompleted)
      $scope.graph = completeGraph
    else
      $scope.graph = completeGraph.filterNodes (node)->
        not _.contains($scope.userProfile.completedSkills, node)

  $scope.toggleShowCompleted = ()->
    $scope.showingCompleted = not $scope.showingCompleted
    $scope.showingCompleted ||= not ($scope.userProfile?.completedSkills?.length? > 0)

    updateFilteredGraph()


  createEdge = (prereq, skill) ->
    $scope.graph.addEdge(null, prereq, skill,
          skill: skill
          prereq: prereq
          selected: false
    )

  buildGraph = () ->
    Skills.list().then (list)->
      completeGraph = $scope.graph = new dagreD3.Digraph()
      for slug in list
        tags = Skills.get(slug).tags ? []
        
        unless tags.indexOf("hidden") >= 0
          $scope.graph.addNode(slug,
            label: """
            <div>#{Skills.get(slug).title}</div>
            """
            selected: false
            tags: Skills.get(slug).tags
          )

      $scope.graph.eachNode (slug)->
        return if not Skills.get(slug)?.prereqs?
        for prereq in Skills.get(slug).prereqs
          createEdge(prereq, slug)

      $rootScope.$watch "userProfile.completedSkills", (newval, oldval) ->
        if(newval?)
          updateFilteredGraph()
      , true


  ###
  Set up the graph once skills have loaded
  ###
  buildGraph()

  ###
  Interactions
  ###
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
        skill = Skills.get(edge.skill)
        i = skill.prereqs.indexOf(edge.prereq)
        skill.prereqs.splice(i,1)
        Skills.save(edge.skill)
        $scope.graph.delEdge(edgeId)
        $scope.redraw()

  $scope.nodeClick = (slug) ->
    if $scope.addingEdge?
      addEdgeSelect(slug)
    else if $scope.deletingNode
      Skills.delete(slug)
      buildGraph()
    else if $scope.graph.node(slug).selected
      # we want only one node selected at a time, so if
      # this one was just selected, clear other selections.
      $scope.graph.eachNode (s, value)->
        if value.selected and (s isnt slug) then value.selected = false
    else
      $state.go("skill.view", {skillTitle: slug})


  $scope.deletingNode = false

  # Very primitive "Add an Edge" logic:
  # addingEdge == null --> not in the process of adding an edge.
  # addingEdge == {} or {prereq:___} --> in the process of adding an edge.
  # addingEdge == {prereq:___, skill: ___} --> ready to create the new edge.
  $scope.addingEdge = null
  addEdgeSelect = (slug) ->
    e = $scope.addingEdge
    if e?.prereq?
      e.skill = slug
      $scope.addEdge()
    else if e?
      e.prereq = slug

  $scope.addEdge = () ->
    e = $scope.addingEdge
    if e?.skill? and e?.prereq?

      # Add prerequisite to the skill
      skill = Skills.get(e.skill)
      if not skill.prereqs? then skill.prereqs = []
      if skill.prereqs.indexOf(e.prereq) >= 0 then return # Bail if prereq exists.
      skill.prereqs.push(e.prereq)
      Skills.save(e.skill)

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

)











