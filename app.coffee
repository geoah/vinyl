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

  @find: (query, fields, options, cb) ->
    _cb = (err, data) ->
      console.info 'GOT DATA'
      cb err, data

    super query, fields, options, _cb

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


console.info 'rest'

i = 0
NothingOnFirstdb.find {}, {}, {}, (err, array) =>
  for row in array
    console.info row
    row.something = i++
    row.save (err, _row) ->
      console.info err, _row

#NothingOnFirstdb.find {}, {}, {}, (err, array) =>
#  console.info err, array

# And now we can use.

#n1a = new NothingOnFirstdb name: 'nothing-2b', collection: 'making sure this doesnt break anything'
#n1b = new NothingOnFirstdb name: 'nothing-b-on-first-db'

#n1a.save (err, result) ->
#  console.info err, result

#  NothingOnFirstdb.find {}, {}, {}, (err, array) =>
#    console.info err, array

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
