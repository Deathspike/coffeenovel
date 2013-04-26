# Import the core module.
Core = require '../lib/core'
# Import the interpreter module.
Interpreter = require '../lib/interpreter'

# Initialize a new instance of the Core class.
core = new Core 800, 600
# Find the character 'sylvie_marry' and rename to 'Sylvie'.
core.resources.character('sylvie_marry').name 'Sylvie'

# Initialize a new instance of the Interpreter class.
interpreter = new Interpreter core, require './scenarios/everything'
# Invoke and advance the current instruction.
interpreter.next()
