class Db
  models: {}

  @register = (name, model) =>
    console.info name, model
    @::models[name] = model

    return @

  model: (name) =>
    return console.error "Missing model '#{name}'." if not @models[name]?
    return @models[name].compile this

module.exports = Db