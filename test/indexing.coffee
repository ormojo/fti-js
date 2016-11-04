{ expect } = require 'chai'

{ TextIndex } = require '..'

describe 'index testing', ->
	it 'should do stuff', ->
		idx = new TextIndex({
			fields: {
				text: { }
			}
		})

		idx.add({
			id: 'first'
			text: "this is the first document aardvark"
		})

		idx.add({
			id: 'second'
			text: "this is the second document cow"
		})

		console.log idx.search('second')
		console.log idx.search('thi')
		console.log idx.search('sec fi')
		console.log idx.search('sec fi', 'OR')
		console.log idx.search('sec first aardvark', 'OR')

		idx.removeById('second')
		idx.removeById('first')

		# SHould be empty
		console.log idx.search('first')
