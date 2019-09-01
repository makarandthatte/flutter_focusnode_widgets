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

    VerticalMenuForAndroidTV verticalMenuForAndroidTV =
        VerticalMenuForAndroidTV(
      menuItems: [
        nonFocusableText,
        flutterLink,
        nonFocusableText,
        androidDevelopersLink,
        googleLink
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
      style: textTheme.display1,
      child: verticalMenuForAndroidTV,
    );

    DefaultTextStyle instructions =
        DefaultTextStyle(style: textTheme.display1, child: Text(_instructions));

    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(title: Text(_title)),
        body: menu,
        bottomSheet: instructions,
      ),
    );
  }
}
