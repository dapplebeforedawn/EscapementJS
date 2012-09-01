# Mark J. Lorenz - August 2012
# requires underscore.js
#
# This class implements a bowl feeder type excapement.  Feed it's queue object asynchronously, and it ensures that objects are spit back out at a constant rate
# you'll probably need to use `_.bind` or `$.proxy` to get meaningful `this` in your supplied callback
# If you pass in an object with an attribute "nextIn" that will be used as the delay before the next queued object is allowed to escape
class Escapement
    constructor: (interval, callback)->
        @interval = interval
        @queue = []
        @._dispense()
        @watchDogTime = 2000
        @callback = callback
    fill: (thing)->
        @queue.push thing
    _dispense: ()->
        dispensed = @queue.shift()
        if dispensed
            @._nextTimer(dispensed.nextIn)
            @callback(dispensed)
        else
            setTimeout _.bind(@._dispense, @), @watchDogTime
    _nextTimer: (delay)->
        setTimeout _.bind(@._dispense, @), (delay || @interval)
