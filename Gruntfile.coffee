module.exports = (grunt) ->

  grunt.initConfig

    pkg: grunt.file.readJSON 'package.json'

    coffee:
      options:
        bare: true
      module:
        files:
          'lib/template.js': 'src/template.coffee'
          'spec/template-spec.js': 'spec/template-spec.coffee'

    watch:
      scripts:
        files: ['src/**/*.coffee', 'spec/**/*.coffee', 'vendor/**/*.coffee']
        tasks: ['coffee', 'umd']
      jasmine:
        files: ['lib/**/*.js', 'specs/**/*.js'],
        tasks: 'jasmine:test:build'

    jasmine:
      test:
        src: 'lib/**/*.js'
        options:
          outfile: 'spec/index.html'
          specs: 'spec/template-spec.js'
          vendor: [
            'vendor/bower/moment/moment.js'
            'vendor/bower/moment-timezone/moment-timezone.js'
            'vendor/bower/moment-readable/lib/moment-readable.js'
            'vendor/bower/jquery/dist/jquery.js'
            'vendor/simple-util/lib/util.js'
          ]
    umd:
      all:
        src: 'lib/template.js'
        template: 'umd.hbs'
        amdModuleId: 'simple-template'
        objectToExport: 'tpl'
        globalAlias: 'tpl'
        deps:
          'default': ['$', 'moment']
          amd: ['jquery', 'moment-timezone']
          cjs: ['jquery', 'moment-timezone']
          global:
            items: ['jQuery', 'moment']
            prefix: ''

  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-jasmine'
  grunt.loadNpmTasks 'grunt-umd'

  grunt.registerTask 'default', ['coffee', 'umd', 'jasmine:test:build', 'watch']
