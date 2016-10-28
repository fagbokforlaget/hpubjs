path = require 'path'
archiver = require 'archiver'
async = require 'async'
_ = require "underscore"
fs = require 'fs-extra'
Assets = require './hpub/assets'

existsSync = ((if fs.existsSync then fs.existsSync else path.existsSync))

class Writer
  constructor: (@folder) ->
    @meta =
      hpub: 1
      title: ''
      author: ''
      url: ''
      contents: []

    @filelist = []

    @assets = new Assets @folder

  build: (callback) ->
    fs.writeJSON "#{@folder}/book.json", @meta, (err) ->
      callback(err)

  addPage: (name) ->
    if existsSync "#{@folder}/#{name}"
      @meta.contents.push name

  # This method will cast all string objs to proper types
  cleanedMeta: (meta) ->
    i = 0
    keys = Object.keys(meta)
    # Do this sync.
    while i < keys.length
      key = keys[i]
      if typeof meta[key] is "string"
        # cast it to boolean
        if meta[key] is "true"
          meta[key] = true
          i++
          continue
        if meta[key] is "false"
          meta[key] = false
          i++
          continue

        # cast it to integers
        if not isNaN Math.round(meta[key])
          meta[key] = Math.round meta[key]

        # cast creators and authors to Array
        if key in ["creator", "author"]
          meta[key] = meta[key].split /, /
      i++
    meta

  addMeta: (meta) ->
    for property of @cleanedMeta meta
      @meta[property] = meta[property]

  pack: (name, callback) ->
    out = fs.createWriteStream("#{name}.hpub")
    # archive = archiver.createZip({level: 1})
    archive = archiver('zip')
    archive.pipe(out)
    error = undefined

    archive.on 'error', (err) ->
      console.log "pack err", err

    out.on 'close', ->
      callback(error, this.bytesWritten)

    series = @meta.contents
    series.push "book.json"
    series.push @meta.cover if @meta.cover

    @assets.prepare (err, result) =>
      unless err
        series = _.union series, result
        series = _.union series, @assets.files

        async.forEachSeries series, (file, next) =>
          readStream = fs.createReadStream "#{@folder}/#{file}"
          archive.append readStream, {name: file}, (err) ->
            next()
        , (err) ->
          archive.finalize (err, bytes) ->
            error = err
      else
        callback(err, null)


exports.Writer = Writer
