ObjectID = require('mongodb').ObjectID
regexpClone = require 'regexp-clone'

class Model
  constructor: (doc) ->
    @_map doc

  _map: (doc) ->
    for key, value of doc
      @[key] = value

  save: (cb) =>
    doc = @toJSON()

    # console.info @collection, @__proto__.collection, @constructor.prototype.collection
    collectionName = @__proto__.collection

    _cb = (err, rows) =>
      return cb err if err
      @_map rows[0]
      cb undefined, @

    if @_id
      query = _id: new ObjectID @_id
      sort = undefined
      options = upsert: true
      @__proto__.db.findAndModify collectionName, query, sort, doc, options, _cb
    else
      @__proto__.db.insert collectionName, doc, safe: true, _cb

  toJSON: ->
    return toJSON @

  @_compile: (db) ->
    # generate new class; aka I <3 aheckmann
    class model extends this
    model.prototype.db = db
    return model

  @find: (query, fields, options, cb) ->
    @prototype.db.find @prototype.collection, query, fields, options, (err, rows) =>
      return cb err if err
      models = []
      for row in rows then models.push new @ row
      cb undefined, models

  @findOne: (query, fields, options, cb) ->
    @prototype.db.findOne @prototype.collection, query, fields, options, (err, row) =>
      return cb err if err
      model = new @ row
      cb undefined, model

  @findAndModify: (query, sort, document, options, cb) ->
    @prototype.db.findAndModify @prototype.collection, query, sort, document, options, cb

  @insert: (documents, options, cb) ->
    @prototype.db.insert @prototype.collection, document, options, cb

toJSON = (object) ->
  doc = {}
  for own key, value of object
    if typeof value is 'function'
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
