# ==================================================
# Represents a collection of options.
# --------------------------------------------------
module.exports = class
	# ==============================================
	# Initialize a new Options class instance.
	# ----------------------------------------------
	constructor: ->
		# Contains whether automatic continuation is enabled.
		@automaticContinuation = false
		# Contains the number of letters per second for text visualization.
		@lettersPerSecond = 100
