Promise = require 'bluebird'
somata = require 'somata-promise'

sayHello = (name) ->
    Promise.resolve("Hello, #{name}!")

new somata.Service 'hello:promises', {
    sayHello
}
