import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'logic/global.dart';
import 'package:flutter/material.dart';

class Friend extends StatelessWidget {
  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text('Add Friend\n'),
      content: CupertinoTextField(
        placeholder: 'Name',
        controller: myController,
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () async {
            bool is_existed = true;
            is_existed = await is_name_existed(myController.text);
            debugPrint(myController.text);

            Navigator.of(context).pop();
            if (is_existed) {
              sendfriendrequest(myController.text);
              return showCupertinoDialog(
                context: context,
                builder: (context) {
                  return CupertinoAlertDialog(
                    title: Text('Success'),
                    content: Text(
                      '\nYour request has been sent!',
                      textAlign: TextAlign.center,
                    ),
                    actions: <Widget>[
                      FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('OK'),
                      ),
                    ],
                  );
                },
              );
            } else {
              return showCupertinoDialog(
                context: context,
                builder: (context) {
                  return CupertinoAlertDialog(
                    title: Text('Error'),
                    content: Text(
                      '\nUsername does not exist.',
                      textAlign: TextAlign.center,
                    ),
                    actions: <Widget>[
                      FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('OK'),
                      ),
                    ],
                  );
                },
              );
            }
          },
          child: Text('OK'),
        ),
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
      ],
    );
  }
}
