# Import the dissolve transition function.
dissolve = require './dissolve'

# ==================================================
# Export the transition.
# --------------------------------------------------
module.exports = (element, source = null, callback = null) ->
	# Check if the image has not been set.
	if not element.style.backgroundImage or element.style.backgroundImage is 'none'
		# Transition with dissolve transition to the source.
		dissolve element, source, callback
		# Stop the function.
		return
	# Transition with dissolve transition to black.
	dissolve element, null, ->
		# Transition with dissolve transition to the source.
		dissolve element, source, callback
