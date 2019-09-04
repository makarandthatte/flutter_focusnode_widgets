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
      'Use up down arrows to navigate and Enter (OK) to open the URL';

  bool checked = false;

  String keyLogText;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    void launchUrl(BuildContext context) {
      // put code to launch the URL here
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
/*
    void handleTrapKeyEvent(BuildContext context, RawKeyEvent event) {
      if (event == null) {
        return;
      }
      String eventString = event.toString(minLevel: DiagnosticLevel.debug);
      if (keyLogText == null) {
        keyLogText = '';
      }
      keyLogText += (eventString + '\n');
      setState(() {});
    }

    Text keyLog = Text(keyLogText == null ? 'No key pressed yet' : keyLogText);

    DefaultTextStyle keyLogShort = DefaultTextStyle(
      style: textTheme.caption,
      child: keyLog,
    );

    KeyPrintMenuItem keyPrintMenuItem = KeyPrintMenuItem(
      child: Text('Press any key to see log below'),
      voidTrapKeyEvent: handleTrapKeyEvent,
      autoFocus: true,
    );

 */

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
