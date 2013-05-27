# Import the Controller interpreter class.
Controller = require './controller'
# Import the instructions interpreter class.
Instructions = require './instructions'

# ==================================================
# Represents an interpreter.
# --------------------------------------------------
module.exports = class Interpreter
	# ==============================================
	# Initialize a new Interpreter class instance.
	# ----------------------------------------------
	constructor: (core, scenario, allowInitialJump = true) ->
		# Set the core.
		@_core = core
		# Set the labels.
		@_labels = []
		# Set the instructions.
		@_instructions = []
		# Set the instruction index.
		@_index = 0
		# Set the scenario.
		@_scenario = scenario
		# Set the controller interpreter and interpret the scenario.
		@_scenario @_controller = new Controller @_core, new Instructions(@_instructions), @
		# Check if the scenario utilizies an initial jump.
		if allowInitialJump and not @_instructions.length and @_labels.length
			# Jump to the first label.
			@_controller.jump @_labels[0].name

	# ==============================================
	# Perform ahead-of-time instruction parsing.
	# ----------------------------------------------
	aheadOfTime: (allowChoicePreload = true) =>
		# Set the count.
		count = 0
		# Set the index.
		index = @_index
		# Iterate through the instructions.
		while index < @_instructions.length and count < @_core.options.preloadMaximum
			# Retrieve the instruction.
			instruction = @_instructions[index]
			# Increment the index.
			index++
			# Check if this is a background instruction.
			if instruction[1] is 'background' and instruction[2][0]
				# Increment the count.
				count++
				# Preload the background.
				@_core.resources.background(instruction[2][0]).preload()
			# Check if this is a choice.
			if instruction[1] is 'choose' and instruction[2][0]
				# Check if preloading a choice is allowed.
				if allowChoicePreload
					# Iterate through each choice.
					for choice of instruction[2][0]
						# Initialize a new Interpreter class instance.
						interpreter = new Interpreter @_core, @_scenario, false
						# Jump to the choice.
						interpreter.jump choice
						# Perform ahead-of-time instruction parsing.
						count += interpreter.aheadOfTime false
				# Break iteration.
				break
			# Check if this is a show instruction and the target has a preload function.
			if instruction[1] is 'show' and typeof instruction[0].preload is 'function'
				# Increment the count.
				count++
				# Preload the displayable.
				instruction[0]['preload'].apply instruction[0], instruction[2]
		# Return the count.
		return count

	# ==============================================
	# Interpret instructions for the jump.
	# ----------------------------------------------
	jump: (name) =>
		# Iterate through each label.
		for label in @_labels
			# Check if this is the desired label.
			if label.name is name
				# Splice the instructions.
				@_instructions.splice @_index
				# Interpret the label.
				label.declaration @_controller
				# Stop the function
				return
		# Throw the error.
		throw 'Invalid jump to "' + name + '"'

	# ==============================================
	# Declare interpretable label the jump operation.
	# ----------------------------------------------
	label: (name, declaration) =>
		# Check if the name or declaration is invalid.
		if not name or not declaration or typeof declaration isnt 'function'
			# Throw the error.
			throw 'Invalid label.'
		# Iterate through each label.
		for label in @_labels
			# Check if this is the desired label.
			if label.name is name
				# Throw the error.
				throw 'Invalid label; multiple declarations for "' + name + '"'
		# Push the label.
		@_labels.push name: name, declaration: declaration

	# ==============================================
	# Invoke and advance the current instruction.
	# ----------------------------------------------
	next: (err = null, jump = null) =>
		# Check if an error has occurred.
		if err
			# TEMPORARY: INTERPRETER ALERTING
			alert err
			# TEMPORARY: INTERPRETER ALERTING
			# Throw the error.
			throw err
		# Otherwise check if a jump is available.
		else if jump
			# Interpret instructions for the jump.
			@jump jump
			# Invoke and advance an instruction.
			@next()
		# Otherwise check if the scenario has ended.
		else if @_index >= @_instructions.length
			# TEMPORARY: INTERPRETER ALERTING
			alert 'Not yet implemented (End of scenario).'
			# TEMPORARY: INTERPRETER ALERTING
			# Throw the error.
			throw 'Not yet implemented (End of scenario).'
		# Otherwise invoke the instruction.
		else
			# Initialize and increment the current instruction.
			instruction = @_instructions[@_index++]
			# Check if the instruction is jump.
			if instruction[1] is 'jump'
				# Interpret instructions for the jump.
				@jump instruction[2][0]
				# Invoke and advance an instruction.
				@next()
			# Otherwise check if the instruction is pause.
			else if instruction[1] is 'pause'
				# Schedule the next instruction.
				setTimeout @next, instruction[2][0]
			# Otherwise the instruction is to be invoked.
			else
				# Initialize the target arguments, using a clone to support rewinding.
				targetArguments = instruction[2].slice 0
				# Push the callback handler to delegate to the next function.
				targetArguments.push @next
				# Invoke the instruction on the target.
				instruction[0][instruction[1]].apply instruction[0], targetArguments
			# Perform ahead-of-time instruction parsing.
			@aheadOfTime()
