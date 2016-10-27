{ expect } = require 'chai'

ForwardIndex = require '../src/ForwardIndex'
InvertedIndex = require '../src/InvertedIndex'
SortedSet = require '../src/SortedSet'
SparseVector = require '../src/SparseVector'

describe 'ForwardIndex', ->
	it 'should store', ->
		fi = new ForwardIndex
		fi.set('123', {hello: 'world'})
		expect(fi.has('123')).to.equal(true)
		expect(fi.get('123')).to.deep.equal({hello:'world'})
		expect(fi.length).to.equal(1)
		fi.remove('123')
		expect(fi.has('123')).to.equal(false)
		expect(fi.length).to.equal(0)

describe 'SortedSet', ->
	it 'should sort', ->
		ss = new SortedSet
		ss.add('world')
		ss.add('hello')
		ss.add('aardvark')
		ss.add('bear')
		expect(ss.toArray()).to.deep.equal(['aardvark', 'bear', 'hello', 'world'])
		expect(ss.length).to.equal(4)

	it 'should union', ->
		ss = new SortedSet
		ss.add('world')
		ss.add('hello')
		ss.add('aardvark')
		ss.add('bear')
		ss2 = new SortedSet
		ss2.add('tiger')
		ss2.add('antelope')
		ss2.add('bear')
		u = ss.union(ss2)
		expect(u.toArray()).to.deep.equal([ 'aardvark', 'antelope', 'bear', 'hello', 'tiger', 'world' ])
		expect(u.length).to.equal(6)

	it 'should intersect', ->
		ss = new SortedSet
		ss.add('world')
		ss.add('hello')
		ss.add('aardvark')
		ss.add('bear')
		ss2 = new SortedSet
		ss2.add('tiger')
		ss2.add('antelope')
		ss2.add('bear')
		ss2.add('hello')
		ss2.add('kitty')
		i = ss.intersect(ss2)
		expect(i.toArray()).to.deep.equal([ 'bear', 'hello' ])

describe 'SparseVector', ->
	it 'should have basic internal structure', ->
		sv = new SparseVector
		sv.insert(1000, 3)
		sv.insert(5000, 4)
		expect(sv.length).to.equal(2)
		expect(sv.magnitude()).to.equal(5)
		sv.insert(100000, 12)
		expect(sv.length).to.equal(3)
		expect(sv.magnitude()).to.equal(13)

	it 'should dot product', ->
		sv = new SparseVector
		sv.insert(1000, 3)
		sv.insert(2000, 4)
		sv.insert(5000, 5)
		sv2 = new SparseVector
		sv2.insert(1100, 3)
		sv2.insert(2000, 4)
		sv2.insert(5000, 5)
		expect(sv.dot(sv2)).to.equal(41)

describe 'InvertedIndex', ->
	ii = new InvertedIndex
	ii.add('hello', '1', { token: 'hello'})
	ii.add('hello', '2', { token: 'hello'})
	ii.add('help', '1', { token: 'help'})
	ii.add('cruel', '1', { token: 'cruel'})
	ii.add('world', '1', { token: 'world'})

	it 'should do basic ops', ->
		expect(ii.has('hello')).to.equal(true)
		expect(ii.has('hel')).to.equal(true)
		expect(ii.count('hello')).to.equal(2)
		expect(ii.count('help')).to.equal(1)

	it 'should expand partials', ->
		expect(ii.expand('he')).to.include('hello')
		expect(ii.expand('he')).to.include('help')

	it 'should mutate', ->
		ii.remove('hello', '2')
		expect(ii.count('hello')).to.equal(1)
