# Import the attach helper function.
attach = require '../helper/attach'
# Import the role helper function.
role = require '../helper/role'

# ==================================================
# Represents a visualizer.
# --------------------------------------------------
module.exports = class
	# ==============================================
	# Initialize a new instance of the class.
	# ----------------------------------------------
	constructor: (core, width = 800, height = 600, element = document.getElementById 'novel') ->
		# Set the container element.
		@_container = container width, height, element
		# Set the core.
		@_core = core
		# Set the pending callback.
		@_pendingCallback = null
		# Set the pending timeout identifier.
		@_pendingTimeout = null
		# Set the element with the sender role.
		@_sender = role 'sender', @_container
		# Set the element with the text role.
		@_text = null
		# Initialize base visualization elements.
		initialize.call @

	# ==============================================
	# Indicates whether a displayable element exists.
	# ----------------------------------------------
	exists: (id) =>
		# Iterate through each child node.
		for element in @_container.childNodes
			# Check for the exhibitable identifier.
			if element._did is id
				# Return true.
				return true
		# Return false.
		return false

	# ==============================================
	# Find or create a displayable element.
	# ----------------------------------------------
	findOrCreate: (id) =>
		# Iterate through each child node.
		for element in @_container.childNodes
			# Check for the exhibitable identifier.
			if element._did is id
				# Return the element.
				return element
		# Initialize an displayable element.
		element = displayable @_container.appendChild document.createElement('div')
		# Set the exhibitable identifier.
		element._did = id
		# Return the element.
		return element

	# ==============================================
	# Remove a displayable element.
	# ----------------------------------------------
	remove: (id) =>
		# Iterate through each child node.
		for element in @_container.childNodes
			# Check for the exhibitable identifier.
			if element._did is id
				# Remove the element.
				element.parentNode.removeChild element
				# Break the iteration
				break;

	# ==============================================
	# Show text with an optional sender.
	# ----------------------------------------------
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
		# Check if the pending timeout is valid.
		if @_pendingTimeout
			# Check if a pending callback is available.
			if @_pendingCallback
				# Schedule the pending callback.
				setTimeout @_pendingCallback, 0
			# Clear the pending timeout.
			clearTimeout @_pendingTimeout
			# Remove the pending callback and timeout.
			@_pendingCallback = @_pendingTimeout = null
		# Check if the sender element is available.
		if @_sender
			# Set the sender in the sender element.
			@_sender.innerText = if sender then sender else ''
		# Check if a text element is available.
		if @_textDirect or @_textHidden or @_textVisible
			# Check if the text is to appear instantly.
			if not text or not @_core.options.lettersPerSecond
				# Set the direct text.
				@_textDirect.innerHTML = if text then (if text.charAt(0) is '!' then text.substr(1) else text) else ''
				# Set the hidden and visible text.
				@_textHidden.nodeValue = @_textVisible.nodeValue = ''
				# Check if the callback is valid.
				if callback
					# Schedule the callback.
					setTimeout callback, 0
			# Otherwise check if the text contains styling; use the low-performance approach.
			else if text.charAt(0) is '!'
				# Set the hidden and visible text.
				@_textHidden.nodeValue = @_textVisible.nodeValue = ''
				# Initialize the index.
				i = 1
				# Initialize and invoke the update function.
				(update = =>
					# Initialize the tag boolean.
					inTag = false
					# Iterate while characters are available.
					while i < text.length
						# Check if the current character is an opening tag.
						if text.charAt(i) is '<'
							# Set the tag boolean.
							inTag = true
						# Increment the index.
						i += 1
						# Check if not in a tag.
						if not inTag
							# Break iteration.
							break
						# check if the current character is a closing tag.
						if text.charAt(i) is '>'
							# Set the tag boolean.
							inTag = false
					# Check if remaining text is available.
					if i < text.length
						# Set the text in the text element.
						@_textDirect.innerHTML = text.substr(1, i) + '<span style="visibility: hidden">' + text.substr(i) + '</span>'
						# Set the pending callback.
						@_pendingCallback = callback
						# Schedule the next update.
						@_pendingTimeout = setTimeout update, 1000 / @_core.options.lettersPerSecond
					# Otherwise the text has been completed.
					else
						# Remove the pending callback and timeout.
						@_pendingCallback = @_pendingTimeout = null
						# Set the text in the text element.
						@_textDirect.innerHTML = text.substr 1
						# Check if the callback is valid.
						if callback
							# Schedule the callback.
							setTimeout callback, 0
				)()
			# Otherwise use the higher-performance approach.
			else
				# Set the direct text.
				@_textDirect.innerHTML = ''
				# Initialize the index.
				i = 0
				# Initialize and invoke the update function.
				(update = =>
					# Increment the index.
					i += 1
					# Check if text is allowed to be partially updated.
					if i < text.length
						# Set the pending callback.
						@_pendingCallback = callback
						# Schedule the next update.
						@_pendingTimeout = setTimeout update, 1000 / @_core.options.lettersPerSecond
						# Set the hidden text in the element.
						@_textHidden.nodeValue = text.substr(i)
						# Set the visible text in the element.
						@_textVisible.nodeValue = text.substr(0, i)
					# Otherwise the end has been reached.
					else
						# Remove the pending callback and timeout.
						@_pendingCallback = @_pendingTimeout = null
						# Set the hidden text in the element.
						@_textHidden.nodeValue = ''
						# Set the visible text in the element.
						@_textVisible.nodeValue = text
						# Check if the callback is valid.
						if callback
							# Schedule the callback.
							setTimeout callback, 0
				)()
		# Otherwise check if the callback is valid.
		else if callback
			# Schedule the callback.
			setTimeout callback, 0

# ==============================================
# Configure a container element.
# ----------------------------------------------
container = (width, height, element) ->
	# Disable selection.
	disable element
	# Set the background-color property.
	element.style.backgroundColor = 'black'
	# Set the display property.
	element.style.display = 'block'
	# Set the height property.
	element.style.height = '100%'
	# Set the max-height property.
	element.style.maxHeight = height + 'px'
	# Set the max-width property.
	element.style.maxWidth = width + 'px'
	# Set the position property.
	element.style.position = 'relative'
	# Set the width property.
	element.style.width = '100%'
	# Return the element
	return element

# ==============================================
# Disable selection.
# ----------------------------------------------
disable = (element) ->
	# Check if the element has children.
	if element.hasChildNodes()
		# Iterate through the children.
		for child in element.childNodes
			# Disable selection.
			disable child
	# Attach an event listener.
	attach element, 'mousedown?selectstart', (e) ->
		# Check if prevent default is available.
		if e and e.preventDefault
			# Invoke the prevent default function.
			e.preventDefault()
		# Return false.
		return false

# ==============================================
# Configure a displayable element.
# ----------------------------------------------
displayable = (element) ->
	# Set the background-position property.
	element.style.backgroundPosition = 'center bottom'
	# Set the background-repeat property.
	element.style.backgroundRepeat = 'no-repeat'
	# Set the background-size property.
	element.style.backgroundSize = 'contain'
	# Set the height property.
	element.style.height = '100%'
	# Set the position property.
	element.style.position = 'absolute'
	# Set the width property.
	element.style.width = '100%'
	# Return the element.
	return element

# ==============================================
# Initialize base visualization elements
# ----------------------------------------------
initialize = ->
	# Set the background element.
	background = @findOrCreate 'background'
	# Set the background-position property.
	background.style.backgroundPosition = 'center center'
	# Set the background-size property.
	background.style.backgroundSize = 'cover'
	# Set the element with the text role.
	textContainer = role 'text', @_container
	# Check if the element with the text role is valid.
	if textContainer
		# Iterate while the element has children.
		while textContainer.hasChildNodes()
			# Remove the child.
			textContainer.removeChild textContainer.firstChild
		# Set the hidden text element.
		textHidden = document.createElement 'span'
		# Set the visibility property of the hidden text element.
		textHidden.style.visibility = 'hidden'
		# Set the direct text.
		@_textDirect = textContainer.appendChild document.createElement 'span'
		# Set the visible text using an appended text node.
		@_textVisible = textContainer.appendChild(document.createElement 'span').appendChild document.createTextNode ''
		# Set the hidden text using an appended text node.
		@_textHidden = textContainer.appendChild(textHidden).appendChild document.createTextNode ''
