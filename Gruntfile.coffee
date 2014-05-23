module.exports = (grunt) ->
  grunt.initConfig
    concurrent:
      client:
        tasks: ['newer:coffee:client', 'newer:copy:client', 'newer:less:client']
      dev:
        tasks: ['watch:client', 'nodemon:dev']
        options:
          logConcurrentOutput: true
    # if any of the client files change, should rerun concurrent:client
    watch:
      client:
        files: ['client/**/*']
        tasks: 'concurrent:client'

    coffee:
      client:
        expand: true
        cwd: 'client/coffee'
        src: '**/*.coffee'
        dest: 'dist/scripts'
        ext: '.js'
    copy:
      client:
        expand: true
        cwd: 'client/'
        src: ['templates/**/*', 'assets/**/*']
        dest: 'dist/'

    less:
      client:
        expand: true
        cwd: 'client/stylesheets'
        src: '**/*.less'
        dest: 'dist/stylesheets'
        ext: '.css'
    nodemon:
      dev:
        script: 'server/app.coffee'
        options:
          args: []
          nodeArgs: []
          callback: (nodemon) ->
            nodemon.on 'log', (event) ->
              console.log event.colour
          env:
            PORT: 3000
          cwd: __dirname
          ignore: []
          ext: 'coffee, html'
          # dist is created from watch task
          watch: ['./server', './dist/templates']
          delay: 1000
          legacyWatch: true
    clean: ['dist/']


  grunt.loadNpmTasks 'grunt-concurrent'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-nodemon'
  grunt.loadNpmTasks 'grunt-contrib-less'
  grunt.loadNpmTasks 'grunt-newer'
  grunt.loadNpmTasks 'grunt-contrib-clean'


  grunt.registerTask 'build', ['copy:client', 'coffee:client', 'less:client']
  grunt.registerTask 'dev', 'concurrent:dev'

