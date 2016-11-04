SortedSet = require './SortedSet'
ForwardIndex = require './ForwardIndex'
InvertedIndex = require './InvertedIndex'
SparseVector = require './SparseVector'
Tokenizer = require './Tokenizer'
TokenPipeline = require './TokenPipeline'
Field = require './Field'

module.exports = class TextIndex
	constructor: (@spec) ->
		@fields = {}
		@nFields = 0
		for k, fspec of @spec.fields
			@fields[k] = new Field(@, fspec, k)
			@nFields++

		@initialize()

	initialize: ->
		@documentStore = new ForwardIndex
		@tokenStore = new InvertedIndex
		@corpusTokens = new SortedSet
		@tokenizer = @spec.tokenizer or new Tokenizer
		@pipeline = @spec.pipeline or new TokenPipeline
		@_idfCache = {}

	identify: (doc) -> doc.id

	add: (doc) ->
		docRef = @identify(doc)
		docTokens = {}
		allDocumentTokens = new SortedSet

		for k, field of @fields
			fieldTokens = @pipeline.run(@tokenizer.run(field.get(doc)))
			docTokens[field.name] = fieldTokens
			for token in fieldTokens
				allDocumentTokens.add(token)
				@corpusTokens.add(token)

		# Index it in the forward index
		@documentStore.set(docRef, allDocumentTokens)

		# Compute Term Frequency for each token, then index it in the inverted index
		for token in allDocumentTokens.elements
			tf = 0
			for k, field of @fields
				fieldTokens = docTokens[field.name]
				if fieldTokens.length is 0 then continue
				tokenCount = 0
				tokenCount++ for fieldToken in fieldTokens when fieldToken is token
				tf += (tokenCount / fieldTokens.length * field.boost)

			@tokenStore.add(token, docRef, { id: docRef, tf })

		# Clear the idf cache
		@_idfCache = {}
		undefined

	removeById: (docRef) ->
		if not @documentStore.has(docRef) then return
		docTokens = @documentStore.get(docRef)
		for token in docTokens.elements
			@tokenStore.remove(token, docRef)
		@documentStore.remove(docRef)
		undefined

	remove: (doc) -> @removeById(@identify(doc))

	update: (doc) -> @remove(doc); @add(doc)

	clear: -> @initialize()

	idf: (term) ->
		cacheKey = '@' + term
		if cacheKey of @_idfCache then return @_idfCache[cacheKey]

		df = @tokenStore.count(term)
		idf = 1
		if df > 0
			idf = 1 + Math.log(@documentStore.length / df)

		@_idfCache[cacheKey] = idf

	documentVector: (id) ->
		# tokens is a SortedSet with all the tokens from the given document
		tokens = @documentStore.get(id)
		vector = new SparseVector

		for token in tokens.elements
			tf = @tokenStore.get(token)[id].tf
			idf = @idf(token)
			vector.insert(@corpusTokens.indexOf(token), tf * idf)

		vector

	search: (query, operator = "AND") ->
		tokens = @pipeline.run(@tokenizer.run(query))
		queryVector = new SparseVector
		documentSets = []
		fieldBoosts = 0; fieldBoosts += field.boost for k,field of @fields

		if not tokens.some( (token) => @tokenStore.has(token) ) then return []

		# For each token, create a documentSet of documents matching the token.
		for token in tokens
			# How is this the term frequency...?????????
			tf = 1 / ( tokens.length * @nFields * fieldBoosts )

			# For each expansion of the token, score and accumulate matching docs.
			accumulator = new SortedSet
			expansions = @tokenStore.expand(token)
			for expansion in expansions
				# If token isn't exact match, penalize score.
				similarityBoost = 1
				if expansion isnt token
					diff = Math.max(3, expansion.length - token.length)
					similarityBoost = 1 / Math.log(diff)

				# Insert a similarity entry in the query vector at the index of this particular
				# expansion of the token.
				pos = @corpusTokens.indexOf(expansion)
				idf = @idf(expansion)
				if pos > -1
					queryVector.insert(pos, tf * idf * similarityBoost)

				# Add each matching document to the accumulator.
				matchingDocuments = @tokenStore.get(expansion)
				ids = Object.keys(matchingDocuments)
				for id in ids
					accumulator.add(matchingDocuments[id].id)

			# Add documents matching this one token to the documentSets.
			documentSets.push(accumulator)

		# Intersect all the documentSets ("AND" query) or union ("OR" query)
		reducer = if operator is 'AND'
			(memo, set) -> memo.intersect(set)
		else
			(memo, set) -> memo.union(set)


		documentSets.reduce( reducer )
		# Scorify each document
		.map( (id) =>
			{ id, score: queryVector.similarity(@documentVector(id))}
		)
