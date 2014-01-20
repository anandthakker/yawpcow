xdescribe "AppCtrl", ->
  describe "isCurrentUrl", ->
    AppCtrl = undefined
    $location = undefined
    $scope = undefined
    beforeEach module("yawpcow")
    beforeEach inject(($controller, _$location_, $rootScope) ->
      $location = _$location_
      $scope = $rootScope.$new()
      AppCtrl = $controller("AppCtrl",
        $location: $location
        $scope: $scope
      )
    )
    it "should at least load!", inject(->
      expect(AppCtrl).toBeTruthy()
    )