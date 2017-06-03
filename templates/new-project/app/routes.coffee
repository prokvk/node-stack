rmq = require('knode-rabbitmq') process.config.rabbitmq
_ = require('lodash')

module.exports = (router) ->

	# SAMPLE ROUTE start
	defaultMeta = 
		inSchema:
			type: 'object'
			required: false
		outSchema:
			type: 'object'
			properties:
				success: {type: 'boolean'}

	meta = _.extend {}, defaultMeta, {
		inSchema:
			type: 'object'
			required: true
			properties:
				importantField: {type: 'string', required: true}
		testRequest:
			importantField: 'testing string'
	}
	router.post '/rmq', meta, (req, res) ->
		data = router.getRequestData req

		rmq.publish process.config.rabbitmq.bindings.test.exchange, {test: data.importantField}, (err, out) ->
			if err
				res.status 500
				return res.json {error: err}

			res.json {success: true}
	# SAMPLE ROUTE end

	# this line needs to stay at the end as return value
	router.getRouter()