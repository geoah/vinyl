Vinyl = require './lib'

class Something extends Vinyl.Model
  collection: 'somethings'

  whoami: () ->
    console.info 'iam something'

class Nothing extends Vinyl.Model
  collection: 'nothings'

  whoami: () ->
    console.info 'iam nothing'

Vinyl.Db.register 'Something', Something
Vinyl.Db.register 'Nothing', Nothing

class FirstDb extends Vinyl.Db
  db: 'first-db'

class SecondDb extends Vinyl.Db
  db: 'second-db'

firstDb = new FirstDb
secondDb = new SecondDb

NothingOnFirstdb = firstDb.model 'Nothing'
SomethingOnFirstdb = firstDb.model 'Something'

NothingOnSecondDb = secondDb.model 'Nothing'
SomethingOnSecondDb = secondDb.model 'Something'

n1a = new NothingOnFirstdb 'nothing-a-on-first-db'
n1b = new NothingOnFirstdb 'nothing-b-on-first-db'

n2a = new NothingOnSecondDb 'nothing-a-on-second-db'
s2a = new SomethingOnSecondDb 'something-a-on-second-db'

console.info n1a
console.info n1b
console.info n2a
console.info s2a

n1a.save()
n1b.save()
n2a.save()
s2a.save()
