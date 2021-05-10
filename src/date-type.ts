/* eslint-disable no-unused-vars */
import isDate from 'util-ex/lib/is/type/date'

import {
  AbstractNumberType,
  // register,
  // defineProperties,
  ITypeObjectOptions,
} from 'number-type'

export class DateType extends AbstractNumberType {
  declare toDateString: () => string
  declare toTimeString: () => string
  declare toISOString: () => string
  declare toUTCString: () => string
  declare toGMTString: () => string
  declare getDate: Function
  declare setDate: Function
  declare getDay: Function
  declare getFullYear: Function
  declare setFullYear: Function
  declare getHours: Function
  declare setHours: Function
  declare getMilliseconds: Function
  declare setMilliseconds: Function
  declare getMinutes: Function
  declare setMinutes: Function
  declare getMonth: Function
  declare setMonth: Function
  declare getSeconds: Function
  declare setSeconds: Function
  declare getTime: Function
  declare setTime: Function
  declare getTimezoneOffset: Function
  declare getUTCDate: Function
  declare setUTCDate: Function
  declare getUTCDay: Function
  declare getUTCFullYear: Function
  declare setUTCFullYear: Function
  declare getUTCHours: Function
  declare setUTCHours: Function
  declare getUTCMilliseconds: Function
  declare setUTCMilliseconds: Function
  declare getUTCMinutes: Function
  declare setUTCMinutes: Function
  declare getUTCMonth: Function
  declare setUTCMonth: Function
  declare getUTCSeconds: Function
  declare setUTCSeconds: Function
  declare getYear: Function
  declare setYear: Function
  declare toLocaleString: () => string
  declare toLocaleDateString: () => string
  declare toLocaleTimeString: () => string
  declare clone: (options?: ITypeObjectOptions) => DateType

  declare static min: number | undefined
  declare static max: number | undefined
  declare min: number | undefined
  declare max: number | undefined
  // declare _min: number | undefined
  // declare _max: number | undefined

  static toValue(aValue): number | undefined {
    let result: number | undefined =
      typeof aValue !== 'number' ? new Date(aValue).valueOf() : aValue

    if (isNaN(result)) result = undefined

    return result
  }

  /**
   * Determines if the current date instance is within a LeapYear.
   * @param aYear The year.
   * @returns true if date is within a LeapYear, otherwise false.
   */
  static isLeapYear(aYear: number): boolean {
    return (aYear & 3) === 0 && (aYear % 25 !== 0 || (aYear & 15) === 0)
  }

  /**
   * Gets the number of days in the month, given a year and month value. Automatically corrects for LeapYear.
   * @param aYear  The year.
   * @param aMonth The month (0-11).
   * @returns The number of days in the month.
   */
  static getDaysInMonth(aYear: number, aMonth: number): number {
    return [
      31,
      this.isLeapYear(aYear) ? 29 : 28,
      31,
      30,
      31,
      30,
      31,
      31,
      30,
      31,
      30,
      31,
    ][aMonth]
  }

  /**
   * Compares the first date to the second date and returns an number indication of their relative values.
   * @param value1 First Date object to compare [Required].
   * @param value2 Second Date object to compare to [Required].
   * @returns -1 = value1 is less than value2. 0 = values are equal. 1 = value1 is greater than value2.
   */
  static compare(value1: Date | string, value2: Date | string): -1 | 0 | 1 {
    const v1 = new Date(this.toValue(value1) as number)
    const v2 = new Date(this.toValue(value2) as number)
    if (!isNaN(v1.valueOf()) && !isNaN(v2.valueOf())) {
      return v1 < v2 ? -1 : v1 > v2 ? 1 : 0
    } else {
      throw new TypeError(value1 + ' - ' + value2)
    }
  }

  /**
   * Compares the first Date object to the second Date object and returns true if they are equal.
   * @param value1 First Date object to compare [Required].
   * @param value2 Second Date object to compare to [Required].
   * @returns true if dates are equal. false if they are not equal.
   */
  static equals(value1, value2): boolean {
    return this.compare(value1, value2) === 0
  }

  /**
   * Resets the time of the Date object to 12:00 AM (00:00), which is the start of the day.
   * @param aValue clearing time for this date instance
   * @returns the aValue date instance
   */
  static clearTime(aValue: Date | DateType) {
    aValue.setHours(0)
    aValue.setMinutes(0)
    aValue.setSeconds(0)
    aValue.setMilliseconds(0)
    return aValue
  }

  static today(aOptions?: ITypeObjectOptions) {
    const result = this.now(aOptions)
    this.clearTime(result)
    return result
  }

  static toISOString(aValue) {
    /* istanbul ignore else */
    if (!isDate(aValue) || !(aValue instanceof DateType)) {
      aValue = new Date(aValue)
    }
    return aValue.toISOString()
  }

  static now(aOptions?: ITypeObjectOptions): DateType {
    return new DateType(new Date(), aOptions)
  }

  static parse = Date.parse
  static UTC = Date.UTC

  // _initialize(aValue?, aOptions: ITypeObjectOptions) {
  //   if (
  //     (aValue == null || aValue.value == null) &&
  //     aOptions.value === undefined
  //   ) {
  //     aOptions.value = new Date()
  //   }
  // }

  _toObject() {
    return this.toISOString()
  }

  toString() {
    return this.toISOString()
  }

  isLeapYear() {
    return DateType.isLeapYear(this.getFullYear())
  }

  getDaysInMonth() {
    return DateType.getDaysInMonth(this.getFullYear(), this.getMonth())
  }

  /**
   * Resets the time of this Date object to 12:00 AM (00:00), which is the start of the day.
   * @returns this date instance
   */
  clearTime() {
    return DateType.clearTime(this)
  }

  /**
   * Adds the specified number of days to this instance.
   * @param value The number of days to add. The number can be positive or negative [Required]
   * @returns this
   */
  addDays(value: number) {
    this.setDate(this.getDate() + value * 1)
    return this
  }

  /**
   * Adds the specified number of weeks to this instance.
   * @param value The number of weeks to add. The number can be positive or negative [Required]
   * @returns this
   */
  addWeeks(value: number) {
    return this.addDays(value * 7)
  }

  /**
   * Adds the specified number of months to this instance.
   * @param value The number of months to add. The number can be positive or negative [Required]
   * @returns this
   */
  addMonths(value) {
    const n = this.getDate()
    this.setDate(1)
    this.setMonth(this.getMonth() + value)
    this.setDate(Math.min(n, this.getDaysInMonth()))
    return this
  }

  /**
   * Adds the specified number of years to this instance.
   * @param value The number of years to add. The number can be positive or negative [Required]
   * @returns this
   */
  addYears(value) {
    return this.addMonths(value * 12)
  }

  /**
   * Compares this instance to another Date object and returns true if they are equal.
   * @param value Date object to compare. If no date to compare, new Date() [now] is used.
   * @returns true if dates are equal. false if they are not equal.
   */
  equals(value) {
    return DateType.equals(this.value, value)
  }

  /**
   * Compares this instance to a Date object and returns an number indication of their relative values.
   * @param value Date object to compare [Required]
   * @returns -1 = this is less than date. 0 = values are equal. 1 = this is greater than date.
   */
  compareTo(value) {
    return DateType.compare(this.value, value)
  }
}

const vDateMethodNames = Object.getOwnPropertyNames(Date.prototype).filter(
  (name) =>
    ['constructor', 'valueOf', 'toJSON', 'toString'].indexOf(name) === -1
)

vDateMethodNames.forEach((name) => {
  DateType.prototype[name] = (function (aName) {
    return function () {
      /* istanbul ignore else */
      if (this.value != null) {
        const v = new Date(this.value)
        const result = Date.prototype[aName].apply(v, arguments)
        if (aName.slice(0, 3) === 'set') {
          this.value = v.valueOf()
        }
        return result
      }
    }
  })(name)
})

AbstractNumberType.register(DateType, {
  aliases: ['date', 'time', 'Time', 'DateTime', 'datetime'],
})
