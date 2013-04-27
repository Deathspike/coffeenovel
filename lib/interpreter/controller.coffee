# Import the alias helper function.
alias = require '../helper/alias'
# Import the character interpreter class.
Character = require './character'

# ==================================================
# Represents a controller interpreter.
# --------------------------------------------------
module.exports = class
	# ==============================================
	# Initialize a new Controller class instance.
	# ----------------------------------------------
	constructor: (core, instructions, interpreter) ->
		# Set the core.
		@_core = core
		# Set the instructions.
		@_instructions = instructions
		# Set the interpreter.
		@_interpreter = interpreter
		# Alias the text function.
		return alias @, => @text.apply @, arguments

	# ==============================================
	# Clear the scene and transition the background.
	# ----------------------------------------------
	background: (name = null, transition = 'normal', clear = true) =>
		# Push the instruction.
		@_instructions [@_core.controller, 'background', [name, transition, clear]]

	# ==============================================
	# Gets a character.
	# ----------------------------------------------
	character: (name) =>
		# Initialize a new Character class instance.
		return new Character @_core.resources.character(name), @_instructions

	# ==============================================
	# Prompt choices and await user selection.
	# ----------------------------------------------
	choose: (choices) =>
		# Check if the choices are invalid.
		if not choices
			# Throw the error.
			throw 'Invalid choose.'
		# Push the instruction.
		@_instructions [@_core.controller, 'choose', [choices]]

	# ==============================================
	# Jump to the label.
	# ----------------------------------------------
	jump: (name) =>
		# Push the instruction.
		@_instructions [@_core.controller, 'jump', [name]]

	# ==============================================
	# Declare the label for jump operations.
	# ----------------------------------------------
	label: (name, declaration) =>
		# Declare interpretable label the jump operation.
		@_interpreter.label name, declaration

	# ==============================================
	# Pause for the specified time.
	# ----------------------------------------------
	pause: (timeInMilliseconds = 1000) =>
		# Check if the time is invalid.
		if timeInMilliseconds < 0
			# Throw the error.
			throw 'Invalid pause time "' + timeInMilliseconds + '"'
		# Push the instruction.
		@_instructions [@_core.controller, 'pause', [timeInMilliseconds]]

	# ==============================================
	# Show text with an optional sender, and wait for user input.
	# ----------------------------------------------
	text: (text = null, sender = null) =>
		# Push the instruction.
		@_instructions [@_core.controller, 'text', [text, sender]]
