library flutter_popup;

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'submitButton.dart';

void showPopup({
    required BuildContext context,
    required Popup popup
  }) {
    showDialog(
      context: context, 
      builder: (context) => popup
    );
}


/// Vertical position of popup
enum PopupPosition {
  /// Center of screen
  center,
  /// Bottom of screen
  bottom
}

/// Type of popup width
enum PopupWidthType {
  /// `100%` of screen width
  full,
  /// `70%` of screen width (maximal value - `500` independent pixels)
  medium
}

/// Direction of [submitButton] and [closeButton]
enum PopupButtonsDirection {
  /// Buttons are displayed in a column
  vertical,
  /// Buttons are displayed in a row
  horizontal,
}


class Popup extends StatefulWidget {
  Popup({
    this.decoration,
    PopupPosition position = PopupPosition.center,
    this.widthType = PopupWidthType.medium,
    this.title, 
    Widget? content, 
    this.submitButton,
    this.closeButtonStyle,
    this.closeButtonText = const Text(""),
    this.buttonsDirection = PopupButtonsDirection.vertical,
    this.buttonsAreReversed = false,
  }) : 
    this.content = content ?? Container(),
    this.position = (() {
      if (position == PopupPosition.center) {
        return MainAxisAlignment.center;
      }
      return MainAxisAlignment.end;
    })();


  /// Decoration of popup container
  final BoxDecoration? decoration;

  /// Vertical position of popup
  final MainAxisAlignment position;

  /// Type of popup width
  /// 
  /// [PopupWidthType.full] is `100%` of screen width
  /// 
  /// [PopupWidthType.medium] is `70%` of screen width 
  /// (maximal value - `500` independent pixels)
  final PopupWidthType widthType;

  /// Widget wich is shown at the top of popup
  /// 
  /// Default value is [new Container()]
  final Widget? title;

  /// Content widget is shown in the popup center
  /// 
  /// Default value is [new Container()]
  final Widget content;

  /// Submit button is shown between [content] and [closeButton]
  final SubmitButton? submitButton;

  /// Style of [closeButton]
  final ButtonStyle? closeButtonStyle;

  /// Text that is shown in [closeButton]
  final Text closeButtonText;

  /// Direction of [submitButton] and [closeButton]
  final PopupButtonsDirection? buttonsDirection;

  /// if value is `true` [submitButton] would be placed 
  /// at the end of popup.
  /// if value is `false` [submitButton] would be 
  /// placed at the usual position.
  final bool buttonsAreReversed;

  BoxDecoration get defaultDecoration {
    BoxDecoration result;
    Radius defaultRadius = Radius.circular(10);

    if (position == MainAxisAlignment.end) {
      result = BoxDecoration(
        borderRadius: BorderRadius.vertical(
          top: defaultRadius,
          bottom: Radius.zero
        )
      );
    } else {
      result = BoxDecoration(
        borderRadius: BorderRadius.all(defaultRadius),
      );
    }

    return result;
  }

  @override
  State<StatefulWidget> createState() => _PopupState(
    daddy: this
  );
}


class _PopupState extends State<Popup> with SingleTickerProviderStateMixin {
  _PopupState({
    required Popup daddy
  }) : _daddy = daddy;
  
  @override
  void initState() {
    super.initState();

    initAnimation();
  }

  /* POPUP */
  final Popup _daddy;

  double get _popupWidth {
    double result;
    double fullWidth = MediaQuery.of(context).size.width;

    if (_daddy.widthType == PopupWidthType.medium) {
      double devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
      result = min(
        fullWidth * 0.7, 
        500 / devicePixelRatio
      );
    } else {
      result = fullWidth;
    }

    result -= _daddy.decoration?.border?.dimensions.horizontal ?? 0;
    return result;
  }
  

  /* ANIMATION */
  late AnimationController? _animationController;
  late Animation<double>? _animation;

  double get _animationStartPoint {
    double value = 30;
    if (_daddy.position == MainAxisAlignment.end) {
      return value;
    }
    return -value;
  }
  double get _animationEndPoint {
    double value = 40;
    if (_daddy.position == MainAxisAlignment.end) {
      return 0;
    }
    return value;
  }

  void initAnimation() {
    _animationController = new AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    )..addListener(() {
        setState(() {});
      });

    _animation = Tween(
      begin: _animationStartPoint,
      end: _animationEndPoint
    ).animate(_animationController!);

    _animationController!.forward();
  }


  /* BUTTONS */
  double get _buttonsWidth {
    double widthDivisioner;
    if (_daddy.buttonsDirection == PopupButtonsDirection.horizontal) {
      widthDivisioner = 2;
    } else {
      widthDivisioner = 1;
    }

    return (_popupWidth / widthDivisioner) - 20;
  }

  Widget get _closeButton => Container(
    width: _buttonsWidth,
    alignment: AlignmentDirectional.center,
    child: Padding(
      padding: EdgeInsets.only(top: 5, bottom: 5),
      child: TextButton(
        style: _daddy.closeButtonStyle,
        onPressed: () {
          Navigator.pop(context);
        },
        child: Container(
          width: _buttonsWidth,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Icon(
                Icons.close,
                size: 28,
              ),
              _daddy.closeButtonText,
            ],
          )
        )
      ),
    ),
  );

  Flex get _buttons {
    Axis direction;
    if (_daddy.buttonsDirection == PopupButtonsDirection.horizontal) {
      direction = Axis.horizontal;
    } else {
      direction = Axis.vertical;
    }

    List<Widget> buttons = [
      Container(
        width: _buttonsWidth,
        child: _daddy.submitButton ?? Container(),
      ),
      Container(
        width: _buttonsWidth,
        child: _closeButton,
      )
    ];

    if (_daddy.buttonsAreReversed) {
      buttons = buttons.reversed.toList();
    }

    return Flex(
      direction: direction,
      children: buttons,
    );
  }


  /* CONTENT */
  Widget get _titleWidget {
    if (_daddy.title != null) {
      return Container(
        child: _daddy.title,
        margin: EdgeInsets.only(bottom: 10),
      );
    }
    return Container();
  }

  List<Widget> get _popUpContent => [
    _titleWidget,
    _daddy.content,
    _buttons,
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: _daddy.position,
      children: [
        Transform.translate(
          offset: Offset(0, _animation!.value),
          child: Material(
            borderRadius: _daddy.decoration?.borderRadius ?? 
                          _daddy.defaultDecoration.borderRadius,
            child: Container(
              decoration: _daddy.decoration ?? _daddy.defaultDecoration,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        width: _popupWidth,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(20, 25, 20, 7),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: _popUpContent,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              )
            )
          )
        )
      ],
    );
  }
}