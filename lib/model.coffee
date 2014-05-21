ObjectID = require('mongodb').ObjectID

class Model
  constructor: (doc) ->
    @_map doc

  _map: (doc) ->
    for key, value of doc
      @[key] = value

  save: (cb) =>
    console.info "Saving on #{@_db.url}/#{@collection}."

    doc = {}
    for own key, value of @ then doc[key] = value

    # console.info @collection, @__proto__.collection, @constructor.prototype.collection
    collectionName = @__proto__.collection

    _cb = (err, data) =>
      return cb err if err
      @_id = data._id if not @_id
      query = _id: new ObjectID @_id
      @_db.find collectionName, query, undefined, undefined, (err, rows) =>
        return cb err if err
        @_map rows[0] if rows[0]._id is @_id
        cb undefined, @

    if @_id
      query = _id: new ObjectID @_id
      sort = undefined
      options = upsert: true
      @_db.findAndModify collectionName, query, sort, doc, options, _cb
    else
      @_db.insert collectionName, doc, undefined, _cb

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

  @findAndModify: (query, sort, document, options, cb) ->
    @prototype._db.findAndModify @prototype.collection, query, sort, document, options, cb

  @insert: (documents, options, cb) ->
    @prototype._db.insert @prototype.collection, document, options, cb

module.exports = Model
