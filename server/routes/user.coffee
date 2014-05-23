user = require '../models/user'

#
# * GET users listing.
#
exports.list = (req, res) ->
  res.send 'respond with a resource'

exports.json_all = (req, res) ->
    user.find().exec (err, results) ->
        if(!res.headerSent)
          res.json(results)

exports.register_post = (req, res) ->
  console.log req.body
  new user(req.body).save (err) ->
    if err
      console.log 'Error in register', err
      res.render 'register.html'
    else
      console.log 'Successful login'
      res.redirect '/'

exports.register_get = (req, res) ->
  res.render 'register.html'

exports.login_post = (req, res) ->
  user.findOne email: req.body.email, (err, result) ->
    if result and result.authenticate(req.body.password)
      # set session user id
      req.session.user_id = result._id
      console.log 'logged in!'
      console.log req.session.user_id
      res.redirect '/'
    else
      console.log 'incorrect password'
      res.redirect 'login'

exports.login_get = (req, res) ->
  return res.render 'login.html' unless req.session.user_id
  console.log 'Already logged in'
  res.render 'index.html'
