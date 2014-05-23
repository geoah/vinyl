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

# Now we just use them.

n = new Nothing name: 'a-nothing-on-db'
n.save (err, doc) ->
  return console.error err if err
  console.info doc.toJSON()

  doc.soMuch = 'amazed'

  doc.save (err, doc) ->
    return console.error err if err
    console.info doc.toJSON()
