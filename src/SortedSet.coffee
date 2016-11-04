class SortedSet
	constructor: ->
		@elements = []

	add: ->
		for i in [0...arguments.length]
			elt = arguments[i]
			if (~@indexOf(elt)) then continue
			@elements.splice(@locationFor(elt), 0, elt)
		undefined

	toArray: -> @elements.slice()
	map: -> @elements.map.apply(@elements, arguments)
	forEach: -> @elements.forEach.apply(@elements, arguments)

	indexOf: (elem) ->
		start = 0
		end = @elements.length
		sectionLength = end - start
		pivot = start + Math.floor(sectionLength / 2)
		pivotElem = @elements[pivot]

		while sectionLength > 1
			if pivotElem is elem then return pivot
			if pivotElem < elem then start = pivot
			if pivotElem > elem then end = pivot

			sectionLength = end - start
			pivot = start + Math.floor(sectionLength / 2)
			pivotElem = @elements[pivot]

		if pivotElem is elem then pivot else -1

	locationFor: (elem) ->
		start = 0
		end = @elements.length
		sectionLength = end - start
		pivot = start + Math.floor(sectionLength / 2)
		pivotElem = @elements[pivot]

		while sectionLength > 1
			if pivotElem < elem then start = pivot
			if pivotElem > elem then end = pivot

			sectionLength = end - start
			pivot = start + Math.floor(sectionLength / 2)
			pivotElem = @elements[pivot]

		if pivotElem > elem then pivot else pivot + 1

	intersect: (otherSet) ->
		intersection = new SortedSet
		i = 0; j = 0; a_len = @length; b_len = otherSet.length
		a = @elements; b = otherSet.elements

		while true
			if (i > a_len - 1) or (j > b_len - 1) then break
			if a[i] is b[j] then intersection.add(a[i]); i++; j++; continue
			if a[i] < b[j] then i++; continue
			if a[i] > b[j] then j++; continue

		intersection

	clone: ->
		cl = new SortedSet
		cl.elements = @toArray()
		cl

	union: (otherSet) ->
		if (@length >= otherSet.length)
			longSet = @; shortSet = otherSet
		else
			longSet = otherSet; shortSet = @

		unionSet = longSet.clone()
		for i in [0...(shortSet.elements.length)]
			unionSet.add(shortSet.elements[i])

		unionSet

	toJSON: -> @toArray()

Object.defineProperty(SortedSet.prototype, 'length', {
	enumerable: true, configurable: false
	get: -> @elements.length
})

module.exports = SortedSet
