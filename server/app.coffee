express = require "express"
routes = require './routes/index'
http = require 'http'
path = require 'path'

app = express()
app.configure ->
  app.set "port", process.env.PORT or 3300
  app.set "views", path.join(__dirname, "..", "dist", "templates")
  app.set 'view engine', 'ejs'
  app.engine 'html', require('ejs').renderFile
  app.use express.favicon()
  app.use express.logger "dev"
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use app.router
  app.use express.static path.join(__dirname, "..", "dist")

app.configure 'development', ->
  app.use express.errorHandler()

app.get '/', routes.index

server = http.createServer(app).listen app.get("port"), ->
  console.log "Express server listening on port " + app.get("port")
