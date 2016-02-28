chai            = require 'chai'
sinon           = require 'sinon'
sinonChai       = require 'sinon-chai'
should          = chai.should()
expect          = chai.expect
assert          = chai.assert
chai.use(sinonChai)

setImmediate    = setImmediate || process.nextTick
isFunction      = require 'util-ex/lib/is/type/function'
valueTest       = require './value'
minDate = 1264953600000 # 2010/1/1
lastDate = 1456611449302
todayDate = Date.now()

module.exports = (DateTypeInfo, Tests)->
  DateType = DateTypeInfo()
  describe DateType.name, ->
    it 'should be exist Date type', ->
      expect(DateType).to.be.instanceOf DateTypeInfo
      DateType.pathArray().should.be.deep.equal ['type', DateType.name]

    describe 'range', ->
      it 'should not set the wrong range of Date', ->
        expect(DateType.createType.bind(DateType, max:'as')).to.be.throw 'the max should be a '+ DateType.name
        expect(DateType.createType.bind(DateType, min:'as')).to.be.throw 'the min should be a '+ DateType.name
        expect(DateType.createType.bind(DateType, min:todayDate, max:lastDate)).to.be.throw 'the max should be greater than min'
        result = DateType.clone()
        try
          result.max = lastDate
          result.min = todayDate
        catch e
          err = e
        expect(err).to.be.exist
        expect(err.message).to.be.include 'the min should be less than max'
      it 'should limit the range of DateType value', ->
        n = DateType.createType(min: 2, max:6)
        expect(n.min.valueOf()).to.be.equal 2
        expect(n.max.valueOf()).to.be.equal 6
        expect(n.validate(4)).to.be.true
        expect(n.validate(2)).to.be.true
        expect(n.validate(6)).to.be.true
        expect(n.validate.bind(n,1)).to.be.throw 'an invalid ' + DateType.name
        expect(n.validate.bind(n,7)).to.be.throw 'an invalid ' + DateType.name
        expect(n.isValid(0)).to.be.false
        expect(n.isValid(7)).to.be.false
      it 'should limit max DateType value', ->
        n = DateType.createType(max:6)
        expect(n.validate(1)).to.be.true
        expect(n.validate(4)).to.be.true
        expect(n.validate(2)).to.be.true
        expect(n.validate(6)).to.be.true
        expect(n.validate.bind(n,7)).to.be.throw 'an invalid ' + DateType.name
        expect(n.isValid(0)).to.be.true
        expect(n.isValid(7)).to.be.false
        expect(n.isValid(8)).to.be.false
      it 'should limit min DateType value', ->
        n = DateType.createType(min: 2)
        expect(n.validate(4)).to.be.true
        expect(n.validate(2)).to.be.true
        expect(n.validate(6)).to.be.true
        expect(n.validate(7)).to.be.true
        expect(n.validate.bind(n,1)).to.be.throw 'an invalid ' + DateType.name
        expect(n.isValid(0)).to.be.false
        expect(n.isValid(-1)).to.be.false

    describe '.validate', ->
      it 'should validate string DateType value', ->
        expect(DateType.validate(123)).to.be.true
        expect(DateType.validate('2016/2/28')).to.be.true
        expect(DateType.validate(new Date)).to.be.true
        expect(DateType.validate.bind(DateType,"dsd")).to.be.throw 'an invalid ' + DateType.name

    describe '.cloneType', ->
      it 'should clone type', ->
        t = DateType.createType(min:1, max:3)
        result = t.cloneType()
        expect(t.isSame result).to.be.true
    describe '.now', ->
      it 'should return a current datetime value object', ->
        first = new Date()
        t = DateType.now()
        expect(t).to.be.instanceOf DateType.ValueType
        expect(t).to.be.at.least first.valueOf()
        expect(t).to.be.at.most new Date().valueOf()

    describe '.today', ->
      it 'should return a current today value object', ->
        first = new Date()
        t = DateType.today()
        expect(t).to.be.instanceOf DateType.ValueType
        expect(t).to.be.at.most new Date().valueOf()
        expect(t.getHours()).to.be.equal 0
        expect(t.getMinutes()).to.be.equal 0
        expect(t.getSeconds()).to.be.equal 0
        expect(t.getMilliseconds()).to.be.equal 0
    describe '.isLeapYear', ->
      it 'should check a year whether be a leap', ->
        DateType.isLeapYear(2012).should.be.true
        DateType.isLeapYear(2016).should.be.true
        DateType.isLeapYear(2020).should.be.true
        DateType.isLeapYear(2024).should.be.true
        for i in [2013..2015]
          DateType.isLeapYear(i).should.be.false
        for i in [2017..2019]
          DateType.isLeapYear(i).should.be.false
        for i in [2021..2023]
          DateType.isLeapYear(i).should.be.false
    describe '.getDaysInMonth', ->
      it 'should get the days in a specifiedd month', ->
        DateType.getDaysInMonth(2016,0).should.be.equal 31
        DateType.getDaysInMonth(2016,1).should.be.equal 29
    describe '.equals', ->
      it 'should Compares the two Date whether be equal.', ->
        DateType.equals(2,1).should.be.false
        DateType.equals(1,1).should.be.true
        DateType.equals(DateType.create(1), 1).should.be.true
        DateType.equals(DateType.create(1), DateType.create(1)).should.be.true
        expect(DateType.equals.bind(DateType, 'abc', 's')).to.be.throw 'abc - s'
    describe '.compare', ->
      it 'should Compares the two Date.', ->
        DateType.compare(2,1).should.be.equal 1
        DateType.compare(1,1).should.be.equal 0
        DateType.compare(DateType.create(1), 2).should.be.equal -1
        DateType.compare(DateType.create(2), DateType.create(1)).should.be.equal 1
        expect(DateType.compare.bind(DateType, 'abc', 's')).to.be.throw 'abc - s'

    Tests(DateTypeInfo) if isFunction Tests
    valueTest(DateTypeInfo)
