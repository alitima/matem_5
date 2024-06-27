import 'package:flutter/material.dart';
import 'package:math_test/controllers/test_widget_controller.dart';
import 'package:math_test/controllers/test_widget_state.dart';
import 'package:math_test/models/question_answers_model.dart';

class TestWidget extends StatefulWidget {
  const TestWidget({super.key});

  @override
  State<TestWidget> createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> {
  late final TestWidgetController controller;

  @override
  void initState() {
    super.initState();

    controller = TestWidgetController()..init();
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<TestWidgetState>(
      stream: controller.stream,
      builder: (context, snapshot) {
        final state = snapshot.data;

        if (state == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return switch (state) {
          TestQuestionState(:final model) => _buildQuestion(model),
          TestResultState(:final points) => _buildResult(points),
        };
      },
    );
  }

  Column _buildQuestion(QuestionAnswersModel model) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Center(
              child: SingleChildScrollView(
                child: Text(
                  model.name,
                  style: const TextStyle(fontSize: 24),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            3,
            (index) {
              final answerOption = model.answerOptions[index];
              return GestureDetector(
                onTap: () {
                  final isCorrect = model.correctAnswerIndex == index;
                  controller.addAnswer(isCorrect);

                  showDialog(
                    context: context,
                    builder: (context) {
                      return Icon(
                        isCorrect ? Icons.done : Icons.close,
                        color: isCorrect ? Colors.green : Colors.red,
                        size: 100,
                      );
                    },
                  ).whenComplete(controller.getRandomQuestion);

                  Future.delayed(const Duration(seconds: 1), () {
                    final currentRoutePath =
                        ModalRoute.of(context)?.settings.name;
                    if (currentRoutePath != null) {
                      Navigator.popUntil(
                        context,
                        ModalRoute.withName(currentRoutePath),
                      );
                    }
                  });
                },
                child: Card(
                  color: Colors.blueAccent,
                  child: SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Center(
                        child: Text(
                          answerOption,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Column _buildResult(int points) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Результат: $points из 10',
          style: const TextStyle(fontSize: 20),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            controller
              ..reset()
              ..getRandomQuestion();
          },
          child: const Text(
            'Начать заново',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}
