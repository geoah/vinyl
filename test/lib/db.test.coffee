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

#    describe "insert()", ->
#      beforeEach ->
#        @collection = sinon.spy "Collection", ["insert"]
#        @collectionErr = undefined
#
#        spyOn(@subject, 'collection').and.callFake (name, fun) =>
#          fun(@collectionErr, @collection)
#
#        @name = "books"
#        @doc  = {foo: "bar"}
#        @opts = {timeout: 5}
#        @cb   = jasmine.createSpy()
#
#      it "fetches collection instance via collection()", ->
#        @subject.insert(@name, @doc, @opts, @cb)
#        expect(@subject.collection).toHaveBeenCalled()
#        expect(@subject.collection.calls.mostRecent().args[0]).toBe(@name)
#        expect(typeof @subject.collection.calls.mostRecent().args[1]).toBe("function")
#
#      it "inserts document into collection", ->
#        @subject.insert(@name, @doc, @opts, @cb)
#        expect(@collection.insert).toHaveBeenCalledWith(@doc, @opts, @cb)
#
#      describe "when an error occurs while fetching collection instance", ->
#        beforeEach -> @collectionErr = {message: "ZOMG PANIC!"}
#
#        it "cb is called with error", ->
#          @subject.insert(@name, @doc, @opts, @cb)
#          expect(@cb).toHaveBeenCalledWith(@collectionErr)
#          expect(@collection.insert).not.toHaveBeenCalled()
