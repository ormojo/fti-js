TokenPipelineStage = require './TokenPipelineStage'

module.exports = class StopWordFilter extends TokenPipelineStage
	constructor: (stopWordsList) ->
		@stopWords = {}
		for word in stopWordsList
			@stopWords[word] = true

	run: (token) ->
		if token and not (token of @stopWords) then return token
