# Import the alias helper function.
alias = require '../helper/alias'

# ==================================================
# Represents an instruction delegate.
# --------------------------------------------------
module.exports = class
	# ==============================================
	# Initialize a new Instructions class instance.
	# ----------------------------------------------
	constructor: (instructions) ->
		# Set the instructions.
		@_instructions = instructions
		# Alias the push function.
		return alias @, => @push.apply @, arguments

	# ==============================================
	# Push the instruction.
	# ----------------------------------------------
	push: (instruction) =>
		# Push the instruction.
		@_instructions.push instruction
