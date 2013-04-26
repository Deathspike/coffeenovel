# Import the displayable core class.
Displayable = require './displayable'

# ==================================================
# Represents a background.
# --------------------------------------------------
module.exports = class extends Displayable
	# ==============================================
	# Initialize a new class Background instance.
	# ----------------------------------------------
	constructor: (core, id, extension = core.defaults.backgroundExtension, repository = core.defaults.backgroundRepository) ->
		# Set the extension.
		@_extension = extension
		# Set the identifier.
		@_id = id
		# Set the repository.
		@_repository = repository
		# Initialize the Displayable class instance.
		super core

	# ==============================================
	# Hide the background.
	# ----------------------------------------------
	hide: (transition = 'normal', callback = null) =>
		# Initialize the element.
		element = @_core.visualizer.findOrCreate('background')
		# Check if the transition is a function.
		if typeof transition is 'function'
			# Set the callback.
			callback = transition
			# Set the transition.
			transition = 'normal'
		# Hide the displayable.
		super element, transition, callback

	# ==============================================
	# Show the background.
	# ----------------------------------------------
	show: (transition = 'normal', callback = null) =>
		# Check if the transition is a function.
		if typeof transition is 'function'
			# Set the callback.
			callback = transition
			# Set the transition.
			transition = 'normal'
		# Initialize the element.
		element = @_core.visualizer.findOrCreate('background')
		# Initialize the path.
		source = if @_id then @_repository + '/' + @_id + '.' + @_extension else null
		# Show the displayable.
		super element, source, transition, callback
