class Node
	constructor: (@idx, @val, @next) ->


class SparseVector
	constructor: ->
		@_magnitude = undefined
		@list = undefined
		@length = 0

	insert: (idx, val) ->
		@_magnitude = undefined
		list = @list

		if (not list) or (idx < list.idx)
			@list = new Node(idx, val, list)
			return @length++

		prev = list; next = list.next
		while next
			if idx < next.idx
				prev.next = new Node(idx, val, next)
				return @length++

			prev = next; next = next.next

		prev.next = new Node(idx, val, next)
		@length++

	magnitude: ->
		if @_magnitude then return @_magnitude
		node = @list; accum = 0
		while node
			accum += (node.val * node.val)
			node = node.next

		@_magnitude = Math.sqrt(accum)

	dot: (other) ->
		node = @list; otherNode = other.list; dotProduct = 0

		while node and otherNode
			if node.idx < otherNode.idx
				node = node.next
			else if node.idx > otherNode.idx
				otherNode = otherNode.next
			else
				dotProduct += (node.val * otherNode.val)
				node = node.next
				otherNode = otherNode.next

		dotProduct

	similarity: (other) ->
		@dot(other) / (@magnitude() * other.magnitude())

module.exports = SparseVector
