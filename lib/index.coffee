class Model
  constructor: (@doc) ->

  bind: (@db) ->

  whoami: () ->
    console.info 'iam a basic model'

  save: () ->
    return console.error 'Missing the point award.' if not this.db
    return console.info "Saving #{@doc} on #{@db.db}/#{@collection}."

  @compile: (db) ->
    # generate new class; aka I <3 aheckmann
    class model extends this
    model.prototype.db = db

    return model

class Something extends Model
  collection: 'somethings'

  whoami: () ->
    console.info 'iam something'

class Nothing extends Model
  collection: 'nothings'

  whoami: () ->
    console.info 'iam nothing'

class Db
  models:
    Something: Something
    Nothing: Nothing

  model: (name) ->
    return console.error "Missing model '#{name}'." if not @models[name]?
    return @models[name].compile this

class FirstDb extends Db
  db: 'first-db'

class SecondDb extends Db
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
