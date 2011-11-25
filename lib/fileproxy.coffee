fs = require 'fs'
Cache = require './cache'

module.exports = class Fileproxy
  constructor: (@options = {}) ->
    @cache = new Cache

  get: (filename, cb) ->
    fs.stat filename, (err, stats) =>
      unless err
        newMtime = +stats.mtime
        cached = @cache.cached filename

        if cached.get()?.mtime is newMtime
          cached.changed false
        else
          cached.set
            mtime: newMtime
            source: fs.readFileSync filename, 'utf8'

        source = cached.get 'source'
        changed = cached.changed()
        cb null, {source, changed}
      else
        cb err