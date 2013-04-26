# Import the preload helper function.
preload = require '../../helper/preload'

# ==================================================
# Represents a displayable base.
# --------------------------------------------------
module.exports = class
	# ==============================================
	# Initialize a new class Displayable instance.
	# ----------------------------------------------
	constructor: (core) ->
		# Set the core.
		@_core = core

	# ==============================================
	# Hide the displayable.
	# ----------------------------------------------
	hide: (element, transition = 'normal', callback = null) =>
		# Check if the transition is a function.
		if typeof transition is 'function'
			# Set the callback.
			callback = transition
			# Set the transition.
			transition = 'normal'
		# Get the transition.
		transition = @_core.resources.transition transition
		# Check if the transition is valid.
		if transition
			# Invoke the transition.
			transition element, null, callback
		# Otherwise check if the callback is available.
		else if callback
			# Invoke the callback.
			callback 'Invalid transition "' + transition + '"'

	# ==============================================
	# Show the displayable.
	# ----------------------------------------------
	show: (element, source, transition = 'normal', callback = null) =>
		# Check if the transition is a function.
		if typeof transition is 'function'
			# Set the callback.
			callback = transition
			# Set the transition.
			transition = 'normal'
		# Preload the image.
		preload source, (error, source) =>
			# Check if an error has occurred.
			if error
				# Check if the callback is valid.
				if callback
					# Invoke the callbakc.
					callback error
				# Stop the function.
				return
			# Get the transition.
			transition = @_core.resources.transition transition
			# Check if the transition is valid.
			if transition
				# Invoke the transition.
				transition element, source, callback
			# Otherwise check if the callback is available.
			else if callback
				# Invoke the callback.
				callback 'Invalid transition "' + transition + '"'
