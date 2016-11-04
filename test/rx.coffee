{ expect } = require 'chai'

{ReducibleIndexer, TextIndex} = require '..'

{ RxUtil } = require 'ormojo'

describe 'ReducibleIndexer', ->
	it 'indexes', ->
		idx = new TextIndex({
			fields: {
				text: { }
			}
		})

		rix = new ReducibleIndexer(idx)
		inj = new RxUtil.Subject
		rix.connectAfter(inj)
		inj.next({ type: 'CREATE', payload:[ { id: 1, text: 'document number one' } ] })
		expect(idx.search('one')[0].id).to.equal(1)
		inj.next({ type: 'DELETE', payload: [ 1 ]})
		expect(idx.search('one').length).to.equal(0)
		inj.next({ type: 'CREATE', payload:[ { id: 1, text: 'document number one' } ] })
		inj.next({ type: 'UPDATE', payload:[ { id: 1, text: 'document number two' } ] })
		expect(idx.search('one').length).to.equal(0)
		expect(idx.search('two').length).to.equal(1)
