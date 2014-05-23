Vinyl = require '../lib'

# Create database connections.

db = new Vinyl.Db 'mongodb://localhost/test-vinyl-db'

# Create model classes.

class Something extends Vinyl.Model
  collection: 'somethings'
  db: db

class Nothing extends Vinyl.Model
  collection: 'nothings'
  db: db

Nothing.find {}, (err, docs) ->
  return console.error err if err
  console.info "Found #{docs.length} documents."

  if docs[0]?._id?.id?
    Nothing.findById docs[0]._id.id, (err, doc) ->
      return console.error err if err
      console.info "Looked for '#{docs[0]._id.toHexString()}' by id and found '#{doc._id.toHexString()}'."

    Nothing.findOne _id: docs[0]._id, (err, doc) ->
      return console.error err if err
      console.info "Looked for { _id: '#{docs[0]._id.toHexString()}' } and found '#{doc._id.toHexString()}'."
