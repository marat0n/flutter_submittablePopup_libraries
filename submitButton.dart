library submit_button;

import 'package:flutter/material.dart';

class SubmitButton extends StatefulWidget {
  SubmitButton({
    text,
    this.icon,
    this.width,
    onPressed,
    bool Function()? canCloseCheck,
  }) :
    this.text = text ?? "Submit",
    this.canCloseCheck = canCloseCheck ?? (() => true),
    this.onPressed = onPressed ?? (() {});

  /// Text which is shown in button.
  /// 
  /// Default value is ["Submit"]
  final String text;

  /// Icon which is shown on left side of [text]
  final Icon? icon;

  /// Width of button
  final double? width;

  /// Is called after press on button
  final Function onPressed;

  /// Function that checks need of [Navigation.of(context).pop()] after [onPressed]
  /// 
  /// Default body is [return true]
  final bool Function() canCloseCheck;

  @override
  State<StatefulWidget> createState() => _SubmitButtonState(
    daddy: this
  );
}


class _SubmitButtonState extends State<SubmitButton> {
  _SubmitButtonState({
    required SubmitButton daddy,
  }) : _daddy = daddy;
  
  SubmitButton _daddy;

  List<Widget> get content {
    if (_daddy.icon != null) {
      return [_daddy.icon!, Text(_daddy.text)];
    }
    return [Text(_daddy.text)];
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(top: 10, bottom: 10),
    child: TextButton(
      onPressed: () {
        if (_daddy.canCloseCheck()) {
          Navigator.pop(context);
        }
        _daddy.onPressed();
      },
      child: Container(
        width: _daddy.width,
        alignment: AlignmentDirectional.center,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: content,
        ),
      )
    ),
  );
}