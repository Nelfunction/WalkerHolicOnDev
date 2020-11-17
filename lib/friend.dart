import 'dart:ui';

import 'logic/global.dart';
import 'package:flutter/material.dart';


class Friend extends StatelessWidget {

  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Friend Add'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: myController,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // When the user presses the button, show an alert dialog containing
        // the text that the user has entered into the text field.
        onPressed: () async {

          bool is_existed=true;
          is_existed=await is_name_existed(myController.text);
          debugPrint(myController.text);
          if(is_existed)
            {
              sendfriendrequest(myController.text);
              return showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    // Retrieve the text the that user has entered by using the
                    // TextEditingController.
                    content: Text('요청을 보냈습니다!\n사용자에게 친구 수락 요청을 보냈습니다. 사용자가 요청을 수락하면 친구 등록이 완료됩니다.'),
                  );
                },
              );
            }
          else
            {
              return showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    // Retrieve the text the that user has entered by using the
                    // TextEditingController.
                    content: Text('존재하지 않는 사용자 이름입니다.'),
                  );
                },
              );

            }
        },
        tooltip: 'Show me the value!',
        child: Icon(Icons.text_fields),
      ),
    );
  }
}
