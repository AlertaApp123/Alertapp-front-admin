import 'package:flutter/material.dart';
import 'package:alertapp_admin/core/styles/color_theme.dart';

class QuestionAnswerCard extends StatefulWidget {
  final String question;
  final String answer;
  const QuestionAnswerCard(
      {super.key, required this.answer, required this.question});

  @override
  State<QuestionAnswerCard> createState() => _QuestionAnswerCardState();
}

class _QuestionAnswerCardState extends State<QuestionAnswerCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _expanded = !_expanded;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              blurRadius: 5.0,
              offset: Offset(0, 4),
              color: Color.fromARGB(255, 198, 199, 204),
            ),
          ],
        ),
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.question,
                      style: const TextStyle(
                          color: ColorsTheme.pinkColor, fontSize: 14),
                      softWrap: true,
                    ),
                  ),
                  Icon(
                    !_expanded
                        ? Icons.keyboard_arrow_down_sharp
                        : Icons.keyboard_arrow_up_sharp,
                    color: ColorsTheme.redColor,
                    size: 30,
                  ),
                ],
              ),
              if (_expanded)
                Column(
                  children: [
                    const SizedBox(
                      width: 330,
                      child: Divider(
                        thickness: 1,
                        color: ColorsTheme.lightGreyColor,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.answer,
                      ),
                    ),
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }
}
