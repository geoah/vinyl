Db = require "../../lib/db"

describe "Db", ->
  describe ".register()", ->
    it "registers model with Db", ->
      name = "Book"
      model = jasmine.createSpy(name)
      expect(Db.register(name, model)).toBe(Db)
      expect(Db::models[name]).toBe(model)
