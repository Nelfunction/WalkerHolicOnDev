import 'dart:ui';

import 'logic/global.dart';
import 'package:flutter/material.dart';

class Friend_request_list extends StatefulWidget {
  @override
  _Friend_request_listState createState() => _Friend_request_listState();
}


class _Friend_request_listState extends State<Friend_request_list> {

  final myController = TextEditingController();

  @override Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
          itemCount: friend_requests.length,
          itemBuilder: (context, index) {
            return ListTile(
                title: Text(friend_requests[index],
                    style: TextStyle(
                      fontSize: 20.0,
                    )),
                trailing: Wrap(
                  spacing: 1, // space between two icons
                  children: <Widget>[
                    FlatButton(
                        onPressed: () {
                          acceptfriendrequest(friend_requests[index]);
                          friend_requests.removeAt(index);
                          setState(() {
                          });

                        },
                        child: Text('Accept',
                            style: TextStyle(
                              fontSize: 14.0,
                            )
                        )
                    ), // icon-1
                    FlatButton(
                        onPressed: () {
                          denyfriendrequest(friend_requests[index]);
                          friend_requests.removeAt(index);
                          setState(() {

                          });
                        },
                        child: Text('Deny',
                            style: TextStyle(
                              fontSize: 14.0,
                            )
                        )
                    ), // icon-2
                  ],
                ),


            );
          },
        ),
      );
  }

}