# ==================================================
# Export the transition.
# --------------------------------------------------
module.exports = (element, source = null, callback = null) ->
	# Set the background-image property.
	element.style.backgroundImage = if source and source isnt 'none' then 'url(' + source + ')' else 'none'
	# Check if the callback is valid.
	if callback
		# Schedule the callback.
		setTimeout callback, 0
