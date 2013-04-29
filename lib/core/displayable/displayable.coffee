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
		# Set the pending callbacks.
		@_pendingCallbacks = null
		# Set the preloaded array.
		@_preloaded = {}

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
	# Preload the displayable.
	# ----------------------------------------------
	preload: (source, callback = null) =>
		# Preload the displayable.
		preloadFinal.call @

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
		# Preload the displayable.
		preloadFinal.call @, source, (error) =>
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

# ==============================================
# Preload the displayable.
# ----------------------------------------------
preloadFinal = (source, callback = null) ->
	# Check if a callback is pending.
	if @_pendingCallbacks
		# Push the callback to the pending callbacks.
		@_pendingCallbacks.push callback
	# Otherwise check if the source has been loaded.
	else if source of @_preloaded
		# Check if the callback is valid.
		if callback
			# Schedule the callback.
			setTimeout callback
	# Otherwise the source is to be loaded.
	else
		# Set the pending callbacks.
		@_pendingCallbacks = [callback]
		# Set the preloaded source.
		@_preloaded[source] = true
		# Preload the image.
		preload source, (error, source) =>
			# Iterate through each callback.
			for callback in @_pendingCallbacks
				# Check if the callback is valid.
				if callback
					# Invoke the callbakc.
					callback error
			# Clear the pending callbacks.
			@_pendingCallbacks = null
