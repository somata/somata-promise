somata = require 'somata'
Promise = require 'bluebird'

# Helpers for wrapping promise-based methods with callbacks
# ------------------------------------------------------------------------------

# Execute a promise and call a given callback when done
callPromise = (promise, cb) ->
    promise
        .then (result) -> cb null, result
        .catch (error) -> console.error(error); cb error

# Takes a promise and returns a new function with a standard (args..., cb)
# shape that can then be used with a callback
wrappedPromise = (promise) ->
    (args..., cb) ->
        callPromise promise(args...), cb

# Turn an object of promises into an object of callbacks
wrappedPromises = (_o) ->
    o = {}
    for k, v of _o
        o[k] = wrappedPromise v
        console.log k
    o

# Somata Client sub-class that returns promises instead of taking callbacks
# ------------------------------------------------------------------------------

class PromiseClient extends somata.Client
    remote: (service_name, method, args...) ->

        # TODO: Use a fromNode helper from bluebird?
        gotfns = {}
        promise = new Promise (resolve, reject) ->
            gotfns.resolver = resolve
            gotfns.rejecter = reject

        super service_name, method, args..., (err, got) ->
            if err
                gotfns.rejecter err
            else
                gotfns.resolver got

        return promise

# Somata Service sub-class that expects methods as promises instead of callbacks
# ------------------------------------------------------------------------------

class PromiseService extends somata.Service
    constructor: (@name, @methods={}, options={}) ->
        super @name, wrappedPromises(@methods), options

# Export PromiseClient and PromiseService without "Promise" prefixes

module.exports = {
    Client: PromiseClient
    Service: PromiseService
}

