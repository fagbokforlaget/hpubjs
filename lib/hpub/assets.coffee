async = require 'async'
Lister = require './lister'
_ = require 'underscore'

class Assets
  constructor: (@baseFolder)->
    @folders = []
    @files = []

  addFolders: (folders...) ->
    for folder in folders
      @folders.push folder

  addFile: (file) ->
    @files.push file

  prepare: (callback) ->
    assets = []
    error = null

    do_the_walk = (folder, next) =>
      new Lister("#{@baseFolder}/#{folder}").list (err, result) =>
        error = err
        assets = _.union assets, _.map result, (r) -> "#{folder}/#{r}"
        next()

    async.forEachSeries @folders, do_the_walk, (err) ->
      error = err if err
      callback(error, assets)

module.exports = Assets