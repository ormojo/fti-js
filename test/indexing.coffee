{ expect } = require 'chai'

{ TextIndex } = require '..'

describe 'index testing', ->
	it 'should do basic indexing', ->
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

		expect(idx.search({query: 'second'}).length).to.equal(1)
		expect(idx.search({query: 'thi'}).length).to.equal(2)
		expect(idx.search({query: 'sec fi'}).length).to.equal(0)
		expect(idx.search({query: 'sec fi', operator: 'OR'}).length).to.equal(2)
		expect(idx.search({query: 'sec first aardvark', operator: 'OR'}).length).to.equal(2)

		idx.removeById('second')
		idx.removeById('first')

		# SHould be empty
		expect(idx.search({query: 'this'}).length).to.equal(0)
