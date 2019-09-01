library focusnode_widgets;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class VerticalMenuForAndroidTV extends StatelessWidget {
  final List<StatelessWidget> menuItems;

  final Color nonFocusedBackgroundColor;
  final Color focusedBackgroundColor;
  final AlignmentGeometry alignment;
  final BoxConstraints constraints;
  final Decoration nonFocusedBackgroundDecoration;
  final Decoration focusedBackgroundDecoration;
  final EdgeInsetsGeometry padding;
  final Decoration nonFocusedForegroundDecoration;
  final Decoration focusedForegroundDecoration;
  final double width;
  final double height;
  final EdgeInsetsGeometry margin;
  final Matrix4 transform;

  const VerticalMenuForAndroidTV({
    Key key,
    @required this.menuItems,
    this.nonFocusedBackgroundColor,
    this.focusedBackgroundColor,
    this.alignment,
    this.constraints,
    this.nonFocusedBackgroundDecoration,
    this.focusedBackgroundDecoration,
    this.padding,
    this.nonFocusedForegroundDecoration,
    this.focusedForegroundDecoration,
    this.width,
    this.height,
    this.margin,
    this.transform,
  })  : assert(menuItems != null),
        assert(menuItems.length > 0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = List<Widget>();

    void constructMenuItem(StatelessWidget menuItem) {
      bool menuItemIsVerticalMenuItem = menuItem is VerticalMenuItem;
      Widget widget;

      if (menuItemIsVerticalMenuItem) {
        VerticalMenuItem verticalMenuItem = menuItem as VerticalMenuItem;

        widget = _FocusNodeEnterTapActionableWidget(
          child: menuItem.build(context),
          handleEnterTapAction: verticalMenuItem?.onEnterTapAction,
          autoFocus: verticalMenuItem?.autoFocus,
          debugLabel: verticalMenuItem?.debugLabel,
          nonFocusedForegroundDecoration: nonFocusedForegroundDecoration,
          transform: transform,
          nonFocusedBackgroundColor: nonFocusedBackgroundColor,
          focusedForegroundDecoration: focusedForegroundDecoration,
          nonFocusedBackgroundDecoration: nonFocusedBackgroundDecoration,
          height: height,
          focusedBackgroundDecoration: focusedBackgroundDecoration,
          focusedBackgroundColor: focusedBackgroundColor,
          constraints: constraints,
          width: width,
          margin: margin,
          padding: padding,
          alignment: alignment,
        );
      } else {
        widget = menuItem.build(context);
      }

      widgetList.add(widget);
    }

    menuItems.forEach(constructMenuItem);

    Column column = Column(
      children: widgetList,
    );

    Center center = Center(child: column);

    SingleChildScrollView singleChildScrollView = SingleChildScrollView(
      child: center,
    );

    return singleChildScrollView;
  }
}

abstract class VerticalMenuItem extends StatelessWidget {
  final bool autoFocus;
  final String debugLabel;

  const VerticalMenuItem({
    Key key,
    @required this.autoFocus,
    @required this.debugLabel,
  })  : assert(autoFocus != null),
        super();

  void onEnterTapAction(BuildContext context) {
    return null;
  }
}

/// Signature of callbacks that have BuildContext and return no data.
typedef VoidBuildContext = void Function(BuildContext context);

class FocusableSimpleMenuItem extends VerticalMenuItem {
  final Widget child;
  final VoidBuildContext enterTapActionCallback;

  const FocusableSimpleMenuItem({
    Key key,
    @required this.child,
    bool autoFocus = false,
    String debugLabel = "FocusableSimpleMenuItem",
    this.enterTapActionCallback,
  })  : assert(child != null),
        super(autoFocus: autoFocus, debugLabel: debugLabel);

  @override
  void onEnterTapAction(BuildContext context) {
    if (enterTapActionCallback == null) {
      return;
    }
    enterTapActionCallback(context);
  }

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

class HyperLinkMenuItem extends VerticalMenuItem {
  final String url;
  final String displayText;

  final TextStyle focusStyle = const TextStyle(
    fontWeight: FontWeight.normal,
    color: Colors.blue,
    decoration: TextDecoration.underline,
  );

  const HyperLinkMenuItem(
      {Key key,
      @required this.url,
      @required this.displayText,
      bool autoFocus = false,
      String debugLabel = "HyperLinkMenuItem",
      VoidCallback onEnterTapAction})
      : assert(url != null),
        assert(displayText != null),
        super(
          key: key,
          autoFocus: autoFocus,
          debugLabel: debugLabel,
        );

  @override
  void onEnterTapAction(BuildContext context) {
    _launchUrl(context);
  }

  Future _launchUrl(BuildContext context) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    Text underLinedText = Text(
      displayText,
      style: focusStyle,
    );

    return underLinedText;
  }
}

class _FocusNodeEnterTapActionableWidget extends StatefulWidget {
  final String debugLabel;
  final bool autoFocus;
  final Widget child;
  final VoidBuildContext _handleEnterTapAction;

  final Color nonFocusedBackgroundColor;
  final Color focusedBackgroundColor;
  final AlignmentGeometry alignment;
  final BoxConstraints constraints;
  final Decoration nonFocusedBackgroundDecoration;
  final Decoration focusedBackgroundDecoration;
  final EdgeInsetsGeometry padding;
  final Decoration nonFocusedForegroundDecoration;
  final Decoration focusedForegroundDecoration;
  final double width;
  final double height;
  final EdgeInsetsGeometry margin;
  final Matrix4 transform;

  _FocusNodeEnterTapActionableWidget({
    Key key,
    VoidBuildContext handleEnterTapAction,
    this.debugLabel,
    @required this.autoFocus,
    @required this.child,
    @required this.nonFocusedBackgroundColor,
    @required this.focusedBackgroundColor,
    @required this.alignment,
    @required this.constraints,
    @required this.nonFocusedBackgroundDecoration,
    @required this.focusedBackgroundDecoration,
    @required this.padding,
    @required this.nonFocusedForegroundDecoration,
    @required this.focusedForegroundDecoration,
    @required this.width,
    @required this.height,
    @required this.margin,
    @required this.transform,
  })  : assert(child != null),
        _handleEnterTapAction = handleEnterTapAction,
        super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _FocusableEnterTapActionableWidget();
  }
}

class _FocusableEnterTapActionableWidget
    extends State<_FocusNodeEnterTapActionableWidget> {
  bool _gestureDetectorRequestedFocus = false;

  bool _handleOnKey(FocusNode node, RawKeyEvent event, BuildContext context) {
    if (event is RawKeyDownEvent) {
      print(
          '_handleKeyPress: Focus node ${node.debugLabel} got key event: ${event.logicalKey}');
      if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        TraversalDirection direction = TraversalDirection.down;
        node.focusInDirection(direction);
        return true;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        TraversalDirection direction = TraversalDirection.up;
        node.focusInDirection(direction);
        return true;
      } else if (event.logicalKey == LogicalKeyboardKey.enter) {
        return _handleEnterTapAction(context);
      }
    }

    return false;
  }

  bool _handleEnterTapAction(BuildContext context) {
    if (widget._handleEnterTapAction == null) {
      return false;
    }
    widget._handleEnterTapAction(context);
    return true;
  }

  void _handleOnFocusChange(bool focusGained, BuildContext context) {
    if (focusGained) {
      print("focus gained by " + widget.debugLabel);
      if (_gestureDetectorRequestedFocus) {
        _gestureDetectorRequestedFocus = false;
        _handleEnterTapAction(context);
      }
      //TODO: need to show the child widget in focused state
    } else {
      //TODO: need to show the child widget in non focused state
      print("focus lossed by " + widget.debugLabel);
    }
  }

  Widget _getEnabledChild(bool hasFocus) {
    Container container = Container(
      child: widget.child,
      color: hasFocus
          ? widget.focusedBackgroundColor
          : widget.nonFocusedBackgroundColor,
      alignment: widget.alignment,
      constraints: widget.constraints,
      decoration: hasFocus
          ? widget.focusedBackgroundDecoration
          : widget.nonFocusedBackgroundDecoration,
      padding: widget.padding,
      foregroundDecoration: hasFocus
          ? widget.focusedForegroundDecoration
          : widget.nonFocusedForegroundDecoration,
      width: widget.width,
      height: widget.height,
      margin: widget.margin,
      transform: widget.transform,
    );

    return container;
  }

  @override
  Widget build(BuildContext context) {
    Builder builder = Builder(builder: (BuildContext context) {
      final FocusNode focusNode = Focus.of(context);
      final hasFocus = focusNode.hasFocus;

      GestureDetector gestureDetector = GestureDetector(
          onTap: () {
            if (!hasFocus) {
              _gestureDetectorRequestedFocus = true;
              focusNode.requestFocus();
            } else {
              _handleEnterTapAction(context);
            }
          },
          child: _getEnabledChild(hasFocus));

      return gestureDetector;
    });

    void _onFocusChange(bool focusGained) {
      _handleOnFocusChange(focusGained, context);
    }

    bool _onKey(FocusNode node, RawKeyEvent event) {
      return _handleOnKey(node, event, context);
    }

    Focus focusableEnterTapActionableChild = Focus(
      onFocusChange: _onFocusChange,
      autofocus: widget.autoFocus == null ? false : widget.autoFocus,
      onKey: _onKey,
      debugLabel: widget.debugLabel,
      child: builder,
    );

    return focusableEnterTapActionableChild;
  }
}
