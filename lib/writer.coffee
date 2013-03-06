archiver = require 'archiver'
async = require 'async'
_ = require "underscore"
fs = require 'fs-extra'

class Writer
  constructor: (@folder) ->
    @meta = 
      hpub: 1
      title: ''
      author: ''
      url: ''
      contents: []

    @filelist = []

    @assetsFolders = []
    @assetFiles = []

  build: (callback) ->
    fs.writeJSONFile "#{@folder}/book.json", @meta, (err) ->
      callback(err)

  addPage: (name) ->
    if fs.existsSync "#{@folder}/#{name}"
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

  addAssetsFolders: (folders...) ->
    for folder in folders
      @assetsFolders.push folder

  addAssetFile: (file) ->
    @assetFiles.push file

  _walk: (dir, removeString, done) ->
    # recursive search in directory
    # http://stackoverflow.com/a/5827895
    self = @
    results = []
    fs.readdir dir, (err, list) ->
      return done(err)  if err
      pending = list.length
      return done(null, results)  unless pending
      list.forEach (file) ->
        file = dir + "/" + file
        fs.stat file, (err, stat) ->
          if stat and stat.isDirectory()
            self._walk file, removeString, (err, res) ->
              results = results.concat(res)
              done null, results  unless --pending
          else
            results.push file.replace(removeString, '')
            done null, results  unless --pending

  _prepareAssets: (callback) ->
    assets = []
    error = null

    do_the_walk = (folder, next) =>
      @_walk "#{@folder}/#{folder}", "#{@folder}/", (err, result) ->
        error = err
        assets = _.union assets, result
        next()

    async.forEachSeries @assetsFolders, do_the_walk, (err) ->
      error = err if err
      callback(error, assets)

  pack: (name, callback) ->
    out = fs.createWriteStream("#{name}.hpub")
    archive = archiver.createZip({level: 1})
    archive.pipe(out)

    archive.on 'error', (err) ->
      console.log "pack err", err

    series = @meta.contents
    series.push "book.json"
    series.push @meta.cover if @meta.cover

    @_prepareAssets (err, result) =>
      unless err
        series = _.union series, result
        series = _.union series, @assetFiles
        async.forEachSeries series, (file, next) =>
            archive.addFile fs.createReadStream("#{@folder}/#{file}"), {name: "#{file}"}, -> 
                next()
          , (err) ->
            archive.finalize (err, written) ->
                callback(err, written)


exports.Writer = Writer
