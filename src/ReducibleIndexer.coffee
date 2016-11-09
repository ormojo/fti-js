
import { Reducible } from 'ormojo'

# A ReducibleIndexer is a Reducible that indexes each document described by the passed
# CRUD action into the given fulltext index.
export default class ReducibleIndexer extends Reducible
	constructor: (@index) ->
		super()

	reduce: (action) ->
		switch action.type
			when 'CREATE'
				@index.add(doc) for doc in action.payload

			when 'RESET'
				@index.clear()
				if (store = action.meta?.store)
					store.forEach (doc) => @index.add(doc)

			when 'UPDATE'
				@index.update(doc) for doc in action.payload

			when 'DELETE'
				@index.removeById(id) for id in action.payload

			else
				throw new Error('requires CRUD action')

		action
