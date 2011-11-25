uglifyjs = require 'uglify-js'

module.exports = (params, cb) ->
  try
    ast = uglifyjs.parser.parse params.source
    ast = uglifyjs.uglify.ast_mangle ast
    ast = uglifyjs.uglify.ast_squeeze ast
    cb null, uglifyjs.uglify.gen_code ast
  catch e
    cb e
