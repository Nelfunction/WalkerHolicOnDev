import 'package:flutter/material.dart';

class CharacterPage extends StatefulWidget {
  @override
  _CharacterPageState createState() => _CharacterPageState();
}

class _CharacterPageState extends State<CharacterPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
          child: Container(
            child: Column(
              children: [
                SizedBox(height: 70),
                Text(
                  'Characters',
                  style: TextStyle(fontSize: 36, color: Colors.white),
                ),
                Expanded(
                  child: ListView.builder(
                      padding: EdgeInsets.all(10),
                      shrinkWrap: true,
                      itemCount: 4,
                      itemBuilder: (BuildContext context, int index) {
                        return CharaterRow();
                      }
                  ),
                )
              ],
            ),
          )
      ),
    );
  }
}

class CharaterRow extends StatefulWidget {
  _CharaterRowState createState() => _CharaterRowState();
}

class _CharaterRowState extends State<CharaterRow> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CharacterContainer(),
          CharacterContainer(),
          CharacterContainer(),
          CharacterContainer(),
        ],
      ),
    );
  }

}

class CharacterContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white, width: 4),
              color: Color.fromARGB(100, 255, 255, 255),

          ),
          margin: EdgeInsets.fromLTRB(10,10,10,5),
          padding: EdgeInsets.all(10),
          child: SizedBox(
            width: 40,
            height: 40,
            child: Image.asset("assets/images/kittenIcon.png"),
          ),
        ),
        Text(
          "Cat",
          style: TextStyle(fontSize: 18, color: Colors.white),
        )
      ],
    );
  }
}
