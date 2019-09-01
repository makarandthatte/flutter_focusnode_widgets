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
    List<_FocusNodeEnterTapActionableWidget>
        _focusNodeEnterTapActionableWidgetList =
        List<_FocusNodeEnterTapActionableWidget>();

    void constructMenuItem(StatelessWidget menuItem) {
      bool menuItemIsVerticalMenuItem = menuItem is VerticalMenuItem;
      VerticalMenuItem verticalMenuItem;

      verticalMenuItem =
          menuItemIsVerticalMenuItem ? menuItem as VerticalMenuItem : null;

      _FocusNodeEnterTapActionableWidget focusableEnterTapActionableWidget =
          _FocusNodeEnterTapActionableWidget(
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

      _focusNodeEnterTapActionableWidgetList
          .add(focusableEnterTapActionableWidget);
    }

    menuItems.forEach(constructMenuItem);

    Column column = Column(
      children: _focusNodeEnterTapActionableWidgetList,
    );

    Center center = Center(child: column);

    SingleChildScrollView singleChildScrollView = SingleChildScrollView(
      child: center,
    );

    return singleChildScrollView;
  }
}

enum _FocusNodeWidgetType { hyperLinkWidget, checkboxListTileWidget }

abstract class VerticalMenuItem extends StatelessWidget {
  final _FocusNodeWidgetType focusNodeWidgetType;
  final bool autoFocus;
  final String debugLabel;

  const VerticalMenuItem({
    Key key,
    @required this.focusNodeWidgetType,
    @required this.autoFocus,
    @required this.debugLabel,
  })  : assert(focusNodeWidgetType != null),
        assert(autoFocus != null),
        super();

  void onEnterTapAction() {
    return null;
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
          focusNodeWidgetType: _FocusNodeWidgetType.hyperLinkWidget,
          autoFocus: autoFocus,
          debugLabel: debugLabel,
        );

  @override
  void onEnterTapAction() {
    _launchUrl();
  }

  Future _launchUrl() async {
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
  final VoidCallback _handleEnterTapAction;

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
    VoidCallback handleEnterTapAction,
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

  bool _handleOnKey(FocusNode node, RawKeyEvent event) {
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
        return _handleEnterTapAction();
      }
    }

    return false;
  }

  bool _handleEnterTapAction() {
    if (widget._handleEnterTapAction == null) {
      return false;
    }
    widget._handleEnterTapAction();
    return true;
  }

  void _handleOnFocusChange(bool focusGained) {
    if (focusGained) {
      print("focus gained by " + widget.debugLabel);
      if (_gestureDetectorRequestedFocus) {
        _gestureDetectorRequestedFocus = false;
        _handleEnterTapAction();
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
              _handleEnterTapAction();
            }
          },
          child: _getEnabledChild(hasFocus));

      return gestureDetector;
    });

    Focus focusableEnterTapActionableChild = Focus(
      onFocusChange: _handleOnFocusChange,
      autofocus: widget.autoFocus == null ? false : widget.autoFocus,
      onKey: _handleOnKey,
      debugLabel: widget.debugLabel,
      child: builder,
    );

    return focusableEnterTapActionableChild;
  }
}
