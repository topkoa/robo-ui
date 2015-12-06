# server.coffee

# Requirements 
express = require 'express'
app = express()
five = require('johnny-five')
httpServer = require('http').createServer(app)
io = require('socket.io')(httpServer)
cvert = require 'colorvert'

# Port for Web Server
port = 3000

# Directives
app.use express.static(__dirname + '/public')
app.use '/bower_components', express.static(__dirname + '/bower_components')
app.get '/', (req, res) ->
  res.sendFile __dirname + '/public/index.html'

# Start Web Server
httpServer.listen port

console.log 'Server available at http://localhost:' + port

# TODO: Below should be refactored... 

led = undefined
hex = undefined

#Arduino board connection
board = new (five.Board)
board.on 'ready', ->
  console.log 'Arduino connected'
  led = new (five.Led)(5)
  myRGB = new five.Led.RGB
    pins:
      red: 9
      green: 10
      blue: 11

  # Experimental Grove Q Touch i2c sensor
  inc = 0
  keypad = new five.Keypad
    controller: "QTOUCH"
    keys: [ "1", "2", "3", "4", "5", "6", "7" ]

  #Socket connection handler
  io.on 'connection', (socket) ->
    console.log "Socket Initiated: #{socket.id}"

    keypad.on 'press', (data) ->
      console.log "press #{data.which}"
      io.emit 'key', data.which

    socket.on 'rgb', (data) ->
      hex = cvert.rgb_to_hex( data.green, data.red, data.blue )
      console.log "#{hex}"
      myRGB.color hex
      myRGB.intensity data.intensity

    socket.on 'led:on', (data) ->
      io.emit 'alert', "Pressed LED ON"

      # turn on your led...
      led.on()
      console.log 'LED ON RECEIVED'

    socket.on 'led:off', (data) ->

      #turn off your led
      led.off()
      console.log 'LED OFF RECEIVED'

  console.log 'Waiting for connection'
