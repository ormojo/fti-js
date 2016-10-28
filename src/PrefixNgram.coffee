TokenPipelineStage = require './TokenPipelineStage'

module.exports = class PrefixNgram extends TokenPipelineStage
	constructor: (@distance) ->

	run: (token) ->
		if (not token?) or (token is '') then return
		token.slice(0,i) for i in [1..Math.min(token.length, @distance)]
