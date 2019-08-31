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

    HyperLinkMenuItemWidget flutterLink = HyperLinkMenuItemWidget(
      displayText: 'Flutter - Beautiful native apps in record time',
      url: 'https://flutter.dev/',
      autoFocus: true,
    );

    HyperLinkMenuItemWidget androidDevelopersLink = HyperLinkMenuItemWidget(
      displayText: 'Android Developers',
      url: 'https://developer.android.com/',
    );

    HyperLinkMenuItemWidget googleLink = HyperLinkMenuItemWidget(
      displayText: 'Google',
      url: 'https://www.google.com/',
    );

    VerticalMenuForAndroidTV verticalMenuForAndroidTV =
        VerticalMenuForAndroidTV(
      menuItems: [flutterLink, androidDevelopersLink, googleLink],
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
