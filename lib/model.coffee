class Model
  constructor: (doc) ->
    for key, value of doc
      @[key] = value

  bind: (db) ->
    @_db = db

  save: (cb) ->
    console.info "Saving on #{@_db.url}/#{@collection}."

    query = if @_id then _id: @_id else {}
    doc = {}
    for key, value of @
      doc[key] = value

    @_db.findAndModify @collection, query, {}, doc, {}, (err, result) =>
      return cb err if err
      @_id = result._id
      console.info @
      cb undefined, @

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
          cb undefined, array

  @findAndModify: (query, sort, document, options, cb) ->
    @prototype._db.findAndModify @prototype.collection, query, sort, document, options, cb

  @insert: (documents, options, cb) ->
    @prototype._db.collection @prototype.collection, (err, collection) =>
      return cb err if err
      collection.insert documents, options, cb

module.exports = Model
