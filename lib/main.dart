import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const WordleHome(),
    );
  }
}

class WordleHome extends StatefulWidget {
  const WordleHome({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return WordleState();
  }
}

class WordleState extends State<WordleHome> {
  // List of words to use...
  var words = ["about", "acute", "admit"];
  var random = Random();
  var chosenWord = "";
  var titleWord = "Play Now!";
  var titleWordList = [];
  var wordList = [];
  var userController = TextEditingController();
  var guessed = false;
  var gameOver = false;
  var guesses = [];

  WordleState() {
    chosenWord = words[random.nextInt(words.length)];
    titleWord = titleWord.toUpperCase();
    // for (var i = 0; i < chosenWord.length; i++) {
    //   wordList.add(chosenWord.substring(i, i + 1).toString());
    // }
    // for (var i = 0; i < titleWord.length; i++) {
    //   titleWordList.add(titleWord.substring(i, i + 1).toString());
    // }
  }

  resetGame() {
    chosenWord = words[random.nextInt(words.length)];
    setState(() {
      gameOver = false;
      guessed = false;
      gameOver = false;
      guesses = [];
    });
  }

  guessWord() {
    if (userController.text.length == chosenWord.length && guesses.length < 5) {
      if (userController.text.toString().compareTo(chosenWord) == 0) {
        guessed = true;
      } else {
        guessed = false;
      }
      guesses.add(userController.text);
      setState(() {}); // Can call setState() like this
    }
    if (guesses.length >= 5 && guessed == false) {
      // The user ran out of guesses, and did not guess the word
      gameOver = true;
      // Show button to reset game...
    }
    else if(guesses.length < 5 && guessed == true){
      gameOver = true;
    }
  }

  constructGrid() {
    // Column for each of the guesses...
    // Column col = Column();
    // NOTE: cannot dynamically add children, must be a predefined list
    List<Widget> colList = [];
    // For each of the guesses the user has made
    for (var i = 0; i < guesses.length; i++) {
      // Row row = Row();
      List<Widget> rowList = [];
      // Get the current guessed word
      var currGuess = guesses[i];
      // Check letter by letter in the word for the guess
      for (var j = 0; j < currGuess.length; j++) {
        var currLetter = currGuess.substring(j, j + 1);
        Color c;
        var inWord = false;
        for (var z = 0; z < chosenWord.length; z++) {
          if (chosenWord.substring(z, z + 1).compareTo(currLetter) == 0) {
            inWord = true;
          }
        }
        // Check to see if current letter is in correct position
        if (currLetter.compareTo(chosenWord.substring(j, j + 1)) == 0) {
          // Then correct letter in the correct place
          c = Colors.lightBlueAccent;
        }
        // If the current letter guessed is in the word, not correct location
        else if (inWord) {
          c = Colors.yellowAccent;
        } else {
          c = Colors.black;
        }
        // Create the widget for the letter
        final Widget letterWidget = Expanded(
          child: Container(
            child: Center(
                child: Text(
              currLetter,
              style: const TextStyle(fontSize: 24, color: Colors.white),
            )),
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(5),
            // color: c,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: c,
            ),
          ),
        );
        rowList.add(letterWidget);
      }
      Row r = Row(children: rowList);
      colList.add(r);
    }
    Column col = Column(children: colList);
    return col;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Container(
            child: const Center(
              child: Text(
                "Wordle",
                style: TextStyle(fontSize: 40, color: Colors.white),
              ),
            ),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Colors.lightBlueAccent),
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            height: 100,
          ),
          Row(
            children: [
              for (var letter in titleWordList)
                Expanded(
                  child: Container(
                    child: Center(
                      child: Text(
                        letter,
                        style: const TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.lightBlueAccent,
                    ),
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.all(5),
                    width: 50,
                    height: 50,
                  ),
                )
            ],
          ),
          Row(
            children: [
              // NOTE always start with expanded and then fill with container
              // not the other way around...
              Expanded(
                child: Container(
                  child: TextField(
                    controller: userController,
                  ),
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                ),
                flex: 3,
              ),
              Expanded(
                flex: 1,
                child: Container(
                  margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                  child: ElevatedButton(
                    onPressed: guessWord,
                    child: const Center(
                        child: Text(
                      "Guess",
                      style: TextStyle(fontSize: 25),
                    )),
                  ),
                ),
              )
            ],
          ),
          constructGrid(),
          gameOver
              ? Expanded(
                  child: Center(
                    child: ElevatedButton(
                    onPressed: resetGame,
                    child: const Text("Play again!", style: TextStyle(fontSize: 30)),
                ),
                  ))
              : Container()
        ],
      ),
    );
  }
}
