app = require('knapp')

app.init {
	env_path: './config/.env'
	config_path: './config/config.cson'
	api_base_url: '/api/v1'
	auth: 'static_token'
}

app.setRoutes require('./routes') app.getRouter()

app.start process.config.knapp.port