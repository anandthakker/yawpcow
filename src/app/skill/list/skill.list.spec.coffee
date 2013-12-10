describe "skills list", ->
  beforeEach module("yawpcow.skill.list")

  describe "states", ->
    it "should establish parent state 'skill' and
     child states for 'view' and 'edit'", inject( ($state) ->
      expect($state.get "skill").not.toBeNull()
      expect($state.get "skill.view").not.toBeNull()
      expect($state.get "skill.edit").not.toBeNull()
    )