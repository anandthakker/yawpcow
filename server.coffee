express = require("express")
http = require("http")
path = require("path")
argv = require('optimist').argv

app = express()

app.set "port", 8080
app.use express.favicon()
app.use express.logger("dev")
app.use express.bodyParser()
app.use express.methodOverride()
app.use app.router

dir = argv.root ? "build"

app.use express.static(path.join(__dirname, dir))
app.get "/", express.static(path.join(__dirname, dir+"/index.html"))

app.use express.errorHandler()

exports.app = app

if argv.server
  http.createServer(app).listen app.get("port"), ->
    console.log "Express server listening on port " + app.get("port")


