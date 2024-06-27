import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:math_test/constants/constants.dart';
import 'package:math_test/controllers/test_widget_state.dart';
import 'package:math_test/models/question_answers_model.dart';

final class TestWidgetController {
  Stream<TestWidgetState> get stream => _streamController.stream;

  late final StreamController<TestWidgetState> _streamController;

  late Iterable<QuestionAnswersModel> _models;
  int _attempts = 0;
  int _points = 0;

  Future<void> init() async {
    _streamController = StreamController();
    final text = await rootBundle.loadString(Constants.questionAnswersPath);
    final json = (jsonDecode(text) as List).cast<Map<String, dynamic>>();
    _models = json.map(QuestionAnswersModel.fromJson);
    getRandomQuestion();
  }

  Future<void> dispose() async {
    await _streamController.close();
  }

  void getRandomQuestion() {
    if (_attempts == 10) return;

    _streamController.add(TestQuestionState(
      _models.elementAt(Random().nextInt(_models.length)),
    ));
  }

  void addAnswer(bool isCorrect) {
    _attempts++;
    if (isCorrect) _points++;
    if (_attempts == 10) _streamController.add(TestResultState(_points));
  }

  void reset() {
    _attempts = 0;
    _points = 0;
  }
}
