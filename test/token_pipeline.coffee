{ expect } = require 'chai'

EnglishStemmer = require '../src/EnglishStemmer'
EnglishStopWordFilter = require '../src/EnglishStopWordFilter'
Tokenizer = require '../src/Tokenizer'
TokenPipeline = require '../src/TokenPipeline'
Trimmer = require '../src/Trimmer'
PrefixNgram = require '../src/PrefixNgram'

describe 'TokenPipeline', ->
	izer = new Tokenizer()
	line = new TokenPipeline()
	line.addStage(Trimmer)
	line.addStage(EnglishStopWordFilter)
	line.addStage(EnglishStemmer)
	line.addStage(new PrefixNgram(10))

	it 'tokenizes', ->
		rst = izer.run('what who where')
		expect(rst).to.deep.equal(['what', 'who', 'where'])
		rst = izer.run(['one', 'two', 'three four'])
		expect(rst).to.deep.equal(['one', 'two', 'three four'])

	it 'trims', ->
		tl = new TokenPipeline
		tl.addStage(Trimmer)
		rst = tl.run(['    yes  '])
		expect(rst[0]).to.equal('yes')

	it 'ngrams', ->
		tl = new TokenPipeline
		tl.addStage(new PrefixNgram(3))
		rst = tl.run(['123'])
		expect(rst).to.deep.equal(['1','12','123'])

	it 'stopwords', ->
		tl = new TokenPipeline
		tl.addStage(EnglishStopWordFilter)
		rst = tl.run(['the', 'quick', 'brown', 'fox'])
		expect(rst).to.deep.equal(['quick', 'brown', 'fox'])

	it 'should do some stuff', ->
		rst = line.run(izer.run('the rain in spain falls mainly on the plain concerning pain trains steadfastly quickly slowly imploding antidisestablishmentarianism'))
		console.log rst
