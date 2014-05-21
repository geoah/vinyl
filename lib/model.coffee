ObjectID = require('mongodb').ObjectID

class Model
  constructor: (doc) ->
    for key, value of doc
      @[key] = value

  bind: (db) ->
    @_db = db

  save: (cb) =>
    console.info "Saving on #{@_db.url}/#{@collection}."

    doc = {}
    for own key, value of @ then doc[key] = value

    # console.info @collection, @__proto__.collection, @constructor.prototype.collection
    collection = @__proto__.collection

    _cb = (err, data) =>
      return cb err if err
      @_id = data._id if not @_id
      cb undefined, data

    if @_id
      query = _id: new ObjectID @_id
      sort = undefined
      options = upsert: true
      @_db.findAndModify collection, query, sort, doc, options, _cb
    else
      @_db.insert collection, doc, undefined, _cb

  @_compile: (db) ->
    # generate new class; aka I <3 aheckmann
    class model extends this
    model.prototype._db = db

    return model

  @find: (query, fields, options, cb) ->
    @prototype._db.collection @prototype.collection, (err, collection) =>
      return cb err if err
      collection.find query, fields, options, (err, cursor) =>
        return cb err if err
        cursor.toArray (err, array) =>
          return cb err if err
          cursor.close() if not cursor.isClosed()
          models = []
          for row in array
            models.push new @ row
          console.info array, models
          cb undefined, models

  @findAndModify: (query, sort, document, options, cb) ->
    @prototype._db.findAndModify @prototype.collection, query, sort, document, options, cb

  @insert: (documents, options, cb) ->
    @prototype._db.insert @prototype.collection, document, options, cb

module.exports = Model
