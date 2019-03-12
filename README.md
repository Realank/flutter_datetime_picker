# Flutter Datetime Picker

[(Pub) flutter_datetime_picker](https://pub.dartlang.org/packages/flutter_datetime_picker)

A flutter date time picker inspired by [flutter-cupertino-date-picker](https://github.com/wuzhendev/flutter-cupertino-date-picker)

you can choose date / time / date&time in multiple languages:

- English(en)
- Dutch(nl)
- Chinese(zh)
- Russian(ru)
- Italian(it)
- French(fr)
- Spanish(es)
- Portuguese(pt)
- Korean(ko)
- Arabic(ar)

and you can also custom your own picker content


|Date picker|Time picker|Date Time picker|
| ------- | ------- |------- |
|![]( screen_date.png) |![]( screen_time.png) |![]( screen_datetime_chinese.png) |

International:

| Date Time picker (Chinese) | Date Time picker (America) | Date Time picker (Dutch) | Date Time picker (Russian) |
| ------- | ------- | ------- | ------- |
|![]( screen_datetime_chinese.png)|![]( screen_datetime_english.png)|![]( screen_datetime_dutch.png)|![]( screen_datetime_russian.png)|

## Usage
```
FlatButton(
    onPressed: () {
        DatePicker.showDatePicker(context,
                              showTitleActions: true,
                              minTime: DateTime(2018, 3, 5),
                              maxTime: DateTime(2019, 6, 7), onChanged: (date) {
                            print('change $date');
                          }, onConfirm: (date) {
                            print('confirm $date');
                          }, currentTime: DateTime.now(), locale: LocaleType.zh);
    },
    child: Text(
        'show date time picker (Chinese)',
        style: TextStyle(color: Colors.blue),
    ));
```

## Custom
If you want to customize your own style of date time picker, there is a class called CommonPickerModel, every type of date time picker is extended from this class, you can refer to other picker model (eg. DatePickerModel), and write your custom one, then pass this model to showPicker method, so that your own date time picker will appear, it’s easy, and will perfectly meet your demand
## Getting Started

For help getting started with Flutter, view our online [documentation](https://flutter.io/).

For help on editing package code, view the [documentation](https://flutter.io/developing-packages/).
