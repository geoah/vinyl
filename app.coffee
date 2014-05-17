Vinyl = require './lib'

# Create model classes.

class Something extends Vinyl.Model
  collection: 'somethings'

  whoami: () ->
    console.info 'iam something'

class Nothing extends Vinyl.Model
  collection: 'nothings'

  whoami: () ->
    console.info 'iam nothing'

# Register models in Db.

Vinyl.Db.register 'Something', Something
Vinyl.Db.register 'Nothing', Nothing

# Initialize them.

firstDb = new Vinyl.Db 'mongodb://localhost/vinyl-test-db-1'
secondDb = new Vinyl.Db 'mongodb://localhost/vinyl-test-db-2'

#firstDb.connect (err, db) ->
#  console.error err if err
#  console.info db

# In order for models to be attached to a specific database isntance we need to retrieve their base classes from the db
# object.

NothingOnFirstdb = firstDb.model 'Nothing'
SomethingOnFirstdb = firstDb.model 'Something'

NothingOnSecondDb = secondDb.model 'Nothing'
SomethingOnSecondDb = secondDb.model 'Something'

#NothingOnFirstdb.insert [{name: 'test-doc'}], {}, (err, result) ->
#  console.info err, result

#NothingOnSecondDb.insert [{name: 'test-doc-2'}], {}, (err, result) ->
#  console.info err, result

#NothingOnFirstdb.find {}, {}, {}, (err, array) =>
#  console.info err, array

#NothingOnSecondDb.find {}, {}, {}, (err, array) =>
#  console.info err, array

#NothingOnFirstdb.find {}, {}, {}, (err, array) =>
#  console.info err, array

# And now we can use.

#n1a = new NothingOnFirstdb 'nothing-a-on-first-db'
#n1b = new NothingOnFirstdb 'nothing-b-on-first-db'
#
#n2a = new NothingOnSecondDb 'nothing-a-on-second-db'
#s2a = new SomethingOnSecondDb 'something-a-on-second-db'
#
#console.info n1a
#console.info n1b
#console.info n2a
#console.info s2a
#
#n1a.save()
#n1b.save()
#n2a.save()
#s2a.save()
