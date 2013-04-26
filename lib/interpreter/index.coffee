# Import the Controller interpreter class.
Controller = require './controller'
# Import the instructions interpreter class.
Instructions = require './instructions'

# ==================================================
# Represents an interpreter.
# --------------------------------------------------
module.exports = class
	# ==============================================
	# Initialize a new Interpreter class instance.
	# ----------------------------------------------
	constructor: (core, scenario) ->
		# Set the labels.
		@_labels = []
		# Set the instructions.
		@_instructions = []
		# Set the instruction index.
		@_index = 0
		# Set the controller interpreter and interpret the scenario.
		scenario @_controller = new Controller core, new Instructions(@_instructions), @
		# Check if the scenario utilizies an initial jump.
		if not @_instructions.length and @_labels.length
			# Jump to the first label.
			@_controller.jump @_labels[0].name

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
			# Check if the instruction is a jump.
			if instruction[1] is 'jump'
				# Interpret instructions for the jump.
				@jump instruction[2][0]
				# Invoke and advance an instruction.
				@next()
			# Otherwise the instruction is to be invoked.
			else
				# Initialize the target arguments, using a clone to support rewinding.
				targetArguments = instruction[2].slice 0
				# Push the callback handler to delegate to the next function.
				targetArguments.push @next
				# Invoke the instruction on the target.
				instruction[0][instruction[1]].apply instruction[0], targetArguments
