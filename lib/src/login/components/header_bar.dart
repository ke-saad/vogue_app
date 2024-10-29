import 'package:flutter/material.dart';

class HeaderBar extends StatelessWidget {
  const HeaderBar({super.key});

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.fromLTRB(w * 0.1, 5.0, w * 0.1, 0.0),
      height: h * 0.075,
      color: const Color.fromARGB(255, 243, 33, 33),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Vogue App',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: w * 0.075,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 2
                ..color = Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
