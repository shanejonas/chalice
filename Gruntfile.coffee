module.exports = (grunt)->

  @initConfig
    coffee:
      compile:
        files:
          'src/composite.js': 'src/composite.coffee'
          'src/controller.js': 'src/controller.coffee'
          'src/router.js': 'src/router.coffee'
          'src/server.js': 'src/server.coffee'
          'src/view.js': 'src/view.coffee'
          'src/viewcontroller.js': 'src/viewcontroller.coffee'
    clean:
      build: ["src/*.js"]

  @loadNpmTasks 'grunt-contrib-coffee'
  @loadNpmTasks 'grunt-contrib-clean'

  @registerTask 'default', ['build']
  @registerTask 'build', ['clean', 'coffee']

