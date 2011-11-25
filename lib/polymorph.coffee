fs = require 'fs'
path = require 'path'

Fileproxy = require './fileproxy'
Cache = require './cache'
mime = require 'mime'
url = require 'url'

module.exports = class Polymorph
  constructor: (@options = {}) ->
    options.path ?= './assets'
    @cache = new Cache
    @handlers = []
    @fileproxy = new Fileproxy

  use: (handler) ->
    @handlers.push handler
  
  form: (_extname, _sourceExtname, _compiler) ->
    if typeof _sourceExtname is 'function'
      [_sourceExtname, _compiler] = [null, _sourceExtname]

    @use ({filename, polymorph}, next) ->
      if path.extname(filename) is _extname
        sourceFilename = "#{path.dirname(filename)}/#{path.basename(filename, _extname)}#{_sourceExtname or _extname}"

        compile = (source) ->
          _compiler {source, filename, sourceFilename}, (err, compiled) ->
              throw err if err
              polymorph.cache.set filename, compiled
              next()
        cached = polymorph.cache.cached filename
        if cached.changed()
          compile cached.get()
        else
          polymorph.fileproxy.get sourceFilename, (err, result) ->
            unless err
              {source, changed} = result
              if changed
                compile source
              else
                next()
            else
              next()
      else
        next()


  middleware: () ->
    (req, res, next) =>
      originalFilename = url.parse(req.url).pathname
      filename = "#{@options.path}#{originalFilename}"
      extname = path.extname filename
      @cache.changed filename, false
      params = {
        polymorph: this
        filename
        extname
      }
      asyncPool @handlers, params, () =>
        if @cache.exist filename
          res.setHeader 'Content-Type', mime.lookup extname
          res.end @cache.get filename
        else
          next()

asyncPool = (pool, params, index, cb) ->
  [cb, index] = [index, 0] if typeof index is 'function'
  if index is pool.length
    cb params
  else
    next = () ->
      asyncPool pool, params, index+1, cb
    pool[index].call null, params, next
