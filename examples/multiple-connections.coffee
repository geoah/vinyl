Vinyl = require '../lib'

# Create model classes.

class Something extends Vinyl.Model
  collection: 'somethings'

class Nothing extends Vinyl.Model
  collection: 'nothings'

# Register models.

Vinyl.Db.register 'Something', Something
Vinyl.Db.register 'Nothing', Nothing

# Create database connections.

db1 = new Vinyl.Db 'mongodb://localhost/test-vinyl-db-1'
db2 = new Vinyl.Db 'mongodb://localhost/test-vinyl-db-2'

# Now we can retrieve models that are bound to specific dbs.

Nothing1 = db1.model 'Nothing'
Something1 = db1.model 'Something'

Nothing2 = db2.model 'Nothing'
Something2 = db2.model 'Something'

n1 = new Nothing1 name: 'a-nothing-on-db1'
n2 = new Nothing2 name: 'a-nothing-on-db2'

n1.save (err, doc) -> console.info err, doc.toJSON()
n2.save (err, doc) -> console.info err, doc.toJSON()
