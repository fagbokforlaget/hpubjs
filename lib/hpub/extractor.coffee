zipfile = require 'zipfile'
fs = require 'fs-extra'
Lister = require './lister'

class Extractor
  constructor: (@file, callback) ->
    @unpacked = false
    @fileList = []
    @zip = undefined
    stat = fs.statSync @file
    if stat
      if stat.isDirectory()
        @unpacked = true
        @zip = true
        new Lister(@file).list (err, list) =>
          if err then return callback err
          @fileList = list
          callback null, @

      else if stat.isFile()
        try 
          @zip = new zipfile.ZipFile @file
          @fileList = @zip.names
          callback null, @
        catch e
          callback(Error "This is not valid hpub file.", e)

  _mkdirDestFolder: (folder) ->

    fs.mkdirSync folder unless fs.existsSync folder
    return folder

  extractAll: (folder, callback) ->
    @destFolder = @_mkdirDestFolder folder
    unless @unpacked
      for file of @fileList
        @toFile(@fileList[file])

      callback null
    else
      fs.copy @file, @destFolder, (err) =>
        callback err

  checkIfFileExists: (_name) ->
    for name of @fileList
      return true if _name is @fileList[name]
    false

  toBuffer: (file) ->
    try
      @zip.readFileSync file if @zip
    catch e
      throw new Error "File #{file} is missing. #{e}"

  toFile: (file) ->
    if @zip
      _name = "#{@destFolder}/#{file}"
      
      buffer = @toBuffer(file)
      if file.charAt(file.length-1) is "/"
        fs.mkdirsSync _name unless fs.existsSync _name
      else
        fs.writeFileSync _name, buffer

  getFile: (file) ->
    if @unpacked
      fs.readFileSync("#{@file}/#{file}")
    else
      @toBuffer(file).toString()

module.exports = Extractor