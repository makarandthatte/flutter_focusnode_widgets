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

    HyperLinkWidget flutterLink = HyperLinkWidget(
      displayText: 'Flutter - Beautiful native apps in record time',
      url: 'https://flutter.dev/',
      autoFocus: true,
    );

    HyperLinkWidget androidDevelopersLink = HyperLinkWidget(
      displayText: 'Android Developers',
      url: 'https://developer.android.com/',
    );

    HyperLinkWidget googleLink = HyperLinkWidget(
      displayText: 'Google',
      url: 'https://www.google.com/',
    );

    Column column = Column(
      children: <Widget>[flutterLink, androidDevelopersLink, googleLink],
    );

    Center center = Center(child: column);

    DefaultTextStyle menu = DefaultTextStyle(
      style: textTheme.display1,
      child: center,
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
