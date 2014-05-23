mongodb = require 'mongodb'

class Db
  models: {}

  @register = (name, model) =>
    console.info name, model
    @::models[name] = model

    return @

  constructor: (url, options = {}) ->
    throw new Error 'No url defined' if not url

    @_connecting = @_connected = false
    @_collections = []

    @_url = url
    @_options = options

  connect: (cb) =>
    mongodb.connect @_url, @_options, (err, db) =>
      @_connecting = false
      if err
        @_connecting = false
        return cb err

      @_connected = true
      @_collections = {}

      @_db = db
      @_db.on 'close', (err) =>
        @_collections = {}
        console.error err if err
        return cb err

      cb undefined, db

    @_connecting = true

  collection: (collectionName, options, cb) =>
    if not cb
      cb = options
      options = {}

    if @_connecting is true
      return setTimeout () =>
        @collection collectionName, options, cb
      , 300

    if not @_connected
      return @connect (err) =>
        return cb err if err
        return @collection collectionName, options, cb

    if @_collections[collectionName]
      return cb undefined, @_collections[collectionName]
    else
      return @_db.collection collectionName, options, (err, collection) =>
        return cb err if err
        @_collections[collectionName] = collection
        return cb undefined, @_collections[collectionName]

  find: (collectionName, query, fields, options, cb) ->
    @collection collectionName, (err, collection) =>
      return cb err if err
      collection.find query, fields, options, (err, cursor) =>
        return cb err if err
        cursor.toArray (err, rows) =>
          return cb err if err
          cursor.close() if not cursor.isClosed()
          cb undefined, rows

  findOne: (collectionName, query, fields, options, cb) ->
    @collection collectionName, (err, collection) =>
      return cb err if err
      collection.findOne query, fields, options, (err, row) =>
        return cb err if err
        cb undefined, row

  model: (name) =>
    return console.error "Missing model '#{name}'." if not @models[name]?
    return @models[name]._compile this

  findAndModify: (collectionName, query, sort, document, options, cb) =>
    @collection collectionName, (err, collection) =>
      return cb err if err
      collection.findAndModify query, sort, document, options, cb

  remove: (collectionName, query, options, cb) =>
    @collection collectionName, (err, collection) =>
      return cb err if err
      collection.remove query, options, cb

  insert: (collectionName, document, options, cb) =>
    @collection collectionName, (err, collection) =>
      return cb err if err
      collection.insert document, options, cb

module.exports = Db