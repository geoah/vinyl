assert = require 'assert'
sinon = require 'sinon'

Db = require "../../lib/db"

describe "Db", ->

  describe "connecting to a non existing db", ->
    beforeEach ->

      @subject = new Db("mongodb://this-does-not-exist")

    afterEach (done) ->
      @subject.close () ->
        done()

    it "cb is called with error", (done) ->
      @subject.connect (err, db) ->
        assert.notEqual err, undefined
        assert.equal db, undefined
        done()

  describe "connecting to a db", ->
    beforeEach ->
      @subject = new Db("mongodb://localhost")

    afterEach (done) ->
      @subject.close () ->
        done()

    describe ".register()", ->
      beforeEach ->
        @name  = "Book"
        @model = name: @name

      it "registers model with Db", ->
        Db.register(@name, @model)
        assert.equal Db::models[@name], @model

      it "returns Db", ->
        assert.equal Db.register(@name, @model), Db

    describe "connect()", ->
      it "connects to mongodb", (done) ->
        @subject.connect (err, db) ->
          assert.equal err, undefined
          assert.equal db.constructor.name, 'Db'
          done()

    describe "collection()", ->
      it "retrieves collection without options", (done) ->
        collectionName = "test-collection"

        @subject.collection collectionName, (err, collection) ->
          assert.equal err, undefined
          assert.equal collection.constructor.name, 'Collection'
          done()

      it "retrieves collection with options", (done) ->
        collectionName = "test-collection"
        options = serializeFunctions: true

        @subject.collection collectionName, options, (err, collection) ->
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

      it "fetches collection instance via collection()", (done) ->
        @subject.insert @collectionName, @doc, @opts, (err, docs) =>
          assert.equal @collectionName, @collectionSpy.lastCall.args[0]
          assert.equal 'object', typeof @collectionSpy.lastCall.args[1]
          assert.equal 'function', typeof @collectionSpy.lastCall.args[2]
          assert.equal err, undefined
          assert.equal 'object', typeof docs
          done()

      it "inserts document into collection", (done) ->
        @subject.insert @collectionName, @doc, @opts, (err, docs) =>
          assert.equal err, undefined
          assert.equal docs.length, 1
          assert.equal docs[0].foo, @doc.foo
          assert.notEqual docs[0]._id, undefined
          done()

