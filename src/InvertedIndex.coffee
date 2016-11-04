#
# Maps tokens to the documents containing them.
#
# Current implementation uses a trie algorithm. Consider switching away from that and using
# n-gramming in the pipeline instead.
#
class InvertedIndex
	constructor: ->
		@root = @createNode()
		@length = 0

	createNode: -> { ids: {} }

	add: (token, id, data, node = @root) ->
		if not token then return
		key = token.charAt(0)
		rest = token.slice(1)
		if not (key of node) then node[key] = @createNode()

		if rest.length is 0
			node[key].ids[id] = data
			@length++
			undefined
		else
			@add(rest, id, data, node[key])

	_getNode: (token, node = @root) ->
		if not token then return null
		for i in [0...token.length]
			if not (token.charAt(i) of node) then return null
			node = node[token.charAt(i)]
		node

	has: (token) -> (@_getNode(token))?

	getNode: (token) -> @_getNode(token) or {}

	get: (token, node) -> ((@_getNode(token, node) or {}).ids) or {}

	count: (token, node) -> Object.keys(@get(token, node)).length

	remove: (token, id, node = @root) ->
		if not (node = @_getNode(token, node)) then return
		delete node.ids[id]

	expand: (token, memo = []) ->
		node = @getNode(token)

		# Add suffix if there are tokens here
		for k of (node.ids or {})
			memo.push(token)
			break

		# Recurse with same array to suffixed nodes.
		for k of node when k isnt 'docs'
			@expand(token + k, memo)

		memo

module.exports = InvertedIndex
