express = require 'express'
routes = require './routes'
blog = require './routes/blog'
user = require './routes/user'
stylus = require 'stylus'
MemoryStore = require('connect').session.MemoryStore

app = module.exports = express.createServer()

# Configuration

app.configure ()->
  app.set 'views', __dirname + '/views'
  app.set 'view engine', 'jade'
  app.use express.bodyParser()
  app.use express.cookieParser()
  app.use express.methodOverride()
  app.use express.static(__dirname + '/public')
  app.use stylus.middleware({src:__dirname + '/public'})
  app.use app.router
  app.use express.session({secret: 'lay.zhu', store: new MemoryStore({reapInterval: 60000*10})})
  app.dynamicHelpers {messages: require('express-messages')}

app.configure 'development', ()->
  app.use express.errorHandler { dumpExceptions: true, showStack: true }
  app.use express.logger('dev')

app.configure 'production', ()->
  app.use express.errorHandler()

# Routers

app.get '/', routes.index

app.get '/blog', blog.all
app.get '/blog/:id', blog.single

app.post '/login', user.login
app.get '/logout', user.logout

app.get '/register_redirect', user.register_redirect
app.post '/register', user.register

app.listen 3000

console.log "Express server listening on port %d in %s mode", app.address().port, app.settings.env
