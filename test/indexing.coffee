{ expect } = require 'chai'

TextIndex = require '../src/TextIndex'
EnglishStemmer = require '../src/EnglishStemmer'
EnglishStopWordFilter = require '../src/EnglishStopWordFilter'
Tokenizer = require '../src/Tokenizer'
TokenPipeline = require '../src/TokenPipeline'
Trimmer = require '../src/Trimmer'
PrefixNgram = require '../src/PrefixNgram'

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
