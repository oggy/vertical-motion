{CompositeDisposable} = require 'atom'

VerticalMotion =
  lineBounds: (editor, row) ->
    line = editor.lineTextForBufferRow(row)
    s = line.search(/\S/)
    s = line.length if s == -1
    e = line.search(/\S\s*$/) + 1
    e = line.length if e == 0
    [s, e]

  next: (event) ->
    editor = event.target.getModel()
    maxRow = editor.getLineCount() - 1
    editor.moveCursors (cursor) =>
      {row, column} = cursor.getBufferPosition()
      while row < maxRow
        row += 1
        [s, e] = @lineBounds(editor, row)
        break if s <= column <= e and s < e
      cursor.setBufferPosition([row, column])

  previous: (event) ->
    editor = event.target.getModel()
    editor.moveCursors (cursor) =>
      {row, column} = cursor.getBufferPosition()
      while row > 0
        row -= 1
        [s, e] = @lineBounds(editor, row)
        break if s <= column <= e and s < e
      cursor.setBufferPosition([row, column])

module.exports =
  VerticalMotion: VerticalMotion

  activate: (state) ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace',
      'vertical-motion:next': (event) -> VerticalMotion.next(event)
      'vertical-motion:previous': (event) -> VerticalMotion.previous(event)

  deactivate: ->
    @subscriptions.dispose()
