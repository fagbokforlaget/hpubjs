class Content
  constructor: (@list) ->
    @content = []
    @assets = []

  exec: ->
    for file of @list
      parts = @list[file].split('.')
      ext = parts[parts.length - 1]
      if ext is 'page' or ext is 'html' then @content.push @list[file]
      else @assets.push @list[file]
    @

module.exports = Content