assert = require 'assert'
sinon = require 'sinon'

Db = require "../../lib/db"
Model = require "../../lib/model"

describe "Db", ->
  beforeEach ->
    @subject = new Db("mongodb://localhost")

  afterEach (done) ->
    @subject.close () ->
      done()

  describe "register()", ->
    beforeEach (done) ->
      class Item extends Model

      @name  = "Book"
      @model = Item
      done()

    afterEach (done) ->
      Db::models = []
      done()

    it "registers the provided model", ->
      Db.register @name, @model
      assert.equal Db::models[@name], @model

    it "fails if model is of incorrect type", ->
      model = name: "Fake Book"

      try
        Db.register @name, model
        throw new Error
      catch err
        assert.notEqual err, undefined
        assert.notEqual Db::models[@name], model

    it "returns Db", ->
      _Db = Db.register @name, @model
      assert.equal _Db, Db

  describe "connect()", ->
    it "connects to a mongodb instance", (done) ->
      @subject.connect (err, db) ->
        assert.equal err, undefined
        assert.equal db.constructor.name, 'Db'
        done()

    it "fails to connect to an unknown mongodb instance", (done) ->
      @subject = new Db("mongodb://this-does-not-exist")
      @subject.connect (err, db) ->
        assert.notEqual err, undefined
        assert.equal db, undefined
        done()

  describe "collection()", ->
    beforeEach ->
      @collectionName = "test-collection"

    it "retrieves collection by name and without options", (done) ->
      @subject.collection @collectionName, (err, collection) ->
        assert.equal err, undefined
        assert.equal collection.constructor.name, 'Collection'
        done()

    it "retrieves collection by name and options", (done) ->
      options = serializeFunctions: true
      @subject.collection @collectionName, options, (err, collection) ->
        assert.equal err, undefined
        assert.equal collection.constructor.name, 'Collection'
        assert.equal collection.serializeFunctions, true
        done()

  describe "insert()", ->
    beforeEach ->
      @collectionName = "books"
      @doc = foo: "bar"
      @opts = timeout: 5

      @collectionSpy = sinon.spy @subject, "collection"

    it "retrieves collection instance by name", (done) ->
      @subject.insert @collectionName, @doc, @opts, (err, docs) =>
        assert.equal @collectionName, @collectionSpy.lastCall.args[0] # Collection name
        assert.equal 'object', typeof @collectionSpy.lastCall.args[1] # Options
        assert.equal 'function', typeof @collectionSpy.lastCall.args[2] # Callback
        assert.equal err, undefined
        assert.equal 'object', typeof docs
        done()

    it "inserts document using the retrieved mongodb collection instance", (done) ->
      @subject.insert @collectionName, @doc, @opts, (err, docs) =>
        assert.equal err, undefined
        assert.equal docs.length, 1
        assert.equal docs[0].foo, @doc.foo
        assert.notEqual docs[0]._id, undefined
        done()

