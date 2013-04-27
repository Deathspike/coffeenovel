# Import the attach helper function.
attach = require '../helper/attach'
# Import the role helper function.
role = require '../helper/role'

# ==================================================
# Represents a controller.
# --------------------------------------------------
module.exports = class
	# ==============================================
	# Initialize a new instance of the class.
	# ----------------------------------------------
	constructor: (core, element) ->
		# Set the element with the choice role.
		@_choice = role 'choice', element
		# Set the core.
		@_core = core
		# Set the element.
		@_element = element
		# Set the pending callback.
		@_pendingCallback = null
		# Set the pending timeout identifier.
		@_pendingTimeout = null
		# Attach an event listener.
		attach @_element, 'click', =>
			# Perform continuation.
			continuation.call @

	# ==================================================
	# Clear the scene and transition the background.
	# --------------------------------------------------
	background: (name = null, transition = 'normal', clear = true, callback = null) =>
		# Check if the name is a function.
		if typeof name is 'function'
			# Set the transition.
			transition = name
			# Set the name.
			name = null
		# Check if the transition is a function.
		if typeof transition is 'function'
			# Set the clear boolean.
			clear = transition
			# Set the transition.
			transition = 'normal'
		# Check if the clear boolean is a function.
		if typeof clear is 'function'
			# Set the callback.
			callback = clear
			# Set the clear boolean.
			clear = true
		# Clear the text.
		@_core.visualizer.text =>
			# Check if the scene should be cleared.
			if clear
				# Iterate through all loaded characters.
				for id in @_core.resources.all().characters
					# Hide the character.
					@_core.resources.character(id).hide transition
			# Transition the background.
			@_core.resources.background(name).show transition, callback

	# ==================================================
	# Prompt choices and await for user selection.
	# --------------------------------------------------
	choose: (choices, callback = null) =>
		# Initialize the unordened list.
		ul = document.createElement 'ul'
		# Iterate through each available choice.
		for choice, text of choices when choices.hasOwnProperty choice
			# Scope the choice.
			do (choice) =>
				# Initialize the list item.
				li = document.createElement 'li'
				# Initialize the anchor element.
				a = document.createElement 'a'
				# Set the click handler.
				attach li, 'click', =>
					# Remove the choices.
					@_choice.removeChild ul
					# Check if the callback is valid.
					if callback
						# Invoke the callback.
						callback null, choice
					# Return false.
					return false
				# Append the text in a text element to the anchor.
				a.appendChild document.createTextNode text
				# Append the anchor to the list item.
				li.appendChild a
				# Append the list item to the unordened list.
				ul.appendChild li
		# Append the choices.
		@_choice.appendChild ul

	# ==================================================
	# Show text with an optional sender, and await continuation.
	# --------------------------------------------------
	text: (text = null, sender = null, callback = null) =>
		# Check if the text is a function.
		if typeof text is 'function'
			# Set the sender.
			sender = text
			# Set the text.
			text = null
		# Check if the sender is a function.
		if typeof sender is 'function'
			# Set the callback.
			callback = sender
			# Set the sender.
			sender = null
		# Show text with an optional sender.
		@_core.visualizer.text text, sender, =>
			# Set the pending callback.
			@_pendingCallback = callback
			# Check whether automatic continuation is enabled.
			if @_core.options.automaticContinuation
				# Schedule the continuation.
				@_pendingTimeout = setTimeout (=> continuation.call @), 1000 + text.length * 50

# ==================================================
# Perform continuation (to be called in scope).
# --------------------------------------------------
continuation = ->
	# Check if a pending callback is available.
	if @_pendingCallback
		# Schedule the callback.
		setTimeout @_pendingCallback, 0
		# Remove the callback.
		@_pendingCallback = null
	# Check if a pending timeout is available.
	if @_pendingTimeout
		# Clear the pending timeout.
		clearTimeout @_pendingTimeout
		# Remove the pending callback.
		@_pendingCallback = null
