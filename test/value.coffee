extend          = require 'util-ex/lib/extend'
chai            = require 'chai'
sinon           = require 'sinon'
sinonChai       = require 'sinon-chai'
should          = chai.should()
expect          = chai.expect
assert          = chai.assert
chai.use(sinonChai)

Value           = require '../src/value'
setImmediate    = setImmediate || process.nextTick

module.exports = (DateTypeInfo)->
  describe 'Value', ->
    DateType = DateTypeInfo()

    it 'should try to get DateType type', ->
      result = Value(new Date)
      expect(result).to.be.instanceOf Value

    it 'should raise error to try to get unknown type', ->
      expect(Value.bind(null, [])).to.be.throw 'can not determine the value type'

    describe '#toObject()', ->
      it 'should get value info to obj', ->
        result = DateType.createType
          'max':34
          'min':5
        result = result.createValue 12
        result = result.toObject()
        result.getTime().should.be.equal 12

      it 'should get value info to obj with type', ->
        result = DateType.create(13)
        result = result.toObject(withType:true)
        result.should.be.deep.equal
          "name":DateType.name
          value: new Date 13

    describe '.assign()', ->
      it 'should assign a value', ->
        n = DateType.create(12)
        assert.equal n.assign(13).valueOf(), 13
      it 'should assign a value object', ->
        n = DateType.create(12)
        n2 = DateType.create(112)
        assert.equal n.assign(n2).valueOf(), 112

    describe '.validate()', ->
      t = null
      before ->
        t = DateType.cloneType min: 1, max: 10

      it 'should validate a value and do not raise error', ->
        t.validate(2).should.be.equal true
        t.validate(0, false).should.be.equal false
        t.validate(11, false).should.be.equal false
      it 'should validate a value and raise error', ->
        should.throw t.validate.bind(t, 0), 'is an invalid'
        should.throw t.validate.bind(t, 11), 'is an invalid'
      it 'should validate a valid date', ->
        t.validate(new Date 5).should.be.equal true
      it 'should validate a valid date string', ->
        t.validate(new Date(5).toISOString()).should.be.equal true
        # because the Date to string ignores the micro-seconds!
        # So the new Date(5).toString()->toDate() should be 0 now!!
        t.validate(new Date(5).toString(), false).should.be.equal false

    describe '.toJson()', ->
      it 'should convert a value to json', ->
        n = DateType.create(12)
        result = n.toJson()
        assert.equal result, '"'+new Date(12).toISOString()+'"'
      it 'should convert a value to json with type', ->
        n = DateType.create(12)
        result = n.toJson(withType: true)
        assert.deepEqual JSON.parse(result), name:DateType.name, value: new Date(12).toISOString()

    describe '.createFromJson()', ->
      it 'should create value from a json string', ->
        n = DateType.create 12
        result = n.createFromJson 123
        expect(result).to.be.instanceOf Value
        expect(result.$type).to.be.equal DateType
        expect(result.valueOf()).to.be.equal 123

    describe '.fromJson()', ->
      it 'should assign value from a json string', ->
        n = DateType.create 12
        n.fromJson '"123"'
        expect(n.valueOf()).to.be.equal new Date("123").valueOf()

    describe '.toString()', ->
      it 'should convert value to string', ->
        n = DateType.create 12
        expect(String(n)).to.be.equal String(new Date 12)

    describe '.create()', ->
      it 'should create a new value object', ->
        n = DateType.create 12
        result = n.create 123
        expect(result).to.be.instanceOf Value
        expect(result.$type).to.be.equal DateType
        expect(result.valueOf()).to.be.equal 123
    describe '.clone()', ->
      it 'should clone a new value object', ->
        n = DateType.create 12
        result = n.clone()
        expect(result).to.be.instanceOf Value
        expect(result.$type).to.be.equal DateType
        expect(result.valueOf()).to.be.equal 12
        expect(result).to.be.not.equal n
    describe '.isValid()', ->
      it 'should is valid the value object', ->
        n = DateType.create 12
        expect(n.isValid()).to.be.true
    describe '.isLeapYear', ->
      it 'should check whether be a leap year', ->
        DateType.create('2012').isLeapYear().should.be.true
        DateType.create('2016').isLeapYear().should.be.true
        DateType.create('2020').isLeapYear().should.be.true
        DateType.create('2024').isLeapYear().should.be.true
        for i in [2013..2015]
          DateType.create(String i).isLeapYear().should.be.false
        for i in [2017..2019]
          DateType.create(String i).isLeapYear().should.be.false
        for i in [2021..2023]
          DateType.create(String i).isLeapYear().should.be.false
    describe '.getDaysInMonth', ->
      it 'should get the days in a specifiedd month', ->
        DateType.create('2016-1').getDaysInMonth().should.be.equal 31
        DateType.create('2016-2').getDaysInMonth().should.be.equal 29
        DateType.create('2013-2').getDaysInMonth().should.be.equal 28
    describe '.clearTime', ->
        d = DateType.create().clearTime()
        d.getHours().should.be.equal 0
        d.getMinutes().should.be.equal 0
        d.getSeconds().should.be.equal 0
        d.getMilliseconds().should.be.equal 0
    describe '.addDays', ->
      it 'should add some days to a date', ->
        d = DateType.create('2016-12-1').clearTime().addDays(12)
        d.equals(DateType.create('2016-12-13').clearTime()).should.be.true
    describe '.addWeeks', ->
      it 'should add some weeks to a date', ->
        d = DateType.create('2016-2-28').clearTime().addWeeks(1)
        d.equals(DateType.create('2016-3-6').clearTime()).should.be.true
    describe '.addMonths', ->
      it 'should add some months to a date', ->
        d = DateType.create('2016-2-28').clearTime().addMonths(1)
        d.equals(DateType.create('2016-3-28').clearTime()).should.be.true
    describe '.addYears', ->
      it 'should add some years to a date', ->
        d = DateType.create('2016-2-28').clearTime().addYears(1)
        d.equals(DateType.create('2017-2-28').clearTime()).should.be.true
    describe '.compareTo', ->
        DateType.create(2).compareTo(1).should.be.equal 1
        DateType.create(1).compareTo(2).should.be.equal -1
        DateType.create(1).compareTo(1).should.be.equal 0
