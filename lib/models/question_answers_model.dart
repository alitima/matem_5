final class QuestionAnswersModel {
  const QuestionAnswersModel({
    required this.name,
    required this.answerOptions,
    required this.correctAnswerIndex,
  });

  factory QuestionAnswersModel.fromJson(Map<String, dynamic> json) {
    return QuestionAnswersModel(
      name: json['question'],
      answerOptions: (json['answers'] as List).cast(),
      correctAnswerIndex: json['correct_answer_index'],
    );
  }

  final String name;
  final List<String> answerOptions;
  final int correctAnswerIndex;
}
