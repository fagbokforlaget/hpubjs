assert = require('assert')
fs = require('fs-extra')
Hpub = require('../index.js')
_ = require 'underscore'

describe 'hpub', ->
  describe 'reader', ->

    it 'should read file', (done) ->

        hpub = new Hpub.Reader "./test/hpub_samples/book.hpub"
        hpub.read (err) =>
            assert.equal _.isArray(hpub.zip.fileList), true
            assert.equal hpub.zip.fileList.length, 3
            assert.equal hpub.isValid(), true
            done()

    it 'should read hpub from folder', (done) ->
        hpub = new Hpub.Reader "./test/hpub_samples/unpacked_book/"
        hpub.read (err) ->
            assert.equal _.isArray(hpub.zip.fileList), true
            assert.equal hpub.zip.fileList.length, 3
            assert.equal hpub.isValid(), true
            done()

    it "should extract file", (done) ->
        hpub = new Hpub.Reader "./test/hpub_samples/book.hpub"
        hpub.read (err) ->
            hpub.extract "./test/tmp", (err) ->
                assert.equal fs.existsSync('./test/tmp/book.json'), true
                assert.equal fs.existsSync('./test/tmp/book.png'), true
                assert.equal fs.existsSync('./test/tmp/page-000.html'), true
                fs.removeSync './test/tmp'
                done()

    it "should copy dir", (done) ->
        hpub = new Hpub.Reader "./test/hpub_samples/unpacked_book/"
        hpub.read (err) ->
            hpub.extract "./test/tmp", (err) ->
                assert.equal fs.existsSync('./test/tmp/book.json'), true
                assert.equal fs.existsSync('./test/tmp/book.png'), true
                assert.equal fs.existsSync('./test/tmp/page-000.html'), true
                fs.removeSync './test/tmp'
                done()

    it "should read meta file (book.json)", (done) ->
        hpub = new Hpub.Reader "./test/hpub_samples/unpacked_book/"
        hpub.read (err) ->
            meta = hpub.meta()  
            assert.equal meta.title, "Title of the book"
            assert.equal meta.contents[0], 'page-000.html'
            assert.equal meta.cover, 'book.png'
            done()

    it "should read meta file (book.json)", (done) ->
        hpub = new Hpub.Reader "./test/hpub_samples/book.hpub"
        hpub.read (err) ->
            meta = hpub.meta()  
            assert.equal meta.title, "Title of the book"
            assert.equal meta.contents[0], 'page-000.html'
            assert.equal meta.cover, 'book.png'
            done()    
