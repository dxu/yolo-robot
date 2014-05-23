express = require "express"
routes = require './routes/index'
user = require './routes/user'
http = require 'http'
path = require 'path'
mongoose = require 'mongoose'
MongoStore = require('connect-mongo')(express)


conf =
  db:
      db: 'yolo_robot'
      host: 'localhost'
      port: 27017
      username: ''
      password: ''
      collection: 'sessions'
    secret: 'this is a secret yo'


app = express()
app.configure ->
  app.set "port", process.env.PORT or 3300
  app.set "views", path.join(__dirname, "..", "dist", "templates")
  app.set 'view engine', 'ejs'
  app.engine 'html', require('ejs').renderFile
  app.use express.favicon()
  app.use express.logger "dev"
  app.use express.bodyParser()

  app.use express.cookieParser()
  app.use express.session
    secret: conf.secret,
    maxAge: new Date(Date.now() + 3600000),
    store: new MongoStore(conf.db)
  app.use express.methodOverride()
  app.use app.router
  app.use express.static path.join(__dirname, "..", "dist")

app.configure 'development', ->
  app.use express.errorHandler()


db_uri = 'mongodb://'
# if username and password exist
if conf.db.username and conf.db.password
  console.log 'there is a username and password'
  db_uri += conf.db.username + ':' + conf.db.password + '@'

db_uri += conf.db.host + ':' + conf.db.port + '/' + conf.db.db

mongoose.connect db_uri
db = mongoose.connection
db.on 'error', console.error.bind(console, 'Connection Error:')
db.once 'open', ->
  console.log 'Connected to the database'


app.get '/', routes.index
app.get "/users", user.list
app.get "/users.json", user.json_all
app.get "/register", user.register_get
app.post "/register", user.register_post
app.get "/login", user.login_get
app.post "/login", user.login_post

server = http.createServer(app).listen app.get("port"), ->
  console.log "Express server listening on port " + app.get("port")
