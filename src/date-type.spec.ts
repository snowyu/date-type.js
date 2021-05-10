import 'jest-extended'
// import isFunction from 'util-ex/lib/is/type/function'

import { DateType, Type } from './index'

const minDate = 1264953600000 // 2010/1/1
const lastDate = 1456611449302
const todayDate = Date.now()

describe('DateType', () => {
  const dt = new DateType()
  it('should try to get DateType type', () => {
    const v = new Type(new Date())
    expect(v).toBeInstanceOf(DateType)
  })

  describe('Static Members', () => {
    it('should be exist Date type', () => {
      expect(dt).toBeInstanceOf(DateType)
      expect(DateType.pathArray()).toEqual(['type', 'AbstractNumber', dt.name])
    })

    describe('range', () => {
      it('should not set the wrong range of Date', () => {
        expect(() => new DateType({ max: 'as' })).toThrow(
          'the max should be a ' + dt.name
        )
        expect(() => new DateType(null, { max: 'as' })).toThrow(
          'the max should be a ' + dt.name
        )

        expect(() => new DateType(null, { min: 'as' })).toThrow(
          'the min should be a ' + dt.name
        )
        expect(() => new DateType({ min: 'as' })).toThrow(
          'the min should be a ' + dt.name
        )

        expect(
          () => new DateType(null, { min: todayDate, max: lastDate })
        ).toThrow('the max should be greater than min')
        expect(() => new DateType({ min: todayDate, max: lastDate })).toThrow(
          'the max should be greater than min'
        )

        const result = dt.clone()
        result.max = lastDate
        expect(() => (result.min = todayDate)).toThrow(
          'the min should be less than max'
        )
      })
      it('should limit the range of DateType value', () => {
        const n = new DateType({ min: 2, max: 6 })
        expect(n.min.valueOf()).toEqual(2)
        expect(n.max.valueOf()).toEqual(6)
        expect(n.validate(4)).toBeTrue()
        expect(n.validate(2)).toBeTrue()
        expect(n.validate(6)).toBeTrue()
        expect(n.validate.bind(n, 1)).toThrow('an invalid ' + dt.name)
        expect(n.validate.bind(n, 7)).toThrow('an invalid ' + dt.name)
        expect(n.isValid(0)).toBeFalse()
        expect(n.isValid(7)).toBeFalse()
      })
      it('should limit max DateType value', () => {
        const n = new DateType(null, { max: 6 })
        expect(n.validate(1)).toBeTrue()
        expect(n.validate(4)).toBeTrue()
        expect(n.validate(2)).toBeTrue()
        expect(n.validate(6)).toBeTrue()
        expect(n.validate.bind(n, 7)).toThrow('an invalid ' + dt.name)
        expect(n.isValid(0)).toBeTrue()
        expect(n.isValid(7)).toBeFalse()
        expect(n.isValid(8)).toBeFalse()
      })
      it('should limit min DateType value', () => {
        const n = new DateType({ min: 2 })
        expect(n.validate(4)).toBeTrue()
        expect(n.validate(2)).toBeTrue()
        expect(n.validate(6)).toBeTrue()
        expect(n.validate(7)).toBeTrue()
        expect(n.validate.bind(n, 1)).toThrow('an invalid ' + dt.name)
        expect(n.isValid(0)).toBeFalse()
        expect(n.isValid(-1)).toBeFalse()
      })
    })

    describe('.validate', () => {
      it('should validate string DateType value', () => {
        expect(dt.validate(123)).toBeTrue()
        expect(dt.validate('2016/2/28')).toBeTrue()
        expect(dt.validate(new Date())).toBeTrue()
        expect(dt.validate.bind(dt, 'dsd')).toThrow('an invalid ' + dt.name)
      })
    })

    describe('.clone', () => {
      it('should clone type', () => {
        const t = new DateType({ min: minDate, max: Date.now() + 1000 })
        const result = t.clone()
        expect(t.isSame(result)).toBeTrue()
      })
    })
    describe('.now', () => {
      it('should return a current datetime value object', () => {
        const first = new Date()
        const t = DateType.now()
        expect(t).toBeInstanceOf(DateType)
        expect(t.valueOf()).toBeGreaterThanOrEqual(first.valueOf())
        expect(t.valueOf()).toBeLessThanOrEqual(new Date().valueOf())
      })
    })

    describe('.today', () => {
      it('should return a current today value object', () => {
        const today = new Date()
        const t = DateType.today()
        expect(t).toBeInstanceOf(DateType)
        expect(t.valueOf()).toBeLessThanOrEqual(today.valueOf())
        expect(t.getHours()).toEqual(0)
        expect(t.getMinutes()).toEqual(0)
        expect(t.getSeconds()).toEqual(0)
        expect(t.getMilliseconds()).toEqual(0)
        DateType.clearTime(today)
        expect(t.valueOf()).toStrictEqual(today.valueOf())
      })
    })
    describe('.isLeapYear', () => {
      it('should check a year whether be a leap', () => {
        expect(DateType.isLeapYear(2012)).toBeTrue()
        expect(DateType.isLeapYear(2016)).toBeTrue()
        expect(DateType.isLeapYear(2020)).toBeTrue()
        expect(DateType.isLeapYear(2024)).toBeTrue()
        expect(DateType.isLeapYear(3008)).toBeTrue()
        for (const i of [2013, 2014, 2015]) {
          expect(DateType.isLeapYear(i)).toBeFalse()
        }
        for (const i of [2017, 2018, 2019]) {
          expect(DateType.isLeapYear(i)).toBeFalse()
        }
        for (const i of [2021, 2022, 2023]) {
          expect(DateType.isLeapYear(i)).toBeFalse()
        }
      })
    })
    describe('.getDaysInMonth', () => {
      it('should get the days in a specified month', () => {
        expect(DateType.getDaysInMonth(2016, 0)).toEqual(31)
        expect(DateType.getDaysInMonth(2016, 1)).toEqual(29)
      })
    })
    describe('.equals', () => {
      it('should Compares the two Date whether be equal.', () => {
        // expect(DateType.equals(2, 1)).toBeFalse()
        // expect(DateType.equals(1, 1)).toBeTrue()
        expect(DateType.equals(new DateType(1), 1)).toBeTrue()
        // expect(DateType.equals(new DateType(1), new DateType(1))).toBeTrue()
        // expect(DateType.equals.bind(DateType, 'abc', 's')).toThrow('abc - s')
      })
    })
    describe('.compare', () => {
      it('should Compares the two Date.', () => {
        expect(DateType.compare(2, 1)).toEqual(1)
        expect(DateType.compare(1, 1)).toEqual(0)
        expect(DateType.compare(new DateType(1), 2)).toEqual(-1)
        expect(DateType.compare(new DateType(2), new DateType(1))).toEqual(1)
        expect(DateType.compare.bind(DateType, 'abc', 's')).toThrow('abc - s')
      })
    })
    describe('.toISOString', () => {
      it('should toISOString', () => {
        const dt = new Date()
        expect(DateType.toISOString(dt)).toStrictEqual(dt.toISOString())
        expect(DateType.toISOString(new DateType(dt))).toStrictEqual(
          dt.toISOString()
        )
        expect(DateType.toISOString('2020-10-10')).toStrictEqual(
          '2020-10-10T00:00:00.000Z'
        )
      })
    })
    describe('.toValue', () => {
      it('should convert value to Date', () => {
        const now = Date.now()
        const dt = DateType.toValue(DateType.now())
        expect(dt).toBeNumber()
        expect(dt.valueOf()).toBeWithin(now, now + 10)
      })
    })
  })

  describe('Instance Members', () => {
    describe('clone', () => {
      it('should clone value', () => {
        const t = DateType.now()
        const result = t.clone()
        expect(t.isSame(result)).toBeTrue()
      })
    })

    describe('validate()', () => {
      const t = new DateType({ min: 1, max: 10 })
      it('should validate a value and do not raise error', () => {
        expect(t.validate(2)).toBeTrue()
        expect(t.validate(0, false)).toBeFalse()
        expect(t.validate(11, false)).toBeFalse()
      })
      it('should validate a value and raise error', () => {
        expect(t.validate.bind(t, 0)).toThrow('is an invalid')
        expect(t.validate.bind(t, 11)).toThrow('is an invalid')
      })
      it('should validate a valid date', () => {
        expect(t.validate(new Date(5))).toBeTrue()
      })
      it('should validate a valid date string', () => {
        expect(t.validate(new Date(5).toISOString())).toBeTrue()
        // # because the Date to string ignores the micro-seconds!
        // # So the new Date(5).toString()->toDate() should be 0 now!!
        expect(t.validate(new Date(5).toString(), false)).toBeFalse()
      })

      it('should validate another DateType', () => {
        const today = DateType.today()
        const nextDay = today.clone().addDays(1)
        const lastDay = today.clone().addDays(-1)
        const FutureType = new Type(null, { name: 'date', min: nextDay })
        expect(FutureType.isValid(lastDay)).toBeFalse()
      })
    })
    describe('isLeapYear', () => {
      it('should check whether be a leap year', () => {
        expect(new DateType('2012').isLeapYear()).toBeTrue()
        expect(new DateType('2016').isLeapYear()).toBeTrue()
        expect(new DateType('2020').isLeapYear()).toBeTrue()
        expect(new DateType('2024').isLeapYear()).toBeTrue()

        for (const i of [2013, 2014, 2015]) {
          expect(new DateType(String(i)).isLeapYear()).toBeFalse()
        }

        for (const i of [2017, 2018, 2019]) {
          expect(new DateType(String(i)).isLeapYear()).toBeFalse()
        }

        for (const i of [2021, 2022, 2023]) {
          expect(new DateType(String(i)).isLeapYear()).toBeFalse()
        }
      })
    })

    describe('getDaysInMonth', () => {
      it('should get the days in a specified month', () => {
        expect(new DateType('2016-1').getDaysInMonth()).toEqual(31)
        expect(new DateType('2016-2').getDaysInMonth()).toEqual(29)
        expect(new DateType('2013-2').getDaysInMonth()).toEqual(28)
      })
    })

    describe('clearTime', () => {
      it('should get the days in a specified month', () => {
        const d = new DateType(new Date()).clearTime()
        expect(d.getHours()).toEqual(0)
        expect(d.getMinutes()).toEqual(0)
        expect(d.getSeconds()).toEqual(0)
        expect(d.getMilliseconds()).toEqual(0)
      })
    })

    describe('addDays', () => {
      it('should add some days to a date', () => {
        const d = new DateType('2016-12-1').clearTime().addDays(12)
        expect(d.equals(new DateType('2016-12-13').clearTime())).toBeTrue()
      })
    })
    describe('addWeeks', () => {
      it('should add some weeks to a date', () => {
        const d = new DateType('2016-2-28').clearTime().addWeeks(1)
        expect(d.equals(new DateType('2016-3-6').clearTime())).toBeTrue()
      })
    })
    describe('addMonths', () => {
      it('should add some months to a date', () => {
        const d = new DateType('2016-2-28').clearTime().addMonths(1)
        expect(d.equals(new DateType('2016-3-28').clearTime())).toBeTrue()
      })
    })
    describe('addYears', () => {
      it('should add some years to a date', () => {
        const d = new DateType('2016-2-28').clearTime().addYears(1)
        expect(d.equals(new DateType('2017-2-28').clearTime())).toBeTrue()
      })
    })
    describe('compareTo', () => {
      it('should compareTo', () => {
        expect(new DateType(2).compareTo(1)).toEqual(1)
        expect(new DateType(1).compareTo(2)).toEqual(-1)
        expect(new DateType(1).compareTo(1)).toEqual(0)
      })
    })

    describe('toObject', () => {
      it('should json a date type', () => {
        const dt = DateType.now()
        expect(JSON.stringify(dt)).toStrictEqual('"' + dt.toISOString() + '"')
      })
    })
    describe('toString', () => {
      it('should cast date type to string', () => {
        const dt = DateType.now()
        expect(String(dt)).toStrictEqual(dt.toISOString())
      })
    })
  })
})
