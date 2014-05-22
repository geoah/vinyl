ObjectID = require('mongodb').ObjectID

class Model
  constructor: (doc) ->
    @_map doc

  _map: (doc) ->
    for key, value of doc
      @[key] = value

  save: (cb) =>
    doc = {}
    for own key, value of @ then doc[key] = value

    # console.info @collection, @__proto__.collection, @constructor.prototype.collection
    collectionName = @__proto__.collection

    _cb = (err, row) =>
      return cb err if err
      @_map row
      cb undefined, @

    if @_id
      query = _id: new ObjectID @_id
      sort = undefined
      options = upsert: true
      @_db.findAndModify collectionName, query, sort, doc, options, _cb
    else
      @_db.insert collectionName, doc, safe: true, _cb

  @_compile: (db) ->
    # generate new class; aka I <3 aheckmann
    class model extends this
    model.prototype._db = db
    return model

  @find: (query, fields, options, cb) ->
    @prototype._db.find @prototype.collection, query, fields, options, (err, rows) =>
      return cb err if err
      models = []
      for row in rows then models.push new @ row
      cb undefined, models

  @findOne: (query, fields, options, cb) ->
    @prototype._db.findOne @prototype.collection, query, fields, options, (err, row) =>
      return cb err if err
      model = new @ row
      cb undefined, model

  @findAndModify: (query, sort, document, options, cb) ->
    @prototype._db.findAndModify @prototype.collection, query, sort, document, options, cb

  @insert: (documents, options, cb) ->
    @prototype._db.insert @prototype.collection, document, options, cb

module.exports = Model
