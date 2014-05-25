Db = require "../../lib/db"

describe "Db", ->
  afterEach (done) ->
    @subject.close () ->
      done()

  describe "connecting to a non existing db", ->
    beforeEach ->
      @subject = new Db("mongodb://this-does-not-exist")

    it "cb is called with error", (done) ->
      @subject.connect (err, db) ->
        expect(err).not.toBe(undefined)
        expect(db).toBe(undefined)
        done()

  describe "connecting to a db", ->
    beforeEach ->
      @subject = new Db("mongodb://localhost")

    describe ".register()", ->
      beforeEach ->
        @name  = "Book"
        @model = jasmine.createSpy(@name)

      it "registers model with Db", ->
        Db.register(@name, @model)
        expect(Db::models[@name]).toBe(@model)

      it "returns Db", ->
        expect(Db.register(@name, @model)).toBe(Db)

    describe "connect()", ->
      it "connects to mongodb", (done) ->
        @subject.connect (err, db) ->
          expect(err).toBe(undefined)
          expect(db.constructor.name).toBe('Db')
          done()

    describe "insert()", ->
      beforeEach ->
        @collection    = jasmine.createSpyObj("Collection", ["insert"])
        @collectionErr = undefined

        spyOn(@subject, 'collection').and.callFake (name, fun) =>
          fun(@collectionErr, @collection)

        @name = "books"
        @doc  = {foo: "bar"}
        @opts = {timeout: 5}
        @cb   = jasmine.createSpy()

      it "fetches collection instance via collection()", ->
        @subject.insert(@name, @doc, @opts, @cb)
        expect(@subject.collection).toHaveBeenCalled()
        expect(@subject.collection.calls.mostRecent().args[0]).toBe(@name)
        expect(typeof @subject.collection.calls.mostRecent().args[1]).toBe("function")

      it "inserts document into collection", ->
        @subject.insert(@name, @doc, @opts, @cb)
        expect(@collection.insert).toHaveBeenCalledWith(@doc, @opts, @cb)

      describe "when an error occurs while fetching collection instance", ->
        beforeEach -> @collectionErr = {message: "ZOMG PANIC!"}

        it "cb is called with error", ->
          @subject.insert(@name, @doc, @opts, @cb)
          expect(@cb).toHaveBeenCalledWith(@collectionErr)
          expect(@collection.insert).not.toHaveBeenCalled()

