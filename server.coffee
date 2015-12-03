# server.coffee

# Web Server Stuff
express = require 'express'
app = express()

httpServer = require('http').createServer(app)

#five = require('johnny-five')

io = require('socket.io')(httpServer)

port = 3000

# Directives
app.use express.static(__dirname + '/public')
app.use '/bower_components', express.static(__dirname + '/bower_components')

app.get '/', (req, res) ->
  res.sendFile __dirname + '/public/index.html'

httpServer.listen port

console.log 'Server available at http://localhost:' + port

led = undefined

#Arduino board connection
#board = new (five.Board)
#board.on 'ready', ->
#  console.log 'Arduino connected'
#  led = new (five.Led)(2)
#  return

#Socket connection handler
io.on 'connection', (socket) ->
  console.log "Socket Initiated: #{socket.id}"
  socket.on 'led:on', (data) ->
    io.emit 'alert', "Pressed LED ON"

    # turn on your led...
    #led.on()
    console.log 'LED ON RECEIVED'

  socket.on 'led:off', (data) ->

    #turn off your led
    #led.off()
    console.log 'LED OFF RECEIVED'

console.log 'Waiting for connection'
