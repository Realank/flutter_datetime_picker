# flutter_datetime_picker

[Pub Package](https://pub.dartlang.org/packages/flutter_datetime_picker)

A flutter date time picker inspired by [flutter-cupertino-date-picker](https://github.com/wuzhendev/flutter-cupertino-date-picker)

you can choose date / time / date&time in English and Chinese, and you can also custom your own picker content


| Date picker | Time picker | Date & Time picker (Chinese) | Date & Time  picker (English-America)|
| ------- | ------- |------- | ------- |
|![]( screen_date.png)|![]( screen_time.png)|![]( screen_datetime_chinese.png)|![]( screen_datetime_english.png)|

## Usage
```
FlatButton(
    onPressed: () {
        DatePicker.showDateTimePicker(context, showTitleActions: true, onChanged: (date) {
            print('change $date');
        }, onConfirm: (date) {
            print('confirm $date');
        }, currentTime: DateTime(2008, 12, 31, 23, 12, 34), locale: 'zh');
    },
    child: Text(
        'show date time picker (Chinese)',
        style: TextStyle(color: Colors.blue),
    ));
```
## Getting Started

For help getting started with Flutter, view our online [documentation](https://flutter.io/).

For help on editing package code, view the [documentation](https://flutter.io/developing-packages/).
