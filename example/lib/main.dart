import 'package:flutter/material.dart';
import 'package:focusnode_widgets/focusnode_widgets.dart';

void main() => runApp(MenuForAndroidTV());

class MenuForAndroidTV extends StatelessWidget {
  final String _title = 'focusnode_widgets example for Android TV';
  final String _instructions =
      'Use up down arrows to navigate and Enter (OK) to open the URL';

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    HyperLinkMenuItem flutterLink = HyperLinkMenuItem(
      displayText: 'Flutter - Beautiful native apps in record time',
      url: 'https://flutter.dev/',
      autoFocus: true,
    );

    HyperLinkMenuItem androidDevelopersLink = HyperLinkMenuItem(
      displayText: 'Android Developers',
      url: 'https://developer.android.com/',
    );

    HyperLinkMenuItem googleLink = HyperLinkMenuItem(
      displayText: 'Google',
      url: 'https://www.google.com/',
    );

    Text nonFocusableText = Text('Non focusable text item');

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
        nonFocusableText,
        flutterLink,
        nonFocusableText2,
        androidDevelopersLink,
        focusableSimpleMenuItem,
        googleLink,
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
