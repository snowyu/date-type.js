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
var FutureType = TypeInfo('date', min: DateType.now())

var today = DateType.create()
//var today = DateType.create(new Date()) //it's the same.
//var today = DateType.create(Date.now()) //it's the same.

var nextDay = today.clone().addDays 1

console.log(today)
//<type "Date": "value":"2016-02-28T04:13:46.352Z">
console.log(today.isValid())
//=true
console.log(today.toJson()))
//='"2016-02-28T04:13:46.352Z"'
console.log(today.toJson({withType:true})))
//='{"value":"2016-02-28T04:13:46.352Z","name":"Date"}'
console.log(PositiveInt.isValid(-1))
//=false
n.assign(-1)
//=TypeError: "-1" is an invalid Int
console.log(n.assign(2)+0)
//=2
```

## API

See [abstract-type](https://github.com/snowyu/abstract-type.js)

## TODO


## License

MIT
