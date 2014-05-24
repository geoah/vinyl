Db = require "../../lib/db"

describe "Db", ->
  beforeEach ->
    @subject = new Db("mongodb://foo.bar:1234")

  describe ".register()", ->
    it "registers model with Db", ->
      name = "Book"
      model = jasmine.createSpy(name)
      expect(Db.register(name, model)).toBe(Db)
      expect(Db::models[name]).toBe(model)

  describe "insert()", ->
    beforeEach ->
      @collection    = createSpyObj("Collection", ["insert"])
      @collectionErr = undefined

      spyOn(@subject, 'collection').andCallFake (name, fun) =>
        fun(@collectionErr, @collection)

      @name = "books"
      @doc  = {foo: "bar"}
      @opts = {timeout: 5}
      @cb   = createSpy()

    it "fetches collection instance via collection()", ->
      @subject.insert(@name, @doc, @opts, @cb)
      expect(@subject.collection).toHaveBeenCalled()
      expect(@subject.collection.calls[0].args[0]).toBe(@name)
      expect(typeof @subject.collection.calls[0].args[1]).toBe("function")

    it "inserts document into collection", ->
      @subject.insert(@name, @doc, @opts, @cb)
      expect(@collection.insert).toHaveBeenCalledWith(@doc, @opts, @cb)

    describe "when an error occurs while fetching collection instance", ->
      beforeEach -> @collectionErr = {message: "ZOMG PANIC!"}

      it "cb is called with error", ->
        @subject.insert(@name, @doc, @opts, @cb)
        expect(@cb).toHaveBeenCalledWith(@collectionErr)
