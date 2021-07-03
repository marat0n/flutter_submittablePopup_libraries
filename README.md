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
      borderRadius: BorderRadius.all(Radius.circular(30)),
      border: Border.all(
        color: Colors.blueAccent,
        width: 5,
      ),
      color: Colors.deepPurple[600],
    ),
    title: Container(
      alignment: Alignment.center,
      child: Text(
        "Title",
        style: TextStyle(
          color: Colors.white,
          fontSize: 50,
        ),
      ),
    ),
    content: Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text("Row1")],
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text("Row2")],
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text("Row3")],
        ),
      ],
    ),
    submitButton: SubmitButton(
      text: "Click me!",
      icon: Icon(Icons.chevron_right),
      onPressed: () {
        showPopup(
          context: context, 
          popup: Popup(
            position: PopupPosition.bottom,
            widthType: PopupWidthType.full,
            content: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Close me!",
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
              ],
            )
          )
        );
      },
      canCloseCheck: () => false,
    ),
    closeButtonStyle: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(Colors.pink),
    ),
    buttonsDirection: PopupButtonsDirection.horizontal,
    widthType: PopupWidthType.medium,
  )
);
```
