# Import the background core class.
Background = require './displayable/background'
# Import the character core class.
Character = require './displayable/character'

# ==================================================
# Represents a collection of resources.
# --------------------------------------------------
module.exports = class
	# ==============================================
	# Initialize a new Resources class instance.
	# ----------------------------------------------
	constructor: (core) ->
		# Set all resources for iteration.
		@_all =
			# Define the backgrounds.
			backgrounds: [],
			# Define the characters.
			characters: [],
			# Define the transitions.
			transitions: ['dissolve', 'fade', 'normal']
		# Set each background.
		@_backgrounds = {}
		# Set each character.
		@_characters = {}
		# Set the core.
		@_core = core
		# Set each transition.
		@_transitions =
			# Import the dissolve transition module.
			dissolve: require './transition/dissolve'
			# Import the fade transition module.
			fade: require './transition/fade'
			# Import the normal transition module.
			normal: require './transition/normal'

	# ==============================================
	# Find all loaded resources.
	# ----------------------------------------------
	all: =>
		# Return all resources and include the backgrounds.
		backgrounds: @_all.backgrounds.slice 0
		# Include the characters.
		characters: @_all.characters.slice 0
		# Include the transitions.
		transitions: @_all.transitions.slice 0

	# ==============================================
	# Gets or sets a background.
	# ----------------------------------------------
	background: (id, background = null) =>
		# Check if the background is valid.
		if background
			# Check if the id is undefined.
			if not (id of @_backgrounds)
				# Push the background to all resources.
				@_all.backgrounds.push id
			# Set the background.
			@_backgrounds[id] = background
			# Return the background.
			return background
		# Check if the id is undefined.
		if not (id of @_backgrounds)
			# Initialize a new Background class instance.
			background = new Background @_core, id
			# Push the background to all resources.
			@_all.backgrounds.push id
			# Set the background.
			@_backgrounds[id] = background
			# Return the background.
			return background
		# Return the background.
		return @_backgrounds[id]

	# ==============================================
	# Gets or sets a character.
	# ----------------------------------------------
	character: (id, character = null) =>
		# Check if the character is valid.
		if character
			# Check if the id is undefined.
			if not (id of @_characters)
				# Push the characters to all resources.
				@_all.characters.push id
			# Set the character.
			@_characters[id] = character
			# Return the character.
			return character
		# Check if the id is undefined.
		if not (id of @_characters)
			# Initialize a new Character class instance.
			character = new Character @_core, id
			# Push the character to all resources.
			@_all.characters.push id
			# Set the character.
			@_characters[id] = character
			# Return the character.
			return character
		# Return the character.
		return @_characters[id]

	# ==============================================
	# Gets or sets a transition.
	# ----------------------------------------------
	transition: (id, transition = null) =>
		# Check if the transition is valid.
		if transition
			# Check if the id is undefined.
			if not (id of @_transitions)
				# Push the transition to all resources.
				@_all.transitions.push id
			# Set the transition.
			@_transitions[id] = transition
			# Return the transition.
			return transition
		# Return the transition.
		return @_transitions[id]
