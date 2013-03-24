_getRow= (idx)->
  for col in [1..3]
    ""+idx+col

_getCol= (idx)->
  for row in [1..3]
    ""+row+idx

_getBackSlash= () ->
  for idx in [1..3]
    ""+idx+idx

_getSlash= () ->
  rows = [1..3]
  for col in [1..3]
    ""+rows.pop()+col
TicTacToe =
  init: ->
    @board =
      '11': ""
      '12': ""
      '13': ""
      '21': ""
      '22': ""
      '23': ""
      '31': ""
      '32': ""
      '33': ""

    @player = "X"
    @rows2Check = []
    for idx in [1..3]
      @rows2Check.push _getRow idx
      @rows2Check.push _getCol idx
    @rows2Check.push _getSlash()
    @rows2Check.push _getBackSlash()
    @drawBox()
    @winner=""


  boardIsFull: () ->
    for box, player of @board
      if not player
        return false
    return true

  drawBox: () ->
    for box, player of @board
      element = document.getElementById(box)
      classes = element.className.split(" ")
      if player and not (player in classes)
        element.className += " "+player
      else if not player
        element.className = "col"
  mark: (element) ->
    # console.info element.className.indexOf(" ")
    #if "X" in element.className or "O" in element.className
    # console.info @player
    # console.info @
    if @winner or @boardIsFull()
      @init()
    else if @player == "O"
      navigator.notification.vibrate 500
    else
      # element.className = "col " + @player
      if @setBox(element.id)
        navigator.notification.vibrate 100
      else
        navigator.notification.vibrate 500

  endTurn: ->
    @player = (if @player == "X" then "O" else "X")
    @check4Winner()
    @drawBox()
    # check if the bot should play
    if @player == "O" and not @winner
      setTimeout @runBot, 1000
    # console.log @player

  setBox: (box) ->
    if not @board[box]
      @board[box] = @player
      @endTurn()
      return true
    else
      return false

  runBot: ->
    console.info "runBot"
    for action in ["canWin", "canBlock"]
      box = TicTacToe.bot[action]()
      if box
        TicTacToe.setBox box
        return

    if TicTacToe.setBox("22")
      return

    arr = []
    for box, player of TicTacToe.board
      if not player
        arr.push(box)

    if arr
      box = arr[Math.floor(Math.random() * arr.length)]
      ret = TicTacToe.setBox(box)
      console.info box, ret
      return

  bot:
    check: (row) ->
      ret =
        X: 0
        X_list: []
        O: 0
        O_list: []
        E: 0
        E_list: []
      for box in row
        key = if TicTacToe.board[box] then TicTacToe.board[box] else "E"
        ret[key] += 1
        ret[key+"_list"].push box

      return ret

    canWin: ->
      for row in TicTacToe.rows2Check
        info = @check row
        if info["O"] == 2 and info["E"] == 1
          return info["E_list"][0]

    canBlock: ->
      for row in TicTacToe.rows2Check
        info = @check row
        if info["X"] == 2 and info["E"] == 1
          return info["E_list"][0]

  toBlue: (element) ->
    element.className = element.className + " O"
    navigator.notification.vibrate 100

  check4Winner: ->
    for row in @rows2Check
      for player in ["X", "O"]
        if @isWinner player, row
          @setWinner player, row
          @winner = player

  isWinner: (player, row) ->
    # debugger
    # foo = []
    for box in row
      # element = document.getElementById(box)
      if not (player == @board[box])
        # foo.push element.className
        return false
    # console.info foo
    return true

  setWinner: (player, row) ->
    for box in row
      element = document.getElementById(box)
      element.className += " Winner"+player
TicTacToe.init()
window.bar = TicTacToe

if typeof navigator.notification == "undefined"
  navigator.notification = {
    vibrate: (foo) ->
  }

# for player in ["X", "O"]
#     for idx in [1..3]
#         alert player+ idx
