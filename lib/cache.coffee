module.exports = class Cache
  constructor: (@options = {}) ->
    @cache = {}
  
  set: (index, field, value) ->
    [value, field] = [field, null] if typeof value is 'undefined'
    @cache[index] ?= {}
    if field?
      @cache[index].value ?= {}
      @cache[index].value[field] = value
      if @cache[index].value[field] isnt value
        @cache[index].changed = true
    else
      if @cache[index].value isnt value
        @cache[index].changed = true
      @cache[index].value = value
    this

  get: (index, field) ->
    value = @cache[index]?.value
    if value? and field?
      value[field]
    else
      value
  
  del: (index) ->
    delete @cache[index]
    this
  
  exist: (index, field) ->
    res = @cache[index]
    if res? and field? and res[field]?
      true
    else
      !!res

  changed: (index, value) ->
    if @cache[index] and value?
      @cache[index]?.changed = value
    @cache[index]?.changed

  cached: (index) ->
    bindApi this, [index], 'set', 'get', 'del', 'exist', 'changed'

bindApi = (self, params, functions...) ->
  result = {}
  for fn in functions then do (fn) ->
    result[fn] = (args...) ->
      self[fn] params..., args...
  result

