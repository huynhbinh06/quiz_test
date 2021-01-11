import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quiz_marker/model/question_model.dart';
import 'package:quiz_marker/services/database.dart';
import 'package:quiz_marker/views/result.dart';
import 'package:quiz_marker/widgets/quiz_play_widgets.dart';
import 'package:quiz_marker/widgets/widgets.dart';

class PlayQuiz extends StatefulWidget {
  final String quizId;
  PlayQuiz(this.quizId);

  @override
  _PlayQuizState createState() => _PlayQuizState();
}

int total = 0;
int _correct = 0;
int _incorrect = 0;
int _notAttempted = 0;

///Stream
Stream infoStream;

class _PlayQuizState extends State<PlayQuiz> {
  DatabaseService databaseService = new DatabaseService();
  QuerySnapshot questionsSnapshot;

  bool isLoading = true;

  QuestionModel getQuestionModelFromDatasnapshot(
      DocumentSnapshot questionSnapshot) {
    QuestionModel questionModel = new QuestionModel();
    questionModel.question = questionSnapshot.data["question"];

    List<String> options = [
      questionSnapshot.data["option1"],
      questionSnapshot.data["option2"],
      questionSnapshot.data["option3"],
      questionSnapshot.data["option4"],
    ];

    options.shuffle();

    questionModel.option1 = options[0];
    questionModel.option2 = options[1];
    questionModel.option3 = options[2];
    questionModel.option4 = options[3];
    questionModel.correctOption = questionSnapshot.data["option1"];
    questionModel.answered = false;

    return questionModel;
  }

  @override
  void initState() {
    print("${widget.quizId}");
    databaseService.getQuizData(widget.quizId).then((value) {
      questionsSnapshot = value;
      _notAttempted = questionsSnapshot.documents.length;
      _correct = 0;
      _incorrect = 0;
      isLoading = false;
      total = questionsSnapshot.documents.length;

      setState(() {});
    });

    if (infoStream == null) {
      infoStream = Stream<List<int>>.periodic(Duration(milliseconds: 100), (x) {
        print("this is x $x");
        return [_correct, _incorrect];
      });
    }

    super.initState();
  }

  @override
  void dispose() {
    infoStream = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBar(context),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: Colors.black54,
        ),
        brightness: Brightness.light,
      ),
      body: isLoading
          ? Container(
              child: Center(child: CircularProgressIndicator()),
            )
          : SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    InfoHeader(
                      length: questionsSnapshot.documents.length,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    questionsSnapshot.documents == null
                        ? Container(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.symmetric(horizontal: 24),
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemCount: questionsSnapshot.documents.length,
                            itemBuilder: (context, index) {
                              return QuizPlayTile(
                                  questionModel:
                                      getQuestionModelFromDatasnapshot(
                                          questionsSnapshot.documents[index]),
                                  index: index);
                            },
                          )
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => Result(
                      correct: _correct, incorrect: _incorrect, total: total)));
        },
      ),
    );
  }
}

class InfoHeader extends StatefulWidget {
  final int length;

  InfoHeader({this.length});

  @override
  _InfoHeaderState createState() => _InfoHeaderState();
}

class _InfoHeaderState extends State<InfoHeader> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: infoStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? Container(
                height: 40,
                margin: EdgeInsets.only(left: 14),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  children: [
                    NoOfQuestionTile(
                      text: "Total",
                      number: widget.length,
                    ),
                    NoOfQuestionTile(
                      text: "Correct",
                      number: _correct,
                    ),
                    NoOfQuestionTile(
                      text: "Incorrect",
                      number: _incorrect,
                    ),
                    NoOfQuestionTile(
                      text: "NotAttempted",
                      number: _notAttempted,
                    ),
                  ],
                ),
              )
            : Container();
      },
    );
  }
}

class QuizPlayTile extends StatefulWidget {
  final QuestionModel questionModel;
  final int index;
  QuizPlayTile({this.questionModel, this.index});

  @override
  _QuizPlayTileState createState() => _QuizPlayTileState();
}

class _QuizPlayTileState extends State<QuizPlayTile> {
  String optionSelected = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Q${widget.index + 1} ${widget.questionModel.question}",
            style: TextStyle(
              fontSize: 18,
              color: Colors.black87,
            ),
          ),
          SizedBox(
            height: 12,
          ),
          GestureDetector(
            onTap: () {
              if (!widget.questionModel.answered) {
                ///correct
                if (widget.questionModel.option1 ==
                    widget.questionModel.correctOption) {
                  setState(() {
                    optionSelected = widget.questionModel.option1;
                    widget.questionModel.answered = true;
                    _correct = _correct + 1;
                    _notAttempted = _notAttempted - 1;
                  });
                } else {
                  setState(() {
                    optionSelected = widget.questionModel.option1;
                    widget.questionModel.answered = true;
                    _incorrect = _incorrect + 1;
                    _notAttempted = _notAttempted - 1;
                  });
                }
              }
            },
            child: OptionTile(
              option: "A",
              description: widget.questionModel.option1,
              correctAnswer: widget.questionModel.correctOption,
              optionSelected: optionSelected,
            ),
          ),
          SizedBox(
            height: 4,
          ),
          GestureDetector(
            onTap: () {
              if (!widget.questionModel.answered) {
                ///correct
                if (widget.questionModel.option2 ==
                    widget.questionModel.correctOption) {
                  setState(() {
                    optionSelected = widget.questionModel.option2;
                    widget.questionModel.answered = true;
                    _correct = _correct + 1;
                    _notAttempted = _notAttempted - 1;
                  });
                } else {
                  setState(() {
                    optionSelected = widget.questionModel.option2;
                    widget.questionModel.answered = true;
                    _incorrect = _incorrect + 1;
                    _notAttempted = _notAttempted - 1;
                  });
                }
              }
            },
            child: OptionTile(
              option: "B",
              description: widget.questionModel.option2,
              correctAnswer: widget.questionModel.correctOption,
              optionSelected: optionSelected,
            ),
          ),
          SizedBox(
            height: 4,
          ),
          GestureDetector(
            onTap: () {
              if (!widget.questionModel.answered) {
                ///correct
                if (widget.questionModel.option3 ==
                    widget.questionModel.correctOption) {
                  setState(() {
                    optionSelected = widget.questionModel.option3;
                    widget.questionModel.answered = true;
                    _correct = _correct + 1;
                    _notAttempted = _notAttempted - 1;
                  });
                } else {
                  setState(() {
                    optionSelected = widget.questionModel.option3;
                    widget.questionModel.answered = true;
                    _incorrect = _incorrect + 1;
                    _notAttempted = _notAttempted - 1;
                  });
                }
              }
            },
            child: OptionTile(
              option: "C",
              description: widget.questionModel.option3,
              correctAnswer: widget.questionModel.correctOption,
              optionSelected: optionSelected,
            ),
          ),
          SizedBox(
            height: 4,
          ),
          GestureDetector(
            onTap: () {
              if (!widget.questionModel.answered) {
                ///correct
                if (widget.questionModel.option4 ==
                    widget.questionModel.correctOption) {
                  setState(() {
                    optionSelected = widget.questionModel.option4;
                    widget.questionModel.answered = true;
                    _correct = _correct + 1;
                    _notAttempted = _notAttempted - 1;
                  });
                } else {
                  setState(() {
                    optionSelected = widget.questionModel.option4;
                    widget.questionModel.answered = true;
                    _incorrect = _incorrect + 1;
                    _notAttempted = _notAttempted - 1;
                  });
                }
              }
            },
            child: OptionTile(
              option: "D",
              description: widget.questionModel.option4,
              correctAnswer: widget.questionModel.correctOption,
              optionSelected: optionSelected,
            ),
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
