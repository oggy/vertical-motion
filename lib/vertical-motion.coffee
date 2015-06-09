VerticalMotionView = require './vertical-motion-view'
{CompositeDisposable} = require 'atom'

module.exports = VerticalMotion =
  verticalMotionView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @verticalMotionView = new VerticalMotionView(state.verticalMotionViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @verticalMotionView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'vertical-motion:toggle': => @toggle()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @verticalMotionView.destroy()

  serialize: ->
    verticalMotionViewState: @verticalMotionView.serialize()

  toggle: ->
    console.log 'VerticalMotion was toggled!'

    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      @modalPanel.show()
