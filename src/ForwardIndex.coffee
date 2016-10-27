#
# Maps document IDs to matching tokens.
#
class ForwardIndex
	constructor: -> @store = {}; @length = 0

	set: (id, tokens) ->
		if not @has(id) then @length++
		@store[id] = tokens

	get: (id) -> @store[id]

	has: (id) -> id of @store

	remove: (id) ->
		if not @has(id) then return
		delete @store[id]
		@length--
		return

module.exports = ForwardIndex
