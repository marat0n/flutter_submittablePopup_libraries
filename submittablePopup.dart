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
      builder: (contect) => popup
    );
}

class PopupRoute extends ModalRoute {
  PopupRoute({
    RoutePageBuilder? pageBuilder,
    bool barrierDismissible = true,
    Color barrierColor = const Color(0x80000000),
    String? barrierLabel,
    Duration transitionDuration = const Duration(milliseconds: 200),
    RouteTransitionsBuilder? transitionBuilder,
    RouteSettings? settings,
  }) : 
    _pageBuilder = pageBuilder!,
    _barrierDismissible = barrierDismissible,
    _barrierLabel = barrierLabel!,
    _barrierColor = barrierColor,
    _transitionDuration = transitionDuration,
    super(settings: settings);

  final RoutePageBuilder _pageBuilder;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return Semantics(
      child: _pageBuilder(context, animation, secondaryAnimation),
      scopesRoute: true,
      explicitChildNodes: true,
    );
  }

  @override
  bool get barrierDismissible => _barrierDismissible;
  final bool _barrierDismissible;

  @override
  String get barrierLabel => _barrierLabel;
  final String _barrierLabel;

  @override
  Color get barrierColor => _barrierColor;
  final Color _barrierColor;

  @override
  Duration get transitionDuration => _transitionDuration;
  final Duration _transitionDuration;

  @override
  bool get maintainState => true;

  @override
  bool get opaque => false;
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


class Popup extends StatefulWidget {
  Popup({
    this.decoration,
    Widget? title, 
    Widget? content, 
    this.submitButton,
    this.closeButtonStyle,
    PopupPosition position = PopupPosition.center,
    this.widthType = PopupWidthType.medium,
  }) : 
    this.content = content ?? Container(),
    this.title = title ?? Container(),
    this.position = (() {
      if (position == PopupPosition.center) {
        return MainAxisAlignment.center;
      }
      return MainAxisAlignment.end;
    })();

  /// Decoration of popup container
  final Decoration? decoration;

  /// Widget wich is shown at the top of popup
  /// 
  /// Default value is [new Container()]
  final Widget title;

  /// Content widget is shown in the popup center
  /// 
  /// Default value is [new Container()]
  final Widget content;

  /// Submit button is shown between [content] and [closeButton]
  final SubmitButton? submitButton;

  /// Style of [closeButton]
  final ButtonStyle? closeButtonStyle;

  /// Vertical position of popup
  final MainAxisAlignment position;

  /// Type of popup width
  /// 
  /// [PopupWidthType.full] is `100%` of screen width
  /// 
  /// [PopupWidthType.medium] is `70%` of screen width (maximal value - `500` independent pixels)
  final PopupWidthType widthType;

  @override
  State<StatefulWidget> createState() => _PopupState(
    daddy: this
  );
}


class _PopupState extends State<Popup> with SingleTickerProviderStateMixin {
  _PopupState({
    required Popup daddy
  }) : _daddy = daddy;

  final Popup _daddy;

  double get _width {
    if (_daddy.widthType == PopupWidthType.medium) {
      double devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
      return min(
        MediaQuery.of(context).size.width * 0.7, 
        500 / devicePixelRatio
      );
    }
    return MediaQuery.of(context).size.width;
  } 

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

  @override
  void initState() {
    super.initState();

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

  Widget get _closeButton => Container(
    width: _width,
    alignment: AlignmentDirectional.center,
    child: Padding(
      padding: EdgeInsets.only(top: 5, bottom: 5),
      child: TextButton(
        style: _daddy.closeButtonStyle,
        onPressed: () {
          Navigator.pop(context);
        },
        child: Container(
          width: _width,
          alignment: AlignmentDirectional.center,
          child: Icon(
            Icons.close,
            size: 28,
          ),
        )
      ),
    ),
  );

  Widget get _titleWidget => Container(
    child: _daddy.title,
    margin: EdgeInsets.only(bottom: 10),
  );

  List<Widget> get _popUpContent => [
    _titleWidget,
    _daddy.content,
    _daddy.submitButton ?? Container(),
    _closeButton
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: _daddy.position,
      children: [
        Transform.translate(
          offset: Offset(0, _animation!.value),
          child: Dialog(
            insetPadding: EdgeInsets.zero,
            child: Container(
              decoration: _daddy.decoration,
              width: _width,
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 25, 20, 7),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _popUpContent,
                ),
              ),
            )
          )
        )
      ],
    );
  }
}