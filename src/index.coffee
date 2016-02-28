isInt           = require 'util-ex/lib/is/string/int'
isFloat         = require 'util-ex/lib/is/string/float'
isNumber        = require 'util-ex/lib/is/type/number'
isString        = require 'util-ex/lib/is/type/string'
isDate          = require 'util-ex/lib/is/type/date'
Attributes      = require 'abstract-type/lib/attributes'
Type            = require 'abstract-type'
DateValue       = require './value'
register        = Type.register
aliases         = Type.aliases

# Some methods extract from: https://github.com/datejs/Datejs
module.exports = class DateType
  register DateType
  aliases DateType, 'date', 'time', 'Time', 'DateTime', 'datetime'

  constructor: ->
    return super

  $attributes: Attributes
    min:
      type: 'Date'
      assigned: '_min' # the internal property name for min.
      assign: (value, dest)->
        value = dest.validateMin(value) if dest instanceof DateType
        value
    max:
      type: 'Date'
      assigned: '_max'
      assign: (value, dest)->
        value = dest.validateMax(value) if dest instanceof DateType
        value

  ValueType: DateValue

  # used by toJson()
  valueToString: (aValue)->
    aValue = @toISOString aValue
  # used by Json and assign().
  # convert a string to internal value.
  toValue: (aString, aOptions)->
    if isDate aString
      result = aString
    else if aString isnt undefined
      result = new Date aString
      result = undefined if isNaN result.valueOf()
    else
      result = new Date
    result
  validateMin: (value)->
    value = @toValue(value)
    throw new TypeError 'the min should be a '+ @name unless @_isValid(value)
    throw new TypeError 'the min should be less than max:' + value if value > @_max
    value
  validateMax: (value)->
    value = @toValue(value)
    throw new TypeError 'the max should be a ' + @name unless @_isValid value
    throw new TypeError 'the max should be greater than min:' + value if value < @_min
    value
  _isValid: (value)-> isDate(value)
  _validate: (aValue, aOptions)->
    aValue = @toValue(aValue)
    result = @_isValid aValue
    if result
      if aOptions
        vMin = aOptions.min
        vMax = aOptions.max
        if vMin?
          result = aValue >= vMin
          if not result
            @error 'should be equal or greater than minimum value: ' + vMin
        if result and vMax?
          result = aValue <= vMax
          if not result
            @error 'should be equal or less than maximum value: ' + vMax
    result

  parse: Date.parse
  UTC: Date.UTC
  now: ->
    @createValue new Date #Date.now || new Date().getTime() # whether polyfill? if no es5-shim

  ###
    Determines if the current date instance is within a LeapYear.
    @param {Number}   The year.
    @return {Boolean} true if date is within a LeapYear, otherwise false.
  ###
  isLeapYear: (aYear)-> (aYear & 3) == 0 and (aYear % 25 != 0 || (aYear & 15) == 0)
  ###
    Gets the number of days in the month, given a year and month value. Automatically corrects for LeapYear.
    @param {Number}   The year.
    @param {Number}   The month (0-11).
    @return {Number}  The number of days in the month.
  ###
  getDaysInMonth: (aYear, aMonth)->
     [31, (if @isLeapYear(aYear) then 29 else 28), 31, 30, 31, 30, 31, 31, 30, 31, 30, 31][aMonth]
  ###
    Compares the first date to the second date and returns an number indication of their relative values.
    @param {Date}     First Date object to compare [Required].
    @param {Date}     Second Date object to compare to [Required].
    @return {Number}  -1 = value1 is lessthan value2. 0 = values are equal. 1 = value1 is greaterthan value2.
  ###
  compare: (value1, value2)->
    v1 = @toValue value1
    v2 = @toValue value2
    if isDate(v1) && isDate(v2)
      return if v1 < v2 then -1 else if (v1 > v2) then 1 else 0
    else
      throw new TypeError(value1 + " - " + value2)
  ###
    Compares the first Date object to the second Date object and returns true if they are equal.
    @param {Date}     First Date object to compare [Required]
    @param {Date}     Second Date object to compare to [Required]
    @return {Boolean} true if dates are equal. false if they are not equal.
  ###
  equals: (value1, value2)-> @compare(value1, value2) == 0
  ###
      Resets the time of the Date object to 12:00 AM (00:00), which is the start of the day.
      @param {Date}     clearing time for this date instance
      @return {Date}    this date instance
  ###
  clearTime: (aValue)->
    aValue.setHours(0)
    aValue.setMinutes(0)
    aValue.setSeconds(0)
    aValue.setMilliseconds(0)
    aValue
  ###
    Gets a date that is set to the current date. The time is set to the start of the day (00:00 or 12:00 AM).
    @return {Date}    The date value object.
  ###
  today: -> @createValue().clearTime()
  toISOString: (aValue)->
    aValue = new Date(aValue) unless isDate(aValue) or aValue instanceof DateValue
    aValue.toISOString()
