expect = require 'expect.js'
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
        expect(err).not.to.be.equal undefined
        expect(db).to.be.equal undefined
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
        expect(Db::models[@name]).to.be(@model)

      it "returns Db", ->
        expect(Db.register(@name, @model)).to.be(Db)

    describe "connect()", ->
      it "connects to mongodb", (done) ->
        @subject.connect (err, db) ->
          expect(err).to.be(undefined)
          expect(db.constructor.name).to.be('Db')
          done()

    describe "collection()", ->
      it "retrieves collection", (done) ->
        collectionName = "test-collection"

        @subject.collection collectionName, (err, collection) ->
          expect(err).to.be undefined
          expect(collection.constructor.name).to.be('Collection')
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
