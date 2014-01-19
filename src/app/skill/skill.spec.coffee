describe "skills section", ->

  # Mock the Skills service
  skillList =
    skill1:
      title: "Skill 1"
      content: ""
      prereqs: ["skill2"]
      tags: ["HTML", "CSS"]
    skill2:
      title: "Skill 2"
      content: ""
      prereqs: []
      tags: ["HTML", "CSS"]

  Skills =
    prereqList: ['skill1', 'skill2']
    tagList: ['HTML', 'CSS']
    list: (scope, name) ->
      scope[name] = skillList
      # should return promise
    get: (scope, name, skillSlug) ->
      scope[name] = skillList[skillSlug]
      # should return promise

  beforeEach () ->
    angular.module("yawpcow.skill.resource", []).factory "Skills", () -> Skills

  beforeEach module("yawpcow.skill.resource", "yawpcow.skill")

  describe "states", ->
    it "should establish parent state 'skill' and
     child states for 'view' and 'edit'", inject ($state) ->
      expect($state.get "skill").not.toBeNull()
      expect($state.get "skill.view").not.toBeNull()
      expect($state.get "skill.edit").not.toBeNull()

  describe "SkillCtrl", ->
    it "should bind the tag list, and prereq list to the scope", ->
      scope = {}
      inject ($controller) ->
        $controller "SkillCtrl", {$scope: scope}

      expect(scope.tagList).toEqual(Skills.tagList)
      expect(scope.prereqList).toEqual(Skills.prereqList)

  xdescribe "SkillViewEditCtrl", ->
    it "should bind the skill indicated by state params to the scope", ->
      scope = {}
      title = null
      inject ($controller, $state, $stateParams) ->
        $controller "SkillViewEditCtrl", {$scope: scope, $stateParams: {skillTitle: "skill1"}}

        expect(scope.slug).toBe("skill1")
        expect(scope.skill).toEqual(skillList["skill1"])

