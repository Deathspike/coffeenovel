# Initialize the duration.
duration = 500
# Import the normal transition function.
normal = require './normal'
# Initialize the step size.
step = 1 / (duration / 33)

# ==================================================
# Export the transition.
# --------------------------------------------------
module.exports = (element, source = null, callback = null) ->
	# Initialize the clone of the element.
	clone = element.parentNode.insertBefore element.cloneNode(true), element.nextSibling
	# Initialize the cross-fading status.
	crossFade = source and source isnt 'none'
	# Set the opacity ot the clone.
	opacity clone, cloneOpacity = 1.0
	# Set the opacity ot the element.
	opacity element, elementOpacity = 0.0
	# Check if cross-fading prior to transition; to support the odd IE9+
	if crossFade
		# Transition with normal transition.
		normal element, source
	# Begin dissolve of the clone.
	(dissolve = ->
		# Check if the target opacity has been reached.
		if cloneOpacity < step
			# Check if not cross-fading; to support the odd IE9+.
			if not crossFade
				# Transition with normal transition.
				normal element, source
			# Change opacity of the element.
			opacity element, 1.0
			# Remove the clone.
			clone.parentNode.removeChild clone
			# Check if the callback is valid.
			if callback
				# Invoke the callback.
				callback()
		# Otherwise
		else
			# Check if the clone does not have an image.
			if not clone.style.backgroundImage or clone.style.backgroundImage is 'none'
				# Change opacity of the element.
				opacity element, elementOpacity += step
			# Change opacity of the clone.
			opacity clone, cloneOpacity -= step
			# Schedule the next dissolve iteration.
			setTimeout dissolve, 33
	)()

# ==================================================
# Change opacity of the element.
# --------------------------------------------------
opacity = (element, opacity) ->
	# Set the element filter property.
	# element.style.filter = 'alpha(opacity=' + Math.round(opacity * 100) + ')'
	# Set the element opacity property.
	element.style.opacity = opacity
