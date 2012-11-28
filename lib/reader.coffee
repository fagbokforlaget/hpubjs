zipfile = require 'zipfile'
fs = require 'fs-extra'

class Reader
    constructor: (file, callback) ->
        fs.stat file, (err, stat) =>
            if stat
                if stat.isDirectory()
                    @unpacked = true
                    @hpubFile = undefined
                    @hpubDir = file
                else if stat.isFile()
                    @unpacked = false
                    @hpubFile = undefined
                    @_initHpubFile(file)
                    
                callback(null, @)
            else
                return throw new Error("Not an hpub book!")

    _initHpubFile: (file) ->
        try
            @hpubFile = new zipfile.ZipFile(file)
        catch e
            throw new Error e

    unpack: (toFolder, callback) ->
        if @hpubFile
            if typeof toFolder is 'function'
                callback = toFolder
                toFolder = undefined

            if toFolder 
                @hpubDir = toFolder
                fs.mkdirsSync @hpubDir
            else            
                ts = Math.round((new Date()).getTime())
                @hpubDir = "/tmp/hpub_#{ts}"
                fs.mkdirsSync @hpubDir

            for file in @hpubFile.names
                @extractToFile(file)

            @unpacked = true
        callback(@hpubDir)

    extractToBuffer: (name) ->
        @hpubFile.readFileSync name if @hpubFile

    extractToFile: (name) ->
        if @hpubFile
            if @hpubDir then _name = "#{@hpubDir}/#{name}"
            else _name = name

            buffer = @extractToBuffer(name)
            if name.charAt(name.length-1) is "/"
                fs.mkdirsSync _name
            else
                fs.writeFileSync _name, buffer

    meta: ->
        unless @unpacked
            JSON.parse(@extractToBuffer('book.json').toString())
        else
            JSON.parse(fs.readFileSync "#{@hpubDir}/book.json")

    getFile: (name) ->
        unless @unpacked
            @extractToBuffer(name).toString()
        else
            fs.readFileSync "#{@hpubDir}/#{name}"

    clean: ->
        if @hpubFile
            fs.removeSync @hpubDir
        else
            throw new Error "You can't remove folder created outside this library."

exports.Reader = Reader