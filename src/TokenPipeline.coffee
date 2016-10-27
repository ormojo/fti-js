class TokenPipeline
	constructor: ->
		@stages = []

	addStage: (stage) ->
		@stages.push(stage)

	run: (tokenStream) ->
		# Execute each stage...
		for stage in @stages
			stage.willRun(@)
			nextTokenStream = []
			# For each token...
			for token in tokenStream
				# Run the stage on that token...
				result = stage.run(token)
				if result?
					if Array.isArray(result)
						nextTokenStream = nextTokenStream.concat(result)
					else
						nextTokenStream.push(result)
			# Next stage operates on the modified tokens from prior stage.
			tokenStream = nextTokenStream

		tokenStream

module.exports = TokenPipeline
