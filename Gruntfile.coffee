module.exports = (grunt) ->
  
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
  grunt.loadNpmTasks "grunt-express-server"

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
          src: [
            "<%= vendor_files.js %>"
            "<%= vendor_files.map %>"
          ]
          dest: "<%= build_dir %>/"
          cwd: "."
          expand: true
        ]

      build_vendor_css:
        files: [
          src: ['<%= vendor_files.css %>']
          dest: '<%= build_dir %>'
          cwd: '.'
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
      compile_css:
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
          mangle: false

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
        asi: true

      globals: {}

    coffeelint:
      options:
        'max_line_length': 
          value: 120

      src:
        files:
          src: [
            "<%= app_files.coffee %>"
            "!src/app/firebase/offline.coffee" #exclude the big json backup file
          ]

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


    express:
      options:
        cmd: 'coffee'
        port: 8080
        script: 'index.coffee'
      build:
        options:
          args: ["--server", "--root=<%= build_dir %>"]
      compile:
        options:
          args: ["--server"]
          background: false


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
        tasks: ["recess:build"]

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
    "express:build"
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
    "copy:build_app_assets"
    "copy:build_vendor_assets"
    "copy:build_appjs"
    "copy:build_vendorjs"
    "copy:build_vendor_css"
    "index:build"
    "karma:continuous"
  ]
  grunt.registerTask "compile", [
    "concat:compile_css"
    "recess:compile"
    "copy:compile_assets"
    "ngmin"
    "concat:compile_js"
    "uglify"
    "index:compile"
    "express:compile"
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

