library focusnode_widgets;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class HyperLinkWidget extends StatelessWidget {
  final String url;
  final String displayText;
  final bool autoFocus;

  final TextStyle nonFocusStyle = const TextStyle(
    fontWeight: FontWeight.normal,
    color: Colors.blue,
  );

  final TextStyle focusStyle = const TextStyle(
    fontWeight: FontWeight.normal,
    color: Colors.blue,
    decoration: TextDecoration.underline,
  );

  const HyperLinkWidget(
      {Key key,
      @required this.url,
      @required this.displayText,
      this.autoFocus = false})
      : assert(url != null),
        assert(displayText != null),
        super(key: key);

  Future _launchUrl() async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    Text textWhenNotFocused = Text(
      displayText,
      style: nonFocusStyle,
    );

    Text textWhenFocused = Text(
      displayText,
      style: focusStyle,
    );

    _FocusNodeEnterTapActionableWidget focusableEnterTapActionableWidget =
        _FocusNodeEnterTapActionableWidget(
      childWhenNotFocused: textWhenNotFocused,
      childWhenFocused: textWhenFocused,
      onEnterTapAction: _launchUrl,
      autoFocus: autoFocus,
    );

    return focusableEnterTapActionableWidget;
  }
}

class _FocusNodeEnterTapActionableWidget extends StatefulWidget {
  final String debugLabel;
  final bool autoFocus;
  final Widget childWhenNotFocused;
  final Widget childWhenFocused;
  final VoidCallback onEnterTapAction;

  _FocusNodeEnterTapActionableWidget(
      {Key key,
      @required this.onEnterTapAction,
      this.debugLabel = "_FocusNodeEnterTapActionableWidget",
      this.autoFocus = false,
      @required this.childWhenNotFocused,
      this.childWhenFocused})
      : assert(debugLabel != null),
        assert(autoFocus != null),
        assert(childWhenNotFocused != null),
        assert(!(childWhenNotFocused is RawMaterialButton)),
        assert(!(childWhenNotFocused is TextField)),
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

  @override
  Widget build(BuildContext context) {
    if (widget.onEnterTapAction == null) {
      // TODO: show in disabled mode
      return widget.childWhenNotFocused;
    }

    Builder builder = Builder(builder: (BuildContext context) {
      final FocusNode focusNode = Focus.of(context);
      final hasFocus = focusNode.hasFocus;
      final Widget effectiveChild = (widget.childWhenFocused == null)
          ? (widget.childWhenNotFocused)
          : (hasFocus ? widget.childWhenFocused : widget.childWhenNotFocused);
      //TODO: need to show the child widget in focused state
      //TODO: need to show the child widget in non focused state
      GestureDetector gestureDetector = GestureDetector(
          onTap: () {
            if (!hasFocus) {
              _gestureDetectorRequestedFocus = true;
              focusNode.requestFocus();
            } else {
              widget.onEnterTapAction();
            }
          },
          child: effectiveChild);

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
