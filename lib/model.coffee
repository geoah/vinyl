ObjectID = require('mongodb').ObjectID
regexpClone = require 'regexp-clone'

class Model
  constructor: (doc) ->
    @_map doc

  _map: (doc) ->
    for own key, value of doc
      @[key] = value

  remove: (cb) ->
    return throw new Error 'Missing _id' if not @_id?
    @constructor.removeById @_id, (err, numberOfRemovedDocs) =>
      return cb err if err
      return cb "Error: Number of removed documents: #{numberOfRemovedDocs}" if numberOfRemovedDocs isnt 1
      delete @_id
      cb undefined, 1

  save: (cb) ->
    doc = @toJSON()

    _cb = (err, rows) =>
      return cb err if err
      @_map rows[0]
      cb undefined, @

    if @_id
      query = _id: new ObjectID @_id
      sort = undefined
      options = upsert: true
      @constructor.findAndModify query, sort, doc, options, _cb
    else
      @constructor.insert doc, safe: true, _cb

  toJSON: ->
    return toJSON @

  @_compile: (db) ->
    # generate new class; aka I <3 aheckmann
    class model extends this
    model.prototype.db = db
    return model

  @find: (query, fields, options, cb) ->
    if not cb
      if not options
        cb = fields
        options = {}
        fields = {}
      else
        cb = options
        options = fields
        fields = {}

    @prototype.db.find @prototype.collection, query, fields, options, (err, rows) =>
      return cb err if err
      models = []
      for row in rows then models.push new @ row
      cb undefined, models

  @findOne: (query, fields, options, cb) ->
    if not cb
      if not options
        cb = fields
        options = {}
        fields = {}
      else
        cb = options
        options = fields
        fields = {}

    @prototype.db.findOne @prototype.collection, query, fields, options, (err, row) =>
      return cb err if err
      model = new @ row
      cb undefined, model

  @findById: (_id, fields, options, cb) ->
    if not cb
      if not options
        cb = fields
        options = {}
        fields = {}
      else
        cb = options
        options = fields
        fields = {}

    _id = new ObjectID _id if typeof _id is 'string'
    query = _id: _id
    @prototype.db.findOne @prototype.collection, query, fields, options, (err, row) =>
      return cb err if err
      model = new @ row
      cb undefined, model

  @findByIdAndModify: (_id, document, options, cb) ->
    if not cb
      cb = options
      options = {}

    _id = new ObjectID _id if typeof _id is 'string'
    query = _id: _id
    @prototype.db.findAndModify @prototype.collection, query, {}, document, options, (err, row) =>
      return cb err if err
      model = new @ row
      cb undefined, model

  @findAndModify: (query, sort, document, options, cb) ->
    if not cb
      cb = options
      options = {}

    @prototype.db.findAndModify @prototype.collection, query, sort, document, options, (err, rows) =>
      return cb err if err
      models = []
      for row in rows then models.push new @ row
      cb undefined, models

  @insert: (documents, options, cb) ->
    if not cb
      cb = options
      options = {}

    @prototype.db.insert @prototype.collection, documents, options, (err, rows) =>
      return cb err if err
      models = []
      for row in rows then models.push new @ row
      cb undefined, models

  @remove: (query, options, cb) ->
    if not cb
      cb = options
      options = {}

    @prototype.db.remove @prototype.collection, query, options, (err, result) =>
      return cb err if err
      cb undefined, result

  @removeById: (_id, options, cb) ->
    if not cb
      cb = options
      options = {}

    _id = new ObjectID _id if typeof _id is 'string'
    query = _id: _id
    @prototype.db.remove @prototype.collection, query, options, (err, result) =>
      return cb err if err
      cb undefined, result

typeIsArray = Array.isArray || ( value ) -> return {}.toString.call( value ) is '[object Array]'

toJSON = (object) ->
  doc = {}
  for own key, value of object
    if typeIsArray value
      doc[key] = value
    else if typeof value is 'function'
      # Ignore
    else if value instanceof Date
      doc[key] = new value.constructor +value
    else if value instanceof RegExp
      doc[key] = regexpClone value
    else if value instanceof ObjectID
      doc[key] = new ObjectID value.id
    else if value instanceof Object
      doc[key] = toJSON value
    else
      doc[key] = value
  return doc

module.exports = Model
