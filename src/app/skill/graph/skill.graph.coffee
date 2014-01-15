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

  restrict: "E"
  replace: true
  template: """
    <div class='skill-graph'>
      <svg width="1600">
        <g class="graph" transform="translate(20,20)"/>
      </svg>
    </div>
  """
  scope:
    skillSet: "="
  link: (scope, element, attr)->

    renderer = new dagreD3.Renderer()
    # renderer.edgeInterpolate('linear')

    layout = dagreD3.layout()
      .nodeSep(5)


    draw = (graph) ->
      svg = d3.select(element[0]).select("svg")
      rend = renderer.layout(layout).run(graph, svg.select("g"))
      svg.attr("width", rend.graph().width + 40)
        .attr("height", rend.graph().height + 40)
      svg.call(d3.behavior.zoom().on "zoom", () ->
        ev = d3.event
        svg.select("g.graph")
          .attr("transform", "translate(" + ev.translate + ") scale(" + ev.scale + ")")
      )

    ###
    Watch for skillSet object to be populated.
    Might actually be better to do this off an event, as I think it would
    be clearer and just a touch tighter memory wise.
    ###
    scope.$watch "skillSet", (value)->
      if not value? then return
      skillMap = value

      graph = new dagreD3.Digraph()

      for slug, skill of skillMap
        graph.addNode(slug,
          label: """
          <div>#{skill.title}</div>
          """)

      graph.eachNode (slug)->
        return if not skillMap[slug]?.prereqs?
        for prereq in skillMap[slug].prereqs
          graph.addEdge(null, prereq, slug)

      angular.element($window).on 'resize', () ->
        draw(graph)
      draw(graph)


).controller("SkillGraphCtrl", SkillGraphController = ($scope) ->

)