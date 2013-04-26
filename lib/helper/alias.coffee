# ==============================================
# Alias a class instance.
# ----------------------------------------------
module.exports = (me, callback = null) ->
	# Instantiate the alias function.
	object = ->
		# Check if the callback is valid.
		if callback
			# Directly invoke the callback; no asynchronicity.
			callback.apply me, arguments
	# Iterate through the properties.
	for key of me
		# Add the property to the alias.
		object[key] = me[key]
	# Return the object.
	return object
