module.exports = (grunt) ->

  grunt.initConfig

    pkg: grunt.file.readJSON 'package.json'

    connect:
      uses_defaults: {}
    coffee:
      module:
        files:
          'lib/template.js': 'src/template.coffee'
          'vendor/simple-util/lib/util.js': 'vendor/simple-util/src/util.coffee'
          'spec/template-spec.js': 'spec/template-spec.coffee'
    watch:
      scripts:
        files: ['src/**/*.coffee', 'spec/**/*.coffee', 'vendor/**/*.coffee']
        tasks: ['coffee']
      jasmine : {
        files: ['lib/**/*.js', 'specs/**/*.js'],
        tasks: 'jasmine:pivotal:build'
      }
    jasmine:
      pivotal:
        src: 'lib/**/*.js'
        options:
          outfile: 'spec/index.html'
          specs: 'spec/template-spec.js'
          vendor: [
            'vendor/moment.js',
            'vendor/jquery-2.0.3.js',
            'vendor/simple-util/lib/util.js'
          ]

  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-jasmine'

  grunt.registerTask 'default', ['watch']
