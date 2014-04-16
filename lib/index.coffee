class Model
  constructor: (@doc) ->

  whoami: () ->
    console.info 'iam model'

  save: () ->
    return console.error 'Missing the point award.' if not this.db
    return console.info "Saving #{@doc} to #{@db}."

  @compile: (db) ->
    # generate new class; aka I <3 aheckmann
    class model extends this
    model.prototype.db = db

    return model

class Submodel extends Model
  sub: true

  whoami: () ->
    console.info 'iam SUBmodel'

classSub1 = Submodel.compile 'db1'
classSub2 = Submodel.compile 'db2'
classSub3 = Submodel.compile 'db3'

m0 = new Model 'id0'
m1 = new classSub1 'id1-on-db1'
m2 = new classSub2 'id2-on-db2'
m3 = new classSub3 'id3-on-db3'
m4 = new Submodel 'id4'
m5 = new classSub2 'id5-on-db2'

m3.save()
m0.save()
m1.save()
m2.save()
m4.save()
m5.save()

m0.whoami()
m4.whoami()
m5.whoami()
