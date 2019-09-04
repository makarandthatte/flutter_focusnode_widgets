# focusnode_widgets

Reusable focus node widgets. Can be controlled with 
keyboard or Remote Control (e.g. on Android TV).

## Usage
To use this plugin, add `focusnode_widgets` as a [dependency in your pubspec.yaml file](https://flutter.dev/platform-plugins/).

### Example

``` dart
import 'package:flutter/material.dart';
import 'package:focusnode_widgets/focusnode_widgets.dart';

void main() => runApp(MenuForAndroidTV());

class MenuForAndroidTV extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MenuForAndroidTV();
  }
}

class _MenuForAndroidTV extends State<MenuForAndroidTV> {
  final String _title = 'focusnode_widgets example for Android TV';
  final String _instructions =
      'Use DPAD up down arrow keyss to navigate and DPAD center key to open the URL';

  bool checked = false;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    void launchUrl(BuildContext context) {
      // put code to launch the URL here
      // on android TV url needs to be launched in WebView as per guidelines,
      // browser can't be used
    }

    HyperLinkMenuItem flutterLink = HyperLinkMenuItem(
      displayText: 'Flutter - Beautiful native apps in record time',
      launchUrl: launchUrl,
      autoFocus: true,
    );

    void _onChanged(BuildContext context, bool selected) {
      checked = selected;
      setState(() {});
    }

    CheckboxListTileMenuItem checkboxListTileMenuItem =
        CheckboxListTileMenuItem(
      title: DefaultTextStyle(
          style: textTheme.headline,
          child: Text('I accept Terms and Conditions')),
      enterTapActionCallback: _onChanged,
      value: checked,
      controlAffinity: ListTileControlAffinity.leading,
    );

    Text nonFocusableText2 = Text('Non focusable text item 2');

    void _handleEnterTapAction(BuildContext context) {
      final snackBar = SnackBar(
        content: Text('Yay! A SnackBar!'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            // Some code to undo the change.
          },
        ),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    }

    FocusableSimpleMenuItem focusableSimpleMenuItem = FocusableSimpleMenuItem(
      child: Text('Click, Tap or Press Enter/ OK to show SnackBar'),
      enterTapActionCallback: _handleEnterTapAction,
    );

    Text instructions = Text(_instructions);

    VerticalMenuForAndroidTV verticalMenuForAndroidTV =
        VerticalMenuForAndroidTV(
      menuItems: [
//        keyPrintMenuItem,
//        keyLogShort,
        flutterLink,
        nonFocusableText2,
        checkboxListTileMenuItem,
        focusableSimpleMenuItem,
        instructions,
      ],
      focusedBackgroundDecoration: BoxDecoration(
        border: Border.all(color: Colors.amber[900], width: 2),
      ),
      alignment: Alignment.center,
      constraints: BoxConstraints(
        maxHeight: 40,
        maxWidth: 700,
        minHeight: 10,
        minWidth: 100,
      ),
    );

    DefaultTextStyle menu = DefaultTextStyle(
      style: textTheme.headline,
      child: verticalMenuForAndroidTV,
    );

    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(title: Text(_title)),
        body: menu,
      ),
    );
  }
}

```
