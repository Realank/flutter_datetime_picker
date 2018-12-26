enum LocaleType {
  zh,
  nl,
  en,
}
final _i18nModel = {
  'en': {
    //default
    'cancel': 'Cancel',
    'done': 'Done',
    'today': 'Today',
    'monthShort': [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ],
    'monthLong': [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ],
    'day': ['Mon', 'Tue', 'Wed', 'Thur', 'Fri', 'Sat', 'Sun'],
    'am': 'AM',
    'pm': 'PM'
  },
  'zh': {
    //Chinese
    'cancel': '取消',
    'done': '确定',
    'today': '今天',
    'monthShort': ['一月', '二月', '三月', '四月', '五月', '六月', '七月', '八月', '九月', '十月', '十一月', '十二月'],
    'monthLong': ['一月', '二月', '三月', '四月', '五月', '六月', '七月', '八月', '九月', '十月', '十一月', '十二月'],
    'day': ['星期一', '星期二', '星期三', '星期四', '星期五', '星期六', '星期日'],
    'am': '上午',
    'pm': '下午'
  },
  'nl': {
    //Dutch
    'cancel': 'Annuleer',
    'done': 'Klaar',
    'today': 'Vandaag',
    'monthShort': [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Okt',
      'Nov',
      'Dec',
    ],
    'monthLong': [
      'Januari',
      'Februari',
      'Maart',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Augustus',
      'September',
      'Oktober',
      'November',
      'December',
    ],
    'day': [
      'Ma',
      'Di',
      'Wo',
      'Do',
      'Vr',
      'Za',
      'Zo',
    ],
    'am': 'AM',
    'pm': 'PM'
  }
};
//get international object
Map<String, dynamic> i18nObjInLocale(LocaleType type) {
  switch (type) {
    case LocaleType.zh:
      return _i18nModel['zh'];
    case LocaleType.nl:
      return _i18nModel['nl'];
    default:
      return _i18nModel['en'];
  }
}
