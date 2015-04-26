Promise = require 'bluebird'
somata = require 'somata-promise'

client = new somata.Client

client.remote('hello:promises', 'sayHello', 'george')
    .then (got) -> console.log got
    .catch (err) -> console.error err
.then process.exit

