{VerticalMotion} = require '../lib/vertical-motion'
EditorState = require './editor-state'

describe "VerticalMotion", ->
  beforeEach ->
    waitsForPromise =>
      atom.project.open().then (editor) =>
        @editor = editor
        @event = target: {getModel: => @editor}

  describe "vertical-motion:next", ->
    it "skips lines that don't reach the current column", ->
      EditorState.set(@editor, "aa[0]\na\naa\naa\n")
      console.log(VerticalMotion)
      VerticalMotion.next(@event)
      expect(EditorState.get(@editor)).toEqual("aa\na\naa[0]\naa\n")

    it "skips lines that start after the current column", ->
      EditorState.set(@editor, "aa[0]\n   a\naa\naa\n")
      VerticalMotion.next(@event)
      expect(EditorState.get(@editor)).toEqual("aa\n   a\naa[0]\naa\n")

    it "lands on lines that are as long as the current column", ->
      EditorState.set(@editor, "aa[0]\naa\naa\n")
      VerticalMotion.next(@event)
      expect(EditorState.get(@editor)).toEqual("aa\naa[0]\naa\n")

    it "lands on lines that start on the current column", ->
      EditorState.set(@editor, "aa[0]\n  aa\naa\n")
      VerticalMotion.next(@event)
      expect(EditorState.get(@editor)).toEqual("aa\n  [0]aa\naa\n")

    it "skips blank lines", ->
      EditorState.set(@editor, "aa[0]\n\naa\naa\n")
      VerticalMotion.next(@event)
      expect(EditorState.get(@editor)).toEqual("aa\n\naa[0]\naa\n")

    it "skips lines that are only spaces", ->
      EditorState.set(@editor, "aa[0]\n   \naa\naa\n")
      VerticalMotion.next(@event)
      expect(EditorState.get(@editor)).toEqual("aa\n   \naa[0]\naa\n")

    it "stops at the end of the buffer", ->
      EditorState.set(@editor, "aa[0]\n")
      VerticalMotion.next(@event)
      expect(EditorState.get(@editor)).toEqual("aa\n[0]")

  describe "vertical-motion:previous", ->
    it "skips lines that don't reach the current column", ->
      EditorState.set(@editor, "aa\naa\na\naa[0]\n")
      console.log(VerticalMotion)
      VerticalMotion.previous(@event)
      expect(EditorState.get(@editor)).toEqual("aa\naa[0]\na\naa\n")

    it "skips lines that start after the current column", ->
      EditorState.set(@editor, "aa\naa\n   a\naa[0]\n")
      VerticalMotion.previous(@event)
      expect(EditorState.get(@editor)).toEqual("aa\naa[0]\n   a\naa\n")

    it "lands on lines that are as long as the current column", ->
      EditorState.set(@editor, "aa\naa\naa[0]\naa\n")
      VerticalMotion.previous(@event)
      expect(EditorState.get(@editor)).toEqual("aa\naa[0]\naa\naa\n")

    it "lands on lines that start on the current column", ->
      EditorState.set(@editor, "aa\naa\n  [0]aa\naa\n")
      VerticalMotion.previous(@event)
      expect(EditorState.get(@editor)).toEqual("aa\naa[0]\n  aa\naa\n")

    it "skips blank lines", ->
      EditorState.set(@editor, "aa\naa\n\naa[0]\n")
      VerticalMotion.previous(@event)
      expect(EditorState.get(@editor)).toEqual("aa\naa[0]\n\naa\n")

    it "skips lines that are only spaces", ->
      EditorState.set(@editor, "aa\naa\n   \naa[0]\n")
      VerticalMotion.previous(@event)
      expect(EditorState.get(@editor)).toEqual("aa\naa[0]\n   \naa\n")

    it "stops at the beginning of the buffer", ->
      EditorState.set(@editor, "\naa[0]")
      VerticalMotion.previous(@event)
      expect(EditorState.get(@editor)).toEqual("[0]\naa")
