# Import the displayable core class.
Displayable = require './displayable'

# ==================================================
# Represents a character.
# --------------------------------------------------
module.exports = class extends Displayable
	# ==============================================
	# Initialize a new class Character instance.
	# ----------------------------------------------
	constructor: (core, id, extension = core.defaults.characterExtension, repository = core.defaults.characterRepository) ->
		# Set the extension.
		@_extension = extension
		# Set the identifier.
		@_id = id
		# Set the name with each word in the identifier in uppercase.
		@_name = id.replace(/(_|-)/g, ' ').replace /^([a-z\u00E0-\u00FC])|\s+([a-z\u00E0-\u00FC])/g, (n) -> return n.toUpperCase()
		# Set the repository.
		@_repository = repository
		# Initialize the Displayable class instance.
		super core

	# ==============================================
	# Hide the character.
	# ----------------------------------------------
	hide: (transition = 'normal', callback = null) =>
		# Check if the character exists.
		if @_core.visualizer.exists 'character-' + @_id
			# Initialize the element.
			element = @_core.visualizer.findOrCreate('character-' + @_id)
			# Check if the transition is a function.
			if typeof transition is 'function'
				# Set the callback.
				callback = transition
				# Set the transition.
				transition = 'normal'
			# Hide the displayable.
			super element, transition, =>
				# Remove the element.
				@_core.visualizer.remove 'character-' + @_id
				# Check if the callback is valid.
				if callback
					# Invoke the callback.
					callback.apply @, arguments
		# Otherwise check if the callback is valid.
		else if callback
			# Schedule the callback.
			setTimeout callback, 0

	# ==============================================
	# Gets or sets the character name.
	# ----------------------------------------------
	name: (name = null) =>
		# Check if the name is valid.
		if name
			# Set the name.
			@_name = name
		# Return the name.
		return @_name

	# ==============================================
	# Preload the character (with an unused transition).
	# ----------------------------------------------
	preload: (name = 'normal', transition = 'normal', callback = null) =>
		# Check if the name is a function.
		if typeof name is 'function'
			# Set the transition.
			transition = name
			# Set the name.
			name = 'normal'
		# Check if the transition is a function.
		if typeof transition is 'function'
			# Set the callback.
			callback = transition
		# Initialize the source.
		source = build.call @, name
		# Preload the displayable.
		super source, callback

	# ==============================================
	# Show the character.
	# ----------------------------------------------
	show: (name = 'normal', transition = 'normal', callback = null) =>
		# Check if the name is a function.
		if typeof name is 'function'
			# Set the transition.
			transition = name
			# Set the name.
			name = 'normal'
		# Check if the transition is a function.
		if typeof transition is 'function'
			# Set the callback.
			callback = transition
			# Set the transition.
			transition = 'normal'
		# Initialize the element.
		element = @_core.visualizer.findOrCreate('character-' + @_id)
		# Initialize the source.
		source = build.call @, name
		# Show the displayable.
		super element, source, transition, callback

	# ==============================================
	# Show text with the character as sender, and await continuation.
	# ----------------------------------------------
	text: (text = null, sender = null, callback = null) =>
		# Check if the text is a function.
		if typeof text is 'function'
			# Set the sender.
			sender = text
			# Set the text.
			text = null
		# Check if the transition is a function.
		if typeof sender is 'function'
			# Set the callback.
			callback = sender
			# Set the transition.
			sender = null
		# Check if the sender is invalid.
		if not sender
			# Set the sender.
			sender = @_name
		# Show text with an optional sender, and wait for user input.
		@_core.controller.text text, sender, callback

# ==============================================
# Build the source.
# ----------------------------------------------
build = (name) ->
	# Return the source.
	return @_repository + '/' + @_id + '/' + name + '.' + @_extension
