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

module.exports = Model
