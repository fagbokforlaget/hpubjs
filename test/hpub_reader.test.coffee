assert = require('assert')
fs = require('fs')
hpub = require('../index.js')

describe 'hpub', ->
  describe 'reader', ->
    # it 'should throw an Error when file is missing', ->
    #     fun = ->
    #         new hpub.Reader "./test/unknownbook.hpub"

    #     assert.throws (-> 
    #         fun()
    #     )

    # it 'should throw Error when file is corrupted', ->
    #     reader = new hpub.Reader "./test/corruptedbook.hpub"
    #     assert.throws (-> 
    #         throw new Error("Invalid or unsupported hpub format.")
    #     ), Error

    it 'should read file', ->
        new hpub.Reader "./test/hpub_samples/book1.hpub", (err, reader) ->
            assert.notEqual(reader.hpubFile, undefined)

    it 'should read hpub from folder', ->
        new hpub.Reader "./test/hpub_samples/unpacked_book/", (err, reader) ->
            meta = reader.meta()
            assert.notEqual(reader.hpubDir, undefined)
            assert.equal(meta.title, 'Title of the book')

    it 'should unpack file to folder', ->
        new hpub.Reader "./test/hpub_samples/book1.hpub", (err, reader) ->
            reader.unpack (folder) ->
                assert.notEqual(folder, undefined)
                reader.clean()

    it 'should read meta file from unpacked folder', ->
        new hpub.Reader "./test/hpub_samples/book1.hpub", (err, reader) ->
            reader.unpack (folder) ->
                meta = reader.meta()
                assert.notEqual(meta, undefined)
                assert.equal(typeof meta.author, 'object')
                reader.clean()

    it 'should read meta file without unpacking', ->
        new hpub.Reader "./test/hpub_samples/book1.hpub", (err, reader) ->
            meta = reader.meta()
            assert.notEqual(meta, undefined)
            assert.equal(typeof meta.author, 'object')

    





            
            


        

