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
		# Contains the maximum ahead-of-time preloads.
		@preloadMaximum = 2

		@soundChannelEffect = 0.5
		@soundChannelMusic = 0.25
		@soundChannelVoice = 1
