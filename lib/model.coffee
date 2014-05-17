class Model
  constructor: (doc) ->
    @_doc = doc

  bind: (db) ->
    @_db = db

  whoami: () ->
    console.info 'iam a basic model'

  save: () ->
    return console.error 'Missing the point award.' if not this.db
    return console.info "Saving #{@doc} on #{@db.db}/#{@collection}."

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
    @prototype._db.collection @prototype.collection, (err, collection) =>
      return cb err if err
      collection.findAndModify query, sort, document, options, cb

  @insert: (documents, options, cb) ->
    @prototype._db.collection @prototype.collection, (err, collection) =>
      return cb err if err
      collection.insert documents, options, cb

module.exports = Model
