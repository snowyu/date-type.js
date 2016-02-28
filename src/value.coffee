inherits        = require 'inherits-ex/lib/inherits'
extend          = require 'util-ex/lib/extend'
isString        = require 'util-ex/lib/is/type/string'
defineProperty  = require 'util-ex/lib/defineProperty'
Value           = require 'abstract-type/value'

getOwnPropertyNames = Object.getOwnPropertyNames
getObjectKeys = Object.keys

# Some methods extract from: https://github.com/datejs/Datejs
module.exports = class DateValue
  inherits DateValue, Value

  constructor: ->return super

  #Merge all the Date's instance methods.
  vDateMethodNames = getOwnPropertyNames Date::
  vDateMethodNames = vDateMethodNames.filter (name)-> not (name in ['constructor', 'valueOf', 'toJSON'])
  for vDateMethodName in vDateMethodNames
    @::[vDateMethodName] = ((aName)->
      -> Date::[aName].apply @value, arguments
    )(vDateMethodName)

  # _initialize: (aValue, aType, aOptions)->
  # _assign:(aValue)->
  _toObject: (aOptions)->@value
  toString: -> String @value
  valueOf: ->@value.getTime()
  isLeapYear: -> @$type.isLeapYear @getFullYear()
  getDaysInMonth: -> @$type.getDaysInMonth @getFullYear(), @getMonth()
  ###
      Resets the time of this Date object to 12:00 AM (00:00), which is the start of the day.
      @return {Date}    this date instance
  ###
  clearTime: -> @$type.clearTime(@)
  ###
    Adds the specified number of days to this instance.
    @param {Number}   The number of days to add. The number can be positive or negative [Required]
    @return {Date}    this
  ###
  addDays: (value)->
    @setDate @getDate() + value * 1
    @
  ###
    Adds the specified number of weeks to this instance.
    @param {Number}   The number of weeks to add. The number can be positive or negative [Required]
    @return {Date}    this
  ###
  addWeeks: (value)-> @addDays value * 7
  ###
    Adds the specified number of months to this instance.
    @param {Number}   The number of months to add. The number can be positive or negative [Required]
    @return {Date}    this
  ###
  addMonths: (value)->
    n = @getDate()
    @setDate 1
    @setMonth @getMonth() + value
    @setDate Math.min(n, @getDaysInMonth())
    @
  ###
    Adds the specified number of years to this instance.
    @param {Number}   The number of years to add. The number can be positive or negative [Required]
    @return {Date}    this
  ###
  addYears: (value)-> @addMonths value * 12
  ###
    Compares this instance to another Date object and returns true if they are equal.
    @param {Date}     Date object to compare. If no date to compare, new Date() [now] is used.
    @return {Boolean} true if dates are equal. false if they are not equal.
  ###
  equals: (value)-> @$type.equals @value, value
  ###
    Compares this instance to a Date object and returns an number indication of their relative values.
    @param {Date}     Date object to compare [Required]
    @return {Number}  -1 = this is lessthan date. 0 = values are equal. 1 = this is greaterthan date.
  ###
  compareTo: (value)-> @$type.compare @value, value

