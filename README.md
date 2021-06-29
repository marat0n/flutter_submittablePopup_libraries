# flutter_submittablePopup_libraries
The two libraries: SubmitButton and SubmittablePopup
____
**How to use?**

Just call `showPopup(BuildContext, Popup)`
____
Code examples:
```dart
showPopup(
  context: context,
  popup: Popup(
    title: Text("Title"),
    content: Text("Content"),
  )
);
```

```dart
showPopup(
  context: context,
  popup: Popup(
    position: PopupPosition.bottom,
    widthType: PopupWidthType.full,
    title: Text("Title"),
    content: Text("Content"),
    submitButton: SubmitButton(),
  )
);
```

```dart
showPopup(
  context: context,
  popup: Popup(
    decoration: BoxDecoration(
      color: Colors.amber[100],
      border: Border.all(
        color: Color(0xFF1565C0),
        width: 1.5
      )
    ),
    closeButtonStyle: ButtonStyle(
      backgroundColor: MaterialStateProperty.all(Color(0xFFFF5722))
    ),
    content: Text("Content"),
    submitButton: SubmitButton(
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("snackBar")));
      },
      canCloseCheck: () => false,
    )
  )
);
```
