Extractor = require './hpub/extractor'
Content = require './hpub/content'

class Reader
  constructor: (@file) ->
    @zip = undefined
    @files = undefined

  read: (callback) ->
    new Extractor @file, (err, zip) =>
      if err then return callback(err)
      @extracted = true
      @zip = zip
      @files = @zip.fileList

      if @isValid()        
        callback null, @
      else
        callback Error "This is not valid hpub file - book.json is missing"

  isValid: ->
    unless @zip then return false
    @zip.checkIfFileExists 'book.json'

  extract: (destFolder, callback) ->
    if @zip
      @zip.extractAll destFolder, (err) ->
        callback(err, @)
    else
      @read (err) ->
        if err then return callback(err)

        @zip.extractAll destFolder, (err) ->
          callback(err, @)

  meta: ->
    JSON.parse @zip.getFile('book.json') if @zip

  getFile: (file) ->
    @zip.getFile(file) if @zip

  clean: ->
    if @hpubFile
      fs.removeSync @hpubDir
    else
      throw new Error "You can't remove folder created outside this library."

  content: ->
    @_files ||= new Content(@files).exec() if @files
    @_files.content

  assets: ->
    @_files ||= new Content(@files).exec() if @files
    @_files.assets

exports.Reader = Reader