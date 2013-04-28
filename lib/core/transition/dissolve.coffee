# Initialize CSS3 animation (non-mobile is assumed to be capable of standard rendering).
css = navigator.userAgent.match(/Android|iPad|iPhone|iPod|IEMobile/i) and jQuery.support.transition
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
	clone = element.parentNode.insertBefore element.cloneNode(), element.nextSibling
	# Initialize the cross-fading status.
	crossFade = source and source isnt 'none'
	# Set the opacity of the clone.
	opacity clone, 1.0
	# Set the opacity of the element.
	opacity element, 0.0
	# Initialize the done handler.
	done = ->
		# Remove the clone.
		clone.parentNode.removeChild clone
		# Check if not cross-fading; to support the odd IE9+.
		if not crossFade
			# Transition with normal transition.
			normal element, source
		# Check if the callback is valid.
		if callback
			# Invoke the callback.
			callback()
	# Check if cross-fading prior to transition; to support the odd IE9+
	if crossFade
		# Transition with normal transition.
		normal element, source
		# Check if the browser supports CSS3 transitions.
		if css
			# Perform CSS3 transition.
			jQuery(element).transition opacity: 1, 500
		else
			# Perform JavaScript transition.
			jQuery(element).fadeTo 500, 1
	# Check if the browser supports CSS3 transitions.
	if css
		# Perform CSS3 transition.
		jQuery(clone).transition opacity: 0, 500, done
	else
		# Perform JavaScript transition.
		jQuery(clone).fadeTo 500, 0, done

# ==================================================
# Change opacity of the element.
# --------------------------------------------------
opacity = (element, opacity) ->
	# Set the element filter property.
	element.style.filter = 'alpha(opacity=' + Math.round(opacity * 100) + ')'
	# Set the element opacity property.
	element.style.opacity = opacity
