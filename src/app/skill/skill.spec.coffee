
describe "skills section", ->
  beforeEach module("yawpcow.skill")

  it "should establish three states", inject( ($state) ->
    expect($state.get "skill").not.toBeNull()
    expect($state.get "skill.view").not.toBeNull()
    expect($state.get "skill.edit").not.toBeNull()
  )

