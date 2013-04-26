# ==============================================
# Attach an event listener.
# ----------------------------------------------
module.exports = (target, event, callback) ->
	# Check if the target, event and callback are valid.
	if target and event and callback
		# Find the index of the question mark seperator.
		index = event.indexOf '?'
		# Check if the target supports an add event listener.
		if target.addEventListener
			# Add an event listener.
			target.addEventListener (if index isnt -1 then event.substr 0, index else event), callback
		# Otherwise check if the target supports an attach event.
		else if target.attachEvent
			# Attach an event listener.
			target.attachEvent 'on' + (if index isnt -1 then event.substr index + 1 else event), callback
