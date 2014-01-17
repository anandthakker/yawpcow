angular.module("yawpcow.keyCommands", []
).config( () ->
  stopCallback = Mousetrap.stopCallback
  Mousetrap.stopCallback = (e, element, combo) ->
    return not combo.match(/ctrl|alt|option|meta|command|esc/i) and stopCallback(e,element,combo)

).factory("keyCommands", ($log) ->
  glossary = {}

  keyCommands =
    ###
    @param {Object} scope The scope associated with this key binding.
    @param {String} key The Mousetrap key combo string (e.g. "k", "shift+s", "command+t")
    @param {function} fn The callback.
    @param {String} description A description for this key command, for use in the glossary.
    
    BUG:
    No history/stack on a given key combo, so if a binding is overwritten,
    then when scope of the latter is destroyed, the former won't be restored.
    ###
    bind: (scope, key, fn, description) ->
      Mousetrap.bind key, fn
      if(description?)
        glossary[key] = description

      scope.$on "$destroy", (event)->
        keyCommands.unbind key

    ###
    @param {String} key The Mousetrap key combo string (e.g. "k", "shift+s", "command+t")
    ###
    unbind: (key) ->
      Mousetrap.unbind(key)
      delete glossary[key]

    ###
    @property An object whose properties are key combo strings and values are descriptions.
    ###
    glossary: glossary

).directive("ycKey", ($log, $parse, $window, $rootScope, $location, keyCommands) ->
  safeApply = (scope, fn) ->
    if(scope.$$phase)
      fn()
    else
      scope.$apply fn

  restrict: "A"
  ###
  Expected attributes:
  yc-key can be in the form "key" or "key:description"
  yc-key-command is an expression to be evaluated when yc-key is pressed.  If it's absent,
  we'll try to either follow the link or else trigger the click event.
  ###
  link: (scope, element, attrs) ->
    ## This is hacky, and prevents ":" from being used as an actual key binding.
    delim = attrs.ycKey.indexOf(":")

    #parse yc-key attribute
    [key, desc] = if delim > 0
      [attrs.ycKey.substring(0,delim), attrs.ycKey.substring(delim+1)]
    else
      [attrs.ycKey, element.text()]

    #parse key as an array if appropriate.
    if key.trim().indexOf("[") is 0
      key = scope.$eval(key)

    preventDefault = true

    if attrs.ycKeyCommand?
      cmd = (e) -> safeApply(scope, () ->
        e.preventDefault() if preventDefault
        scope.$eval(attrs.ycKeyCommand)
      )
    else if (element.prop('tagName')?.match /a/i)
      cmd = (e) ->
        e.preventDefault() if preventDefault
        if(element.prop('href')?.length > 0)
          safeApply scope, () ->
            $window.location.href = element.prop('href')
        else
          #keeping this out of $apply because ng-click calls apply.
          element.triggerHandler 'click'
    else
      #keeping this out of $apply because ng-click calls apply.
      cmd = (e) ->
        e.preventDefault() if preventDefault
        element.triggerHandler 'click'


    keyCommands.bind scope, key, cmd, desc
)

### TBD:
A little directive to insert shortcut key label onto controls.
###
   
### TBD:
A glossary directive?
###