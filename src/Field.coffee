_defaultGetter = (doc) -> doc[@name]

class Field
	constructor: (@index, @spec, @name) ->
		if @spec.name then @name = @spec.name
		@get = @spec.get or _defaultGetter
		@pipeline = @spec.pipeline or @index.pipeline
		@boost = @spec.boost or 1

module.exports = Field
