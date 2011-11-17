stylus = require 'stylus'

module.exports = (params, cb) ->
  stylus.render params.source, {filename: params.filename}, cb
