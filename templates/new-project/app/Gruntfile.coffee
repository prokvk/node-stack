module.exports = (grunt) ->
	grunt.initConfig {
		pkg: grunt.file.readJSON 'package.json'
		watch:
			less:
				files: '**/*.less'
				tasks: [ 'less:compile' ]
			coffee:
				files: '**/*.coffee'
				tasks: [ 'coffee' ]
		coffee:
			glob_to_multiple:
				files: [{
					expand: true
					cwd: './'
					src: ['**/*.coffee', '!**/Gruntfile.coffee', '!**/node_modules/**']
					dest: './'
					rename: (dest, src) -> return dest + src.replace('.coffee','.js')
				}]
	}

	grunt.loadNpmTasks 'grunt-contrib-watch'
	grunt.loadNpmTasks 'grunt-contrib-coffee'
	
	grunt.registerTask 'default', [ 'coffee' ]
	grunt.registerTask 'coffee_compile', [ 'coffee' ]
	grunt.registerTask 'watcher', [ 'watch' ]