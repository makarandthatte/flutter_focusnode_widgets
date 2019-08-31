import 'package:flutter/material.dart';
import 'package:focusnode_widgets/focusnode_widgets.dart';

void main() => runApp(MyApp());

/// This Widget is the main application widget.
class MyApp extends StatelessWidget {
  final String _title = 'focusnode_widgets example';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(title: Text(_title)),
        body: MyStatefulWidget(),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
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

    DefaultTextStyle defaultTextStyle = DefaultTextStyle(
      style: textTheme.display1,
      child: center,
    );

    return defaultTextStyle;
  }
}
