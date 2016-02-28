chai            = require 'chai'
sinon           = require 'sinon'
sinonChai       = require 'sinon-chai'
should          = chai.should()
expect          = chai.expect
assert          = chai.assert
chai.use(sinonChai)

setImmediate    = setImmediate || process.nextTick

DateType        = require '../src'
DateTest        = require './date'

DateTest DateType, ->
  it 'should have aliases', ->
    expect(DateType('date')).to.be.instanceOf DateType
    expect(DateType('Time')).to.be.instanceOf DateType
    expect(DateType('time')).to.be.instanceOf DateType
    expect(DateType('DateTime')).to.be.instanceOf DateType
    expect(DateType('datetime')).to.be.instanceOf DateType
