
import { RxUtil } from 'ormojo'

# A SubjectSearcher is a Subject (both Observable and Observer) that takes search queries on its
# Observer channel, runs searches on the given index, then passes the results on its Observable
# channel.
export default class SubjectSearcher extends RxUtil.Subject
	constructor: (@index) -> super

	next: (query) ->
		if query?.type is 'simple'
			@results = @index.search({query: query.query, operator: query.operator, resultFormat: 'scoreMap'})
		else
			throw new Error('invalid query')

		super(@results)
