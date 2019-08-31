library focusnode_widgets;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class VerticalMenuForAndroidTV extends StatelessWidget {
  final List<VerticalMenuItem> menuItems;

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
    assert(menuItems.elementAt(0).autoFocus);

    List<_FocusNodeEnterTapActionableWidget>
        _focusNodeEnterTapActionableWidgetList =
        List<_FocusNodeEnterTapActionableWidget>();

    void constructMenuItem(VerticalMenuItem menuItem) {
      _FocusNodeEnterTapActionableWidget focusableEnterTapActionableWidget =
          _FocusNodeEnterTapActionableWidget(
        child: menuItem.getChildWidget(),
        onEnterTapAction: menuItem.onEnterTapAction,
        autoFocus: menuItem.autoFocus,
        debugLabel: menuItem.debugLabel,
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

abstract class VerticalMenuItem {
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

  Widget getChildWidget() {
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
  Widget getChildWidget() {
    Text underLinedText = Text(
      displayText,
      style: focusStyle,
    );

    return underLinedText;
  }

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
}

class _FocusNodeEnterTapActionableWidget extends StatefulWidget {
  final String debugLabel;
  final bool autoFocus;
  final Widget child;
  final VoidCallback onEnterTapAction;

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

  _FocusNodeEnterTapActionableWidget(
      {Key key,
      @required this.onEnterTapAction,
      @required this.debugLabel,
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
      @required this.transform})
      : assert(onEnterTapAction != null),
        assert(debugLabel != null),
        assert(autoFocus != null),
        assert(child != null),
//        assert(!(childWhenNotFocused is RawMaterialButton)),
//        assert(!(childWhenNotFocused is TextField)),
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
    assert(widget.onEnterTapAction != null);

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
        widget.onEnterTapAction();
        return true;
      }
    }

    return false;
  }

  void _handleOnFocusChange(bool focusGained) {
    if (focusGained) {
      print("focus gained by " + widget.debugLabel);
      if (_gestureDetectorRequestedFocus) {
        _gestureDetectorRequestedFocus = false;
        widget.onEnterTapAction();
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
              widget.onEnterTapAction();
            }
          },
          child: _getEnabledChild(hasFocus));

      return gestureDetector;
    });

    Focus focusableEnterTapActionableChild = Focus(
      onFocusChange: _handleOnFocusChange,
      autofocus: widget.autoFocus,
      onKey: _handleOnKey,
      debugLabel: widget.debugLabel,
      child: builder,
    );

    return focusableEnterTapActionableChild;
  }
}
