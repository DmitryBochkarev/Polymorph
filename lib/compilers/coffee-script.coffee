CoffeeScript = require 'coffee-script'

module.exports = (options, cb) ->
  try
    cb null, CoffeeScript.compile options.source, {bare: on}
  catch err
    cb err
