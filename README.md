## date-type [![npm][npm-svg]][npm]

[![Build Status][travis-svg]][travis]
[![Code Climate][codeclimate-svg]][codeclimate]
[![Test Coverage][codeclimate-test-svg]][codeclimate-test]
[![downloads][npm-download-svg]][npm]
[![license][npm-license-svg]][npm]

[npm]: https://npmjs.org/package/date-type
[npm-svg]: https://img.shields.io/npm/v/date-type.svg
[npm-download-svg]: https://img.shields.io/npm/dm/date-type.svg
[npm-license-svg]: https://img.shields.io/npm/l/date-type.svg
[travis-svg]: https://img.shields.io/travis/snowyu/date-type.js/master.svg
[travis]: http://travis-ci.org/snowyu/date-type.js
[codeclimate-svg]: https://codeclimate.com/github/snowyu/date-type.js/badges/gpa.svg
[codeclimate]: https://codeclimate.com/github/snowyu/date-type.js
[codeclimate-test-svg]: https://codeclimate.com/github/snowyu/date-type.js/badges/coverage.svg
[codeclimate-test]: https://codeclimate.com/github/snowyu/date-type.js/coverage


The date type.

## Usage

```js
//register the date type to the TypeInfo..
require('date-type')
var TypeInfo = require('abstract-type')
//get the date type info:
var DateType = TypeInfo('date')
/*
//Just load date type only:
var DateTypeInfo = require('date-type')
var DateType = DateTypeInfo('date')
 */

var today = DateType.today()
//var today = DateType.create(new Date()).clearTime() //it's the same.
//var today = DateType.create(Date.now()).clearTime() //it's the same.

var nextDay = today.clone().addDays 1
var FutureType = TypeInfo('date', min: nextDay)

console.log(today)
//<type "Date": "value":"2016-02-28T04:13:46.352Z">
console.log(today.isValid())
//=true
console.log(today.toJson()))
//='"2016-02-28T04:13:46.352Z"'
console.log(today.toJson({withType:true})))
//='{"value":"2016-02-28T04:13:46.352Z","name":"Date"}'
console.log(FutureType.isValid(nextDay))
//=true
console.log(FutureType.isValid(today))
//=true
var n = nextDay.clone();
n.assign('aaa')
//=TypeError: "aaa" is an invalid Date
console.log(nextDay > today)
//=true
```

## API

* The DateType Class
  * Methods:
    * `now()`: Gets a date type object that is set to the current date time.
    * `today()`: Gets a date type object that is set to the current date.
      * The time is set to the start of the day (00:00 or 12:00 AM).
    * `clearTime(date)`: Resets the time of the Date object to 12:00 AM (00:00), which is the start of the day.
    * `isLeapYear(aYear)`: Determines if the year whether a LeapYear.
    * `getDaysInMonth(aYear, aMonth)`: Gets the number of days in the month, given a year and month value. Automatically corrects for LeapYear.
* The DateType Value Class
  * Methods:
    * `addYears(value)`: Adds the specified number of years to this instance.
    * `addMonths(value)`: Adds the specified number of months to this instance.
    * `addWeeks(value)`: Adds the specified number of weeks to this instance.
    * `addDays(value)`: Adds the specified number of days to this instance.
    * `clearTime()`: Resets the time of this instance to 12:00 AM (00:00), which is the start of the day.
    * `isLeapYear()`: Determines this date whether a LeapYear.
    * `getDaysInMonth()`: Gets the number of days in the month. Automatically corrects for LeapYear.
    * `equals(value)`: Compares this instance to another Date object and returns true if they are equal.
    * `compareTo(value)`: Compares this instance to a Date object and returns an number indication of their relative values.
      * `return`: -1 = this is lessthan date. 0 = values are equal. 1 = this is greaterthan date.

See [abstract-type](https://github.com/snowyu/abstract-type.js)

## TODO


## License

MIT
