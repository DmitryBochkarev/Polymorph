jade = require 'jade'

module.exports = (params, cb) ->
  try
    fn = jade.compile params.source, {filename: params.sourceFilename}
    cb null, fn {}
  catch e
    cb e
