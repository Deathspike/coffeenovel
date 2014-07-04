# options
# index => sound

# ==================================================
# Represents a sound engine.
# --------------------------------------------------
module.exports = class
	# ==============================================
	# Initialize a new Sound class instance.
	# ----------------------------------------------
	constructor: (core, element = document.getElementById 'novel') ->
		# Set the core.
		@_core = core
		# Set the element.
		@_element = element



		# Experimental.
		@start 'sounds/illurock'
		# End Experimental.

	#
	# This shit won't work on mobile devices, of course, why would something work directly.
	#

	# ==============================================
	# Start looping sound on the music channel.
	# ----------------------------------------------
	start: (name, fadeTime = 0) =>
		# Initialize an element for the player.
		element = @_element.appendChild document.createElement 'div'

		# Initialize the player.
		$(element).jPlayer loop: true, volume: @_core.options.soundChannelMusic
		# Check if looping can be improved upon for non-IE browsers.
		if not navigator.userAgent.match /IEMobile/i
			# Listen to changes in the playing time.
			$(element).bind $.jPlayer.event.timeupdate, (e) ->
				# Initialize the status.
				status = e.jPlayer.status
				# Check if the duration has been initialized.
				if status.duration isnt 0
					# Initialize the remaining time.
					remainingTime = (status.duration - status.currentTime) * 1000
					# Check if the remaining time is within an event window.
					if remainingTime < 250
						console.log 'Scheduling..'
						# Schedule the loop event ...
						setTimeout ->
							# Stop the sound.
							$(element).jPlayer 'stop'
							# Play the sound.
							$(element).jPlayer 'play'
						# ... using the floored remaining time.
						, Math.floor(remainingTime) - 10

		# Set the media for the player.
		$(element).jPlayer 'setMedia', mp3: name + '.mp3'
		# Play the sound.
		$(element).jPlayer 'play'

		###
		# Significant delay between loops, doens't work on WP8
		# Stop looping sound on the music channel.
		@stop fadeTime, =>
			# Initialize the Howl sound.
			@_loop = new Howl
				# Set the sound to play automatically.
				autoplay: true
				# Set the sound to be continously looped.
				loop: false
				# Set the volume using the music channel.
				volume: @_core.options.soundChannelMusic
				# Set the source addresses in order of preference.
				urls: [name + '.ogg', name + '.mp3']

				onend: =>
					@_loop.stop().play()
					console.log 'test'
			# Check if a fade time has been specified.
			if fadeTime
				# Fade in the sound.
				@_loop.fadeIn @_core.options.soundChannelMusic, fadeTime
		###

	# ==============================================
	# Stop looping sound on the music channel.
	# ----------------------------------------------
	stop: (fadeTime = 0, callback = null) =>
		# Check if the music player is available.
		if @_loop
			# Check if a fade time has been specified.
			if fadeTime
				# Fade out the looping sound.
				@_loop.fadeOut 0, fadeTime, =>
					# Remove the looping sound.
					@_loop = null
					# Check if the callback is valid.
					if callback
						# Invoke the callback.
						callback()
				# Stop the function.
				return
			# Stop the looping sound.
			@_loop.stop()
		# Check if the callback is valid.
		if callback
			# Schedule the callback.
			setTimeout callback, 0

###
	music: (name) =>
		# Initialize an element for the player.
		element = @_element.appendChild document.createElement 'div'
		# Initialize the player.
		jQuery(element).jPlayer volume: @_core.options.soundChannelMusic

		jQuery(element).bind jQuery.jPlayer.event.ended + '.repeat', ->
			jQuery(element).jPlayer 'play'

		# Set the media for the player.
		$(element).jPlayer 'setMedia', mp3: name
		# Play the sound.
		$(element).jPlayer 'play'
###
###
	music: (name) =>
		# Initialize an element for the player.
		element = @_element.appendChild document.createElement 'audio'
		player = element
		player = new MediaElementPlayer element
		player.setSrc name
		player.play()
###
