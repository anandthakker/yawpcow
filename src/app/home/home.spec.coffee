describe "home section", ->
  beforeEach module("yawpcow.home")
  it "should set up the 'home' state", inject( ($state)->
    expect($state.get("home")).toBeTruthy()
  )

