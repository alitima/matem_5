import 'package:math_test/models/question_answers_model.dart';

sealed class TestWidgetState {
  const TestWidgetState();
}

final class TestQuestionState extends TestWidgetState {
  const TestQuestionState(this.model);

  final QuestionAnswersModel model;
}

final class TestResultState extends TestWidgetState {
  const TestResultState(this.points);

  final int points;
}
