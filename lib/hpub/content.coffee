class Content
  constructor: (@list) ->
    @content = []
    @assets = []

  exec: ->
    for file in @list
      parts = file.split('.')
      ext = parts[parts.length - 1]

      if ext is 'page' or ext is 'html' then @content.push file
      else @assets.push file