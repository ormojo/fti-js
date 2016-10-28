TokenPipelineStage = require './TokenPipelineStage'

class Trimmer extends TokenPipelineStage
	run: (token) ->
		token.replace(/^\W+/, '').replace(/\W+$/, '')

module.exports = new Trimmer
