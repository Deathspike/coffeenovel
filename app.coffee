# Import the browserify module.
browserify = require 'browserify'
# Import the express module.
express = require 'express'
# Import the fs module.
fs = require 'fs'
# Import the uglify-js module.
uglifyjs = require 'uglify-js'

# ==================================================
# Initialize the application.
# --------------------------------------------------
app = express()
# Use the compiled application.
app.get '/index.js', (req, res, next) ->
	# Initialize the file bundle..
	files = browserify()
	# Initialize the application file.
	files.add __dirname + '/public/index.app.js'
	# Bundle the files
	files.bundle (err, src) ->
		# Check if an error has occurred.
		if err
			# Send the error.
			next err
			# Stop the function.
			return
		# Minify the bundled source code.
		minified = uglifyjs.minify src, fromString: true
		# Write the minified source code to the file system.
		fs.writeFile __dirname + '/public/index.js', minified.code, (err) ->
			# Set the response type.
			res.type 'application/javascript'
			# Set the response.
			res.send src
# Use the public folder with a month of cache.
app.use express.static __dirname + '/public', maxAge: 2628000000

# ==================================================
# Listen for incoming connections.
# --------------------------------------------------
app.listen 80
