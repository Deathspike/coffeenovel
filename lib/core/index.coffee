# Import the controller core class.
Controller = require './controller'
# Import the options core class.
Options = require './options'
# Import the resources core class.
Resources = require './resources'
# Import the sound core class.
Sound = require './sound'
# Import the visualizer core class.
Visualizer = require './visualizer'

# ==================================================
# Represents a core.
# --------------------------------------------------
module.exports = class
	# ==============================================
	# Initialize a new class instance.
	# ----------------------------------------------
	constructor: (width = 800, height = 600, element = document.getElementById 'novel') ->
		# Initialize a controller.
		@controller = new Controller @, element
		# Initialize defaults.
		@defaults = defaults()
		# Initialize a collection of options.
		@options = new Options
		# Initialize a collection of resources.
		@resources = new Resources @
		# Initialize a sound engine.
		@sound = new Sound @, element
		# Initialize a visualizer.
		@visualizer = new Visualizer @, width, height, element

# ==================================================
# Initialize defaults.
# --------------------------------------------------
defaults = ->
	# The default extension for a background.
	backgroundExtension: 'jpg'
	# The default repository for a background.
	backgroundRepository: 'backgrounds'
	# The default extension for a character.
	characterExtension: 'png'
	# The default repository for a character.
	characterRepository: 'characters'
