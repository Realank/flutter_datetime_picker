import 'i18n_model.dart';

/// Outputs year as four digits
///
/// Example:
///     formatDate(new DateTime(2018,8,31), [ymdw]);
///     // => Today
const String ymdw = 'ymdw';

///
/// Example:
///     formatDate(new DateTime(1989), [yyyy]);
///     // => 1989
const String yyyy = 'yyyy';

/// Outputs year as two digits
///
/// Example:
///     formatDate(new DateTime(1989), [yy]);
///     // => 89
const String yy = 'yy';

/// Outputs month as two digits
///
/// Example:
///     formatDate(new DateTime(1989, 11), [mm]);
///     // => 11
///     formatDate(new DateTime(1989, 5), [mm]);
///     // => 05
const String mm = 'mm';

/// Outputs month compactly
///
/// Example:
///     formatDate(new DateTime(1989, 11), [mm]);
///     // => 11
///     formatDate(new DateTime(1989, 5), [m]);
///     // => 5
const String m = 'm';

/// Outputs month as long name
///
/// Example:
///     formatDate(new DateTime(1989, 2), [MM]);
///     // => february
const String MM = 'MM';

/// Outputs month as short name
///
/// Example:
///     formatDate(new DateTime(1989, 2), [M]);
///     // => feb
const String M = 'M';

/// Outputs day as two digits
///
/// Example:
///     formatDate(new DateTime(1989, 2, 21), [dd]);
///     // => 21
///     formatDate(new DateTime(1989, 2, 5), [dd]);
///     // => 05
const String dd = 'dd';

/// Outputs day compactly
///
/// Example:
///     formatDate(new DateTime(1989, 2, 21), [d]);
///     // => 21
///     formatDate(new DateTime(1989, 2, 5), [d]);
///     // => 5
const String d = 'd';

/// Outputs week in month
///
/// Example:
///     formatDate(new DateTime(1989, 2, 21), [w]);
///     // => 4
const String w = 'w';

/// Outputs week in year as two digits
///
/// Example:
///     formatDate(new DateTime(1989, 12, 31), [W]);
///     // => 53
///     formatDate(new DateTime(1989, 2, 21), [W]);
///     // => 08
const String WW = 'WW';

/// Outputs week in year compactly
///
/// Example:
///     formatDate(new DateTime(1989, 2, 21), [W]);
///     // => 8
const String W = 'W';

/// Outputs week day as long name
///
/// Example:
///     formatDate(new DateTime(2018, 1, 14), [D]);
///     // => sun
const String D = 'D';

/// Outputs hour (0 - 11) as two digits
///
/// Example:
///     formatDate(new DateTime(1989, 02, 1, 15), [hh]);
///     // => 03
const String hh = 'hh';

/// Outputs hour (0 - 11) compactly
///
/// Example:
///     formatDate(new DateTime(1989, 02, 1, 15), [h]);
///     // => 3
const String h = 'h';

/// Outputs hour (0 to 23) as two digits
///
/// Example:
///     formatDate(new DateTime(1989, 02, 1, 15), [HH]);
///     // => 15
const String HH = 'HH';

/// Outputs hour (0 to 23) compactly
///
/// Example:
///     formatDate(new DateTime(1989, 02, 1, 5), [H]);
///     // => 5
const String H = 'H';

/// Outputs minute as two digits
///
/// Example:
///     formatDate(new DateTime(1989, 02, 1, 15, 40), [nn]);
///     // => 40
///     formatDate(new DateTime(1989, 02, 1, 15, 4), [nn]);
///     // => 04
const String nn = 'nn';

/// Outputs minute compactly
///
/// Example:
///     formatDate(new DateTime(1989, 02, 1, 15, 4), [n]);
///     // => 4
const String n = 'n';

/// Outputs second as two digits
///
/// Example:
///     formatDate(new DateTime(1989, 02, 1, 15, 40, 10), [ss]);
///     // => 10
///     formatDate(new DateTime(1989, 02, 1, 15, 40, 5), [ss]);
///     // => 05
const String ss = 'ss';

/// Outputs second compactly
///
/// Example:
///     formatDate(new DateTime(1989, 02, 1, 15, 40, 5), [s]);
///     // => 5
const String s = 's';

/// Outputs millisecond as three digits
///
/// Example:
///     formatDate(new DateTime(1989, 02, 1, 15, 40, 10, 999), [SSS]);
///     // => 999
///     formatDate(new DateTime(1989, 02, 1, 15, 40, 10, 99), [SS]);
///     // => 099
///     formatDate(new DateTime(1989, 02, 1, 15, 40, 10, 0), [SS]);
///     // => 009
const String SSS = 'SSS';

/// Outputs millisecond compactly
///
/// Example:
///     formatDate(new DateTime(1989, 02, 1, 15, 40, 10, 999), [SSS]);
///     // => 999
///     formatDate(new DateTime(1989, 02, 1, 15, 40, 10, 99), [SS]);
///     // => 99
///     formatDate(new DateTime(1989, 02, 1, 15, 40, 10, 9), [SS]);
///     // => 9
const String S = 'S';

/// Outputs microsecond as three digits
///
/// Example:
///     formatDate(new DateTime(1989, 02, 1, 15, 40, 10, 0, 999), [uuu]);
///     // => 999
///     formatDate(new DateTime(1989, 02, 1, 15, 40, 10, 0, 99), [uuu]);
///     // => 099
///     formatDate(new DateTime(1989, 02, 1, 15, 40, 10, 0, 9), [uuu]);
///     // => 009
const String uuu = 'uuu';

/// Outputs millisecond compactly
///
/// Example:
///     formatDate(new DateTime(1989, 02, 1, 15, 40, 10, 0, 999), [u]);
///     // => 999
///     formatDate(new DateTime(1989, 02, 1, 15, 40, 10, 0, 99), [u]);
///     // => 99
///     formatDate(new DateTime(1989, 02, 1, 15, 40, 10, 0, 9), [u]);
///     // => 9
const String u = 'u';

/// Outputs if hour is AM or PM
///
/// Example:
///     print(formatDate(new DateTime(1989, 02, 1, 5), [am]));
///     // => AM
///     print(formatDate(new DateTime(1989, 02, 1, 15), [am]));
///     // => PM
const String am = 'am';

/// Outputs timezone as time offset
///
/// Example:
///
const String z = 'z';
const String Z = 'Z';

String formatDate(DateTime date, List<String> formats, LocaleType locale) {
  if (formats.first == ymdw) {
    final now = DateTime.now();
    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      //today
      return i18nObjInLocale(locale)['today'];
    } else if (date.year == now.year) {
      if (locale == LocaleType.zh) {
        return formatDate(date, [mm, '月', dd, '日 ', D], locale);
      } else if (locale == LocaleType.nl) {
        return formatDate(date, [D, ' ', dd, ' ', M], locale);
      } else if (locale == LocaleType.ko) {
        return formatDate(date, [mm, '월', dd, '일 ', D], locale);
      } else if (locale == LocaleType.de) {
        return formatDate(date, [D, ', ', dd, '. ', M], locale);
      } else if (locale == LocaleType.id) {
        return formatDate(date, [D, ', ', dd, ' ', M], locale);
      } else if (locale == LocaleType.jp) {
        return formatDate(date, [mm, '月', dd, '日', D], locale);
      } else if (locale == LocaleType.si) {
        return formatDate(date, [D, ', ', dd, '. ', M, '.'], locale);
      } else if (locale == LocaleType.gr) {
        return formatDate(date, [D, ' ', dd, ' ', M], locale);
      } else {
        return formatDate(date, [D, ' ', M, ' ', dd], locale);
      }
    } else {
      if (locale == LocaleType.zh) {
        return formatDate(date, [yyyy, '年', mm, '月', dd, '日 ', D], locale);
      } else if (locale == LocaleType.nl) {
        return formatDate(date, [D, ' ', dd, ' ', M, ' ', yyyy], locale);
      } else if (locale == LocaleType.ko) {
        return formatDate(date, [yyyy, '년', mm, '월', dd, '일 ', D], locale);
      } else if (locale == LocaleType.de) {
        return formatDate(date, [D, ', ', dd, '. ', M, ' ', yyyy], locale);
      } else if (locale == LocaleType.id) {
        return formatDate(date, [D, ', ', dd, ' ', M, ' ', yyyy], locale);
      } else if (locale == LocaleType.jp) {
        return formatDate(date, [yyyy, '年', mm, '月', dd, '日', D], locale);
      } else if (locale == LocaleType.si) {
        return formatDate(date, [D, ', ', dd, '. ', M, '. ', yyyy], locale);
      } else if (locale == LocaleType.gr) {
        return formatDate(date, [D, ' ', dd, ' ', M, ' ', yyyy], locale);
      } else {
        return formatDate(date, [D, ' ', M, ' ', dd, ', ', yyyy], locale);
      }
    }
  }

  final sb = new StringBuffer();

  for (String format in formats) {
    if (format == yyyy) {
      sb.write(digits(date.year, 4));
    } else if (format == yy) {
      sb.write(digits(date.year % 100, 2));
    } else if (format == mm) {
      sb.write(digits(date.month, 2));
    } else if (format == m) {
      sb.write(date.month);
    } else if (format == MM) {
      final monthLong =
          i18nObjInLocaleLookup(locale, 'monthLong', date.month - 1);
      sb.write(monthLong);
    } else if (format == M) {
      final monthShort =
          i18nObjInLocaleLookup(locale, 'monthShort', date.month - 1);
      sb.write(monthShort);
    } else if (format == dd) {
      sb.write(digits(date.day, 2));
    } else if (format == d) {
      sb.write(date.day);
    } else if (format == w) {
      sb.write((date.day + 7) ~/ 7);
    } else if (format == W) {
      sb.write((dayInYear(date) + 7) ~/ 7);
    } else if (format == WW) {
      sb.write(digits((dayInYear(date) + 7) ~/ 7, 2));
    } else if (format == D) {
      String day = i18nObjInLocaleLookup(locale, 'day', date.weekday - 1);
      if (locale == LocaleType.ko) {
        day = "($day)";
      }
      sb.write(day);
    } else if (format == HH) {
      sb.write(digits(date.hour, 2));
    } else if (format == H) {
      sb.write(date.hour);
    } else if (format == hh) {
      sb.write(digits(date.hour % 12, 2));
    } else if (format == h) {
      sb.write(date.hour % 12);
    } else if (format == am) {
      sb.write(date.hour < 12
          ? i18nObjInLocale(locale)['am']
          : i18nObjInLocale(locale)['pm']);
    } else if (format == nn) {
      sb.write(digits(date.minute, 2));
    } else if (format == n) {
      sb.write(date.minute);
    } else if (format == ss) {
      sb.write(digits(date.second, 2));
    } else if (format == s) {
      sb.write(date.second);
    } else if (format == SSS) {
      sb.write(digits(date.millisecond, 3));
    } else if (format == S) {
      sb.write(date.second);
    } else if (format == uuu) {
      sb.write(digits(date.microsecond, 2));
    } else if (format == u) {
      sb.write(date.microsecond);
    } else if (format == z) {
      if (date.timeZoneOffset.inMinutes == 0) {
        sb.write('Z');
      } else {
        if (date.timeZoneOffset.isNegative) {
          sb.write('-');
          sb.write(digits((-date.timeZoneOffset.inHours) % 24, 2));
          sb.write(digits((-date.timeZoneOffset.inMinutes) % 60, 2));
        } else {
          sb.write('+');
          sb.write(digits(date.timeZoneOffset.inHours % 24, 2));
          sb.write(digits(date.timeZoneOffset.inMinutes % 60, 2));
        }
      }
    } else if (format == Z) {
      sb.write(date.timeZoneName);
    } else {
      sb.write(format);
    }
  }

  return sb.toString();
}

String digits(int value, int length) {
  return '$value'.padLeft(length, "0");
}

int dayInYear(DateTime date) =>
    date.difference(new DateTime(date.year, 1, 1)).inDays;
