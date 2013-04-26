# Import the alias helper function.
alias = require '../helper/alias'

# ==================================================
# Represents a character interpreter.
# --------------------------------------------------
module.exports = class
	# ==============================================
	# Initialize a new Character class instance.
	# ----------------------------------------------
	constructor: (character, instructions) ->
		# Set the character.
		@_character = character
		# Set the instructions.
		@_instructions = instructions
		# Alias the text function.
		return alias @, => @text.apply @, arguments

	# ==============================================
	# Hide the character.
	# ----------------------------------------------
	hide: (transition = 'normal') =>
		# Push the instruction.
		@_instructions [@_character, 'hide', [transition]]

	# ==============================================
	# Show the character.
	# ----------------------------------------------
	show: (name = 'normal', transition = 'normal') =>
		# Push the instruction.
		@_instructions [@_character, 'show', [name, transition]]

	# ==============================================
	# Show text with the character as sender, and await continuation.
	# ----------------------------------------------
	text: (text = null, sender = null) =>
		# Push the instruction.
		@_instructions [@_character, 'text', [text, sender]]
