# Import the attach helper function.
attach = require './attach'

# ==============================================
# Preload an object.
# ----------------------------------------------
module.exports = (source = null, callback = null) ->
	# Check if the source is valid.
	if source
		# Initialize the image.
		image = new Image
		# Check if the callback is valid.
		if callback
			# Set the error event handler.
			attach image, 'error', -> callback 'Failed to load "' + source + '"'
			# Set the load event handler.
			attach image, 'load', -> callback null, source
		# Set the source.
		image.src = source
	# Otherwise check if the callback is valid.
	else if callback
		# Schedule the callback.
		setTimeout callback, 0
