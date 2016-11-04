{ expect } = require 'chai'

{ReducibleIndexer, TextIndex, SubjectSearcher } = require '..'

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
		expect(idx.search({query: 'one'})[0]).to.be.ok
		inj.next({ type: 'DELETE', payload: [ 1 ]})
		expect(idx.search({query: 'one'})[0]).to.not.be.ok
		inj.next({ type: 'CREATE', payload:[ { id: 1, text: 'document number one' } ] })
		inj.next({ type: 'UPDATE', payload:[ { id: 1, text: 'document number two' } ] })
		expect(idx.search({query: 'one'})[0]).to.not.be.ok
		expect(idx.search({query: 'two'})[0]).to.be.ok

describe 'SubjectSearcher', ->
	it 'searches', ->
		idx = new TextIndex({
			fields: { text: { } }
		})
		rix = new ReducibleIndexer(idx)
		inj = new RxUtil.Subject
		sea = new SubjectSearcher(idx)
		rix.connectAfter(inj)
		sea.subscribe( { next: (x) -> expect(x['1'] and x['2']).to.be.ok } )
		inj.next({ type: 'CREATE', payload:[ { id: 1, text: 'document number one' } ] })
		inj.next({ type: 'CREATE', payload:[ { id: 2, text: 'document number two' } ] })
		sea.next({ type: 'simple', query: 'document' })
