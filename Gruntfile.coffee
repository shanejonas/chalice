module.exports = (grunt)->

  @initConfig
    coffee:
      compile:
        files:
          'composite.js': 'src/composite.coffee'
          'controller.js': 'src/controller.coffee'
          'router.js': 'src/router.coffee'
          'server.js': 'src/server.coffee'
          'view.js': 'src/view.coffee'
          'viewcontroller.js': 'src/viewcontroller.coffee'
    clean:
      build: ["./*.js"]

  @loadNpmTasks 'grunt-contrib-coffee'
  @loadNpmTasks 'grunt-contrib-clean'

  @registerTask 'default', ['build']
  @registerTask 'build', ['clean', 'coffee']

