
xdescribe "Skill resource (backend interface)", ->

  blankSkill =
    title: "Skill 1"
    content: ""
    prereqs: []
    tags: ["HTML", "CSS"]

  firebaseUri = ""
  testRef = null

  beforeEach ->
    testDbInit = false
    runs ->
      baseRef = new Firebase("https://yawpcow.firebaseio.com/skills/testDb")
      testRef = baseRef.push {}, ->
        testDbInit = true

    waitsFor (->testDbInit), "a new test database to initialize", 10000

    runs ->
      firebaseUri = testRef.toString()
    runs module("yawpcow.skill.resource", ($provide)->
      $provide.value 'skillResourceUrl', firebaseUri
    )

  afterEach ()->
    testRef.remove()

  it "should fetch the skill list and a specific skill,
      bind them to the scope immediately, and update each when the other changes", ->
    locals =
      listProp: "skillListTest"
      skillProp: "skillTest"
    runs ->
      inject ($rootScope, Skills)->
        skillSet.list($rootScope, locals.listProp)
        expect($rootScope[locals.listProp]).toBeDefined()
        $rootScope[locals.listProp]["skill-1"] = blankSkill

        skillSet.get($rootScope, locals.skillProp, "skill-1")

        expect($rootScope[locals.skillProp]).toBeDefined()

    waits 5000

    runs ->
      inject ($rootScope, Skills)->
        expect($rootScope[locals.skillProp]).toEqual(blankSkill)
        $rootScope[locals.skillProp].content = "updated content"

    waits 5000

    runs ->
      inject ($rootScope, Skills)->
        expect($rootScope[locals.listProp]["skill-1"]).not.toEqual(blankSkill)