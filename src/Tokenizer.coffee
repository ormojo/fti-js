module.exports = class Tokenizer
	constructor: ->

	run: (val) ->
		if not val? then return []
		if Array.isArray(val)
			return val.map( (x) -> x.toString().trim().toLowerCase() )

		return val.toString().trim().toLowerCase().split(/[\s\-]+/)
