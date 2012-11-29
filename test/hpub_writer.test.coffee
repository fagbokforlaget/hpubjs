assert = require('assert')
hpub = require('../index.js')
fs = require 'fs-extra'

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
        page = "page-000.html"

        writer.addPage page

        assert.equal writer.meta.contents[0], page

    it 'should add book.json file', ->
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

        page = "page-000.html"

        writer.addPage page

        writer.build (err) ->
            assert.equal err, null
            file = "./test/hpub_samples/book_to_be/book.json"
            assert.equal fs.existsSync(file), true
            fs.removeSync file

    it 'should be able to add assets folders', ->
        writer = new hpub.Writer "./test/hpub_samples/book_to_be"
        
        writer.addAssetsFolders('css', 'js')

        assert.equal writer.assetsFolders[0], 'css'
        assert.equal writer.assetsFolders[1], 'js'

    it 'should create a simple hpub book', ->
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

        page = "page-000.html"

        writer.addPage page

        writer.build (err) ->
            writer.pack "tmp/book", (size) ->
                if size > 0 then res = true else res = false
                assert.equal res, true
                file = "./test/hpub_samples/book_to_be/book.json"
                fs.removeSync file
                fs.removeSync "tmp/book.hpub"
                

    it 'should create an hpub book with assets', ->
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

        page = "page-000.html"

        writer.addPage page

        writer.addAssetsFolders 'css', 'js'

        writer.build (err) ->
            writer.pack "tmp/book", (size) ->
                file = "./test/hpub_samples/book_to_be/book.json"
                if size > 0 then res = true else res = false
                assert.equal res, true
                fs.removeSync file
                fs.removeSync "tmp/book.hpub"
