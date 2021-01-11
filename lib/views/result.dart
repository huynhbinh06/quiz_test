import 'package:flutter/material.dart';

class Result extends StatefulWidget {
  final int correct, incorrect, total;

  Result(
      {@required this.correct, @required this.incorrect, @required this.total});

  @override
  _ResultState createState() => _ResultState();
}

class _ResultState extends State<Result> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${widget.correct} / ${widget.total}",
                  style: TextStyle(fontSize: 25),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  "You answered ${widget.correct} answer correctly and ${widget.incorrect} answer incorrectly",
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24,),
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(30)
                    ),
                    child: Text("Go to home", style: TextStyle(color: Colors.white, fontSize: 19),),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
