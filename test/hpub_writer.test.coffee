path = require 'path'
assert = require 'assert'
fs = require 'fs-extra'
hpub = require '../index.js'

existsSync = ((if fs.existsSync then fs.existsSync else path.existsSync))

describe 'hpub', ->
  describe 'writer', ->
    it 'should be able to add meta', ->
      writer = new hpub.Writer "./test/hpub_samples/book_to_be"
      meta =
        hpub: 1
        title: "Title of the book"
        author: ['First Author', 'Other Author']
        creator: ['fagbokforlaget']
        date: Date.now()
        url: 'http://example.com/book/thisbook'
        cover: 'book.png'
        publisher: 'Fagbokforlaget'
        orientation: 'both'
        zoomable: true

      writer.addMeta meta

      assert.equal writer.meta.title, meta.title

    it 'should be able to add a page', ->
      writer = new hpub.Writer "./test/hpub_samples/book_to_be"
      writer.addPage "page-000.html"

      assert.equal writer.meta.contents[0], "page-000.html"

    it 'should add book.json file', (done) ->
      writer = new hpub.Writer "./test/hpub_samples/book_to_be"
      meta =
        hpub: 1
        title: "Title of the book"
        author: ['First Author', 'Other Author']
        creator: ['fagbokforlaget']
        date: Date.now()
        url: 'http://example.com/book/thisbook'
        cover: 'book.png'
        publisher: 'Fagbokforlaget'
        orientation: 'both'
        zoomable: true

      writer.addMeta meta
      writer.addPage "page-000.html"

      writer.build (err) ->
        assert.equal err, null
        file = "./test/hpub_samples/book_to_be/book.json"
        assert.equal existsSync(file), true
        fs.removeSync file
        done()

    it 'should be able to add assets folders', ->
      writer = new hpub.Writer "./test/hpub_samples/book_to_be"
      writer.addAssetsFolders('css', 'js')

      assert.equal writer.assetsFolders[0], 'css'
      assert.equal writer.assetsFolders[1], 'js'

    it 'should create a simple hpub book', (done) ->
      writer = new hpub.Writer "./test/hpub_samples/book_to_be"
      meta =
        hpub: 1
        title: "Title of the book"
        author: ['First Author', 'Other Author']
        creator: ['fagbokforlaget']
        date: Date.now()
        url: 'http://example.com/book/thisbook'
        cover: 'book.png'
        publisher: 'Fagbokforlaget'
        orientation: 'both'
        zoomable: true

      writer.addMeta meta
      writer.addPage "page-000.html"

      writer.build (err) ->
        writer.pack "./test/book", (size) ->
          if size > 0 then res = true else res = false
          assert.equal res, true
          file = "./test/hpub_samples/book_to_be/book.json"
          fs.removeSync file
          fs.removeSync "test/book.hpub"
          done()
                

    it 'should create an hpub book with assets', (done) ->
      writer = new hpub.Writer "./test/hpub_samples/book_to_be"
      meta =
        hpub: 1
        title: "Title of the book"
        author: ['First Author', 'Other Author']
        creator: ['fagbokforlaget']
        date: Date.now()
        url: 'http://example.com/book/thisbook'
        cover: 'book.png'
        publisher: 'Fagbokforlaget'
        orientation: 'both'
        zoomable: true

      writer.addMeta meta
      writer.addPage "page-000.html"
      writer.addAssetsFolders 'css', 'js'

      writer.build (err) ->
        writer.pack "test/book", (size) ->
          file = "./test/hpub_samples/book_to_be/book.json"
          if size > 0 then res = true else res = false
          assert.equal res, true
          fs.removeSync file
          fs.removeSync "test/book.hpub"
          done()
