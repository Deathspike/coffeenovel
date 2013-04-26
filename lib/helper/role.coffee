# ==============================================
# Find elements with the role in the parent.
# ----------------------------------------------
module.exports = (name, parent) ->
	# Check if the parent has the role.
	if parent.attributes and parent.attributes['data-role'] and parent.attributes['data-role'].value is name
		# Return the parent.
		return parent
	# Check if the parent has child nodes.
	if parent.hasChildNodes()
		# Iterate through each child node.
		for element in parent.childNodes
			# Find elements with the role in the parent.
			result = module.exports name, element
			# Check if the match is valid.
			if result
				# Return the match.
				return result
	# Return null.
	return null
