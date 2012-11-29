assert = require('assert')
fs = require('fs')
hpub = require('../index.js')

describe 'hpub', ->
  describe 'reader', ->

    it 'should read file', (done) ->
        new hpub.Reader "./test/hpub_samples/book.hpub", (err, reader) ->
            assert.notEqual(reader.hpubFile, undefined)
            done()

    it 'should read hpub from folder', (done) ->
        new hpub.Reader "./test/hpub_samples/unpacked_book/", (err, reader) ->
            meta = reader.meta()
            assert.notEqual(reader.hpubDir, undefined)
            assert.equal(meta.title, 'Title of the book')
            done()

    it 'should unpack file to folder', (done) ->
        new hpub.Reader "./test/hpub_samples/book.hpub", (err, reader) ->
            reader.unpack (folder) ->
                assert.notEqual(folder, undefined)
                reader.clean()
                done()

    it 'should read meta file from unpacked folder', (done) ->
        new hpub.Reader "./test/hpub_samples/book.hpub", (err, reader) ->
            reader.unpack (folder) ->
                meta = reader.meta()
                assert.notEqual(meta, undefined)
                assert.equal(typeof meta.author, 'object')
                reader.clean()
                done()

    it 'should read meta file without unpacking', (done) ->
        new hpub.Reader "./test/hpub_samples/book.hpub", (err, reader) ->
            meta = reader.meta()
            assert.notEqual(meta, undefined)
            assert.equal(typeof meta.author, 'object')
            done()
