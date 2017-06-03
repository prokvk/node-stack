app = require('knapp')

app.init {
	env_path: './config/.env'
	config_path: './config/config.cson'
}

rmq = require('knode-rabbitmq') process.config.rabbitmq

# init rabbitmq
rmq.initBindings (res) ->
	console.log "rabbitmq initialized successfully"

	queue = process.config.rabbitmq.bindings.test.queue

	rmq.subscribe queue, (err, message) ->
		msgData = rmq.getMessageData message
		console.log msgData

		rmq.ack queue, message
