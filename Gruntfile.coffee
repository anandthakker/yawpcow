module.exports = (grunt) ->
  
  ###
  Load required Grunt tasks. These are installed based on the versions listed
  in `package.json` when you do `npm install` in this directory.
  ###
  
  ###
  Load in our build configuration file.
  ###
  
  ###
  This is the configuration object Grunt uses to give each plugin its
  instructions.
  ###
  
  ###
  We read in our `package.json` file so we can access the package name and
  version. It's already there, so we don't repeat ourselves here.
  ###
  
  ###
  The banner is the comment that is placed at the top of our compiled
  source files. It is first processed as a Grunt template, where the `<%=`
  pairs are evaluated based on this very configuration object.
  ###
  
  ###
  Creates a changelog on a new version.
  ###
  
  ###
  Increments the version number, etc.
  ###
  
  ###
  The directories to delete when `grunt clean` is executed.
  ###
  
  ###
  The `copy` task just copies files from A to B. We use it here to copy
  our project assets (images, fonts, etc.) and javascripts into
  `build_dir`, and then to copy the assets to `compile_dir`.
  ###
  
  ###
  `grunt concat` concatenates multiple source files into a single file.
  ###
  
  ###
  The `build_css` target concatenates compiled CSS and vendor CSS
  together.
  ###
  
  ###
  The `compile_js` target is the concatenation of our application source
  code and all specified vendor source code into a single file.
  ###
  
  ###
  `grunt coffee` compiles the CoffeeScript sources. To work well with the
  rest of the build, we have a separate compilation task for sources and
  specs so they can go to different places. For example, we need the
  sources to live with the rest of the copied JavaScript so we can include
  it in the final build, but we don't want to include our specs there.
  ###
  
  ###
  `ng-min` annotates the sources before minifying. That is, it allows us
  to code without the array syntax.
  ###
  
  ###
  Minify the sources!
  ###
  
  ###
  `recess` handles our LESS compilation and uglification automatically.
  Only our `main.less` file is included in compilation; all other files
  must be imported from this file.
  ###
  
  ###
  `jshint` defines the rules of our linter as well as which files we
  should check. This file, all javascript sources, and all our unit tests
  are linted based on the policies listed in `options`. But we can also
  specify exclusionary patterns by prefixing them with an exclamation
  point (!); this is useful when code comes from a third party but is
  nonetheless inside `src/`.
  ###
  
  ###
  `coffeelint` does the same as `jshint`, but for CoffeeScript.
  CoffeeScript is not the default in ngBoilerplate, so we're just using
  the defaults here.
  ###
  
  ###
  HTML2JS is a Grunt plugin that takes all of your template files and
  places them into JavaScript files as strings that are added to
  AngularJS's template cache. This means that the templates too become
  part of the initial payload as one JavaScript file. Neat!
  ###
  
  ###
  These are the templates from `src/app`.
  ###
  
  ###
  These are the templates from `src/common`.
  ###
  
  ###
  The Karma configurations.
  ###
  
  ###
  The `index` task compiles the `index.html` file as a Grunt template. CSS
  and JS files co-exist here but they get split apart later.
  ###
  
  ###
  During development, we don't want to have wait for compilation,
  concatenation, minification, etc. So to avoid these steps, we simply
  add all script files directly to the `<head>` of `index.html`. The
  `src` property contains the list of included files.
  ###
  
  ###
  When it is time to have a completely compiled application, we can
  alter the above to include only a single JavaScript and a single CSS
  file. Now we're back!
  ###
  
  ###
  This task compiles the karma template so that changes to its file array
  don't have to be managed manually.
  ###
  
  ###
  And for rapid development, we have a watch set up that checks to see if
  any of the files listed below change, and then to execute the listed
  tasks when they do. This just saves us from having to type "grunt" into
  the command-line every time we want to see what we're working on; we can
  instead just leave "grunt watch" running in a background terminal. Set it
  and forget it, as Ron Popeil used to tell us.
  
  But we don't need the same thing to happen for all the files.
  ###
  
  ###
  By default, we want the Live Reload to work for all tasks; this is
  overridden in some tasks (like this file) where browser resources are
  unaffected. It runs by default on port 35729, which your browser
  plugin should auto-detect.
  ###
  
  ###
  When the Gruntfile changes, we just want to lint it. In fact, when
  your Gruntfile changes, it will automatically be reloaded!
  ###
  
  ###
  When our JavaScript source files change, we want to run lint them and
  run our unit tests.
  ###
  
  ###
  When our CoffeeScript source files change, we want to run lint them and
  run our unit tests.
  ###
  
  ###
  When assets are changed, copy them. Note that this will *not* copy new
  files, so this is probably not very useful.
  ###
  
  ###
  When index.html changes, we need to compile it.
  ###
  
  ###
  When our templates change, we only rewrite the template cache.
  ###
  
  ###
  When the CSS files change, we need to compile and minify them.
  ###
  
  ###
  When a JavaScript unit test file changes, we only want to lint it and
  run the unit tests. We don't want to do any live reloading.
  ###
  
  ###
  When a CoffeeScript unit test file changes, we only want to lint it and
  run the unit tests. We don't want to do any live reloading.
  ###
  
  ###
  In order to make it safe to just compile or copy *only* what was changed,
  we need to ensure we are starting from a clean, fresh build. So we rename
  the `watch` task to `delta` (that's why the configuration var above is
  `delta`) and then add a new task called `watch` that does a clean build
  before watching for changes.
  ###
  
  ###
  The default task is to build and compile.
  ###
  
  ###
  The `build` task gets your app ready to run for development and testing.
  ###
  
  ###
  The `compile` task gets your app ready for deployment by concatenating and
  minifying your code.
  ###
  
  ###
  A utility function to get all app JavaScript sources.
  ###
  filterForJS = (files) ->
    files.filter (file) ->
      file.match /\.js$/

  
  ###
  A utility function to get all app CSS sources.
  ###
  filterForCSS = (files) ->
    files.filter (file) ->
      file.match /\.css$/

  grunt.loadNpmTasks "grunt-contrib-clean"
  grunt.loadNpmTasks "grunt-contrib-copy"
  grunt.loadNpmTasks "grunt-contrib-jshint"
  grunt.loadNpmTasks "grunt-contrib-concat"
  grunt.loadNpmTasks "grunt-contrib-watch"
  grunt.loadNpmTasks "grunt-contrib-uglify"
  grunt.loadNpmTasks "grunt-contrib-coffee"
  grunt.loadNpmTasks "grunt-conventional-changelog"
  grunt.loadNpmTasks "grunt-bump"
  grunt.loadNpmTasks "grunt-coffeelint"
  grunt.loadNpmTasks "grunt-recess"
  grunt.loadNpmTasks "grunt-karma"
  grunt.loadNpmTasks "grunt-ngmin"
  grunt.loadNpmTasks "grunt-html2js"

  require("coffee-script")
  userConfig = require("./build.config.coffee")

  taskConfig =
    pkg: grunt.file.readJSON("package.json")
    meta:
      banner: "/**\n" + " * <%= pkg.name %> - v<%= pkg.version %> - <%= grunt.template.today(\"yyyy-mm-dd\") %>\n" + " * <%= pkg.homepage %>\n" + " *\n" + " * Copyright (c) <%= grunt.template.today(\"yyyy\") %> <%= pkg.author %>\n" + " * Licensed <%= pkg.licenses.type %> <<%= pkg.licenses.url %>>\n" + " */\n"

    changelog:
      options:
        dest: "CHANGELOG.md"
        template: "changelog.tpl"

    bump:
      options:
        files: [
          "package.json"
          "bower.json"
        ]
        commit: false
        commitMessage: "chore(release): v%VERSION%"
        commitFiles: [
          "package.json"
          "client/bower.json"
        ]
        createTag: false
        tagName: "v%VERSION%"
        tagMessage: "Version %VERSION%"
        push: false
        pushTo: "origin"

    clean: [
      "<%= build_dir %>"
      "<%= compile_dir %>"
    ]
    copy:
      build_app_assets:
        files: [
          src: ["**"]
          dest: "<%= build_dir %>/assets/"
          cwd: "src/assets"
          expand: true
        ]

      build_vendor_assets:
        files: [
          src: ["<%= vendor_files.assets %>"]
          dest: "<%= build_dir %>/assets/"
          cwd: "."
          expand: true
          flatten: true
        ]

      build_appjs:
        files: [
          src: ["<%= app_files.js %>"]
          dest: "<%= build_dir %>/"
          cwd: "."
          expand: true
        ]

      build_vendorjs:
        files: [
          src: ["<%= vendor_files.js %>"]
          dest: "<%= build_dir %>/"
          cwd: "."
          expand: true
        ]

      compile_assets:
        files: [
          src: ["**"]
          dest: "<%= compile_dir %>/assets"
          cwd: "<%= build_dir %>/assets"
          expand: true
        ]

    concat:
      build_css:
        src: [
          "<%= vendor_files.css %>"
          "<%= recess.build.dest %>"
        ]
        dest: "<%= recess.build.dest %>"

      compile_js:
        options:
          banner: "<%= meta.banner %>"

        src: [
          "<%= vendor_files.js %>"
          "module.prefix"
          "<%= build_dir %>/src/**/*.js"
          "<%= html2js.app.dest %>"
          "<%= html2js.common.dest %>"
          "module.suffix"
        ]
        dest: "<%= compile_dir %>/assets/<%= pkg.name %>-<%= pkg.version %>.js"

    coffee:
      source:
        options:
          bare: true

        expand: true
        cwd: "."
        src: ["<%= app_files.coffee %>"]
        dest: "<%= build_dir %>"
        ext: ".js"

    ngmin:
      compile:
        files: [
          src: ["<%= app_files.js %>"]
          cwd: "<%= build_dir %>"
          dest: "<%= build_dir %>"
          expand: true
        ]

    uglify:
      compile:
        options:
          banner: "<%= meta.banner %>"

        files:
          "<%= concat.compile_js.dest %>": "<%= concat.compile_js.dest %>"

    recess:
      build:
        src: ["<%= app_files.less %>"]
        dest: "<%= build_dir %>/assets/<%= pkg.name %>-<%= pkg.version %>.css"
        options:
          compile: true
          compress: false
          noUnderscores: false
          noIDs: false
          zeroUnits: false

      compile:
        src: ["<%= recess.build.dest %>"]
        dest: "<%= recess.build.dest %>"
        options:
          compile: true
          compress: true
          noUnderscores: false
          noIDs: false
          zeroUnits: false

    jshint:
      src: ["<%= app_files.js %>"]
      test: ["<%= app_files.jsunit %>"]
      gruntfile: ["Gruntfile.js"]
      options:
        curly: true
        immed: true
        newcap: true
        noarg: true
        sub: true
        boss: true
        eqnull: true

      globals: {}

    coffeelint:
      options:
        'max_line_length': 
          value: 100

      src:
        files:
          src: ["<%= app_files.coffee %>"]

      test:
        files:
          src: ["<%= app_files.coffeeunit %>"]

    html2js:
      app:
        options:
          base: "src/app"

        src: ["<%= app_files.atpl %>"]
        dest: "<%= build_dir %>/templates-app.js"

      common:
        options:
          base: "src/common"

        src: ["<%= app_files.ctpl %>"]
        dest: "<%= build_dir %>/templates-common.js"

    karma:
      options:
        ###
        From where to look for files, starting with the location of this file.
        ###
        basePath: ""
        
        ###
        This is the list of file patterns to load into the browser during testing.
        ###
        files: (userConfig.vendor_files.js
        ).concat [
          "<%= html2js.app.dest %>"
          "<%= html2js.common.dest %>"
        ].concat(
        ).concat(userConfig.test_files.js
        ).concat [
          "src/**/*.js"
          "src/**/*.coffee"
        ]

        exclude: ["src/assets/**/*.js"]

        frameworks: ["jasmine"]

        plugins: [
          "karma-jasmine"
          "karma-firefox-launcher"
          "karma-chrome-launcher"
          "karma-phantomjs-launcher"
          "karma-coffee-preprocessor"
        ]

        preprocessors:
          "**/*.coffee": "coffee"

        ###
        How to report, by default.
        ###
        reporters: "dots"
        
        ###
        On which port should the browser connect, on which port is the test runner
        operating, and what is the URL path for the browser to use.
        ###
        port: 9018
        runnerPort: 9100
        urlRoot: "/"
        
        ###
        Disable file watching by default.
        ###
        autoWatch: false
        
        ###
        The list of browsers to launch to test on. This includes only "Firefox" by
        default, but other browser names include:
        Chrome, ChromeCanary, Firefox, Opera, Safari, PhantomJS
        
        Note that you can also use the executable name of the browser, like "chromium"
        or "firefox", but that these vary based on your operating system.
        
        You may also leave this blank and manually navigate your browser to
        http://localhost:9018/ when you're running tests. The window/tab can be left
        open and the tests will automatically occur there during the build. This has
        the aesthetic advantage of not launching a browser every time you save.
        ###
        browsers: ["PhantomJS"] 

        captureTimeout: 5000       

      unit:
        background: true
        port: 9019
        runnerPort: 9877

      continuous:
        singleRun: true

    index:
      build:
        dir: "<%= build_dir %>"
        src: [
          "<%= vendor_files.js %>"
          "<%= build_dir %>/src/**/*.js"
          "<%= html2js.common.dest %>"
          "<%= html2js.app.dest %>"
          "<%= vendor_files.css %>"
          "<%= recess.build.dest %>"
        ]

      compile:
        dir: "<%= compile_dir %>"
        src: [
          "<%= concat.compile_js.dest %>"
          "<%= vendor_files.css %>"
          "<%= recess.compile.dest %>"
        ]

    delta:
      options:
        livereload: true

      gruntfile:
        files: "Gruntfile.js"
        tasks: ["jshint:gruntfile"]
        options:
          livereload: false

      jssrc:
        files: ["<%= app_files.js %>"]
        tasks: [
          "jshint:src"
          "karma:unit:run"
          "copy:build_appjs"
        ]

      coffeesrc:
        files: ["<%= app_files.coffee %>"]
        tasks: [
          "coffeelint:src"
          "coffee:source"
          "karma:unit:run"
          "copy:build_appjs"
        ]

      assets:
        files: ["src/assets/**/*"]
        tasks: ["copy:build_assets"]

      html:
        files: ["<%= app_files.html %>"]
        tasks: ["index:build"]

      tpls:
        files: [
          "<%= app_files.atpl %>"
          "<%= app_files.ctpl %>"
        ]
        tasks: ["html2js"]

      less:
        files: ["src/**/*.less"]
        tasks: ["recess:build", "concat:build_css"]

      jsunit:
        files: ["<%= app_files.jsunit %>"]
        tasks: [
          "jshint:test"
          "karma:unit:run"
        ]
        options:
          livereload: false

      coffeeunit:
        files: ["<%= app_files.coffeeunit %>"]
        tasks: [
          "coffeelint:test"
          "karma:unit:run"
        ]
        options:
          livereload: false

  grunt.initConfig grunt.util._.extend(taskConfig, userConfig)



  grunt.renameTask "watch", "delta"
  grunt.registerTask "watch", [
    "build"
    "karma:unit"
    "delta"
  ]
  grunt.registerTask "default", [
    "build"
    "compile"
  ]
  grunt.registerTask "build", [
    "clean"
    "html2js"
    "jshint"
    "coffeelint"
    "coffee"
    "recess:build"
    "concat:build_css"
    "copy:build_app_assets"
    "copy:build_vendor_assets"
    "copy:build_appjs"
    "copy:build_vendorjs"
    "index:build"
    "karma:continuous"
  ]
  grunt.registerTask "compile", [
    "recess:compile"
    "copy:compile_assets"
    "ngmin"
    "concat:compile_js"
    "uglify"
    "index:compile"
  ]
  

  ###
  The index.html template includes the stylesheet and javascript sources
  based on dynamic names calculated in this Gruntfile. This task assembles
  the list into variables for the template to use and then runs the
  compilation.
  ###
  grunt.registerMultiTask "index", "Process index.html template", ->
    dirRE = new RegExp("^(" + grunt.config("build_dir") + "|" + grunt.config("compile_dir") + ")/", "g")
    jsFiles = filterForJS(@filesSrc).map((file) ->
      file.replace dirRE, ""
    )
    cssFiles = filterForCSS(@filesSrc).map((file) ->
      file.replace dirRE, ""
    )
    grunt.file.copy "src/index.html", @data.dir + "/index.html",
      process: (contents, path) ->
        grunt.template.process contents,
          data:
            scripts: jsFiles
            styles: cssFiles
            version: grunt.config("pkg.version")

