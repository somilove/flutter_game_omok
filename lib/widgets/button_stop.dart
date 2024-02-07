import 'package:flutter/material.dart';
import 'package:omok/variable/variables.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:omok/database/database.dart';

class StopButton extends StatelessWidget {
  final VariablesController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.yellow,
      margin: const EdgeInsets.fromLTRB(5, 0, 0, 0),
      child: TextButton(
        child: const Text('기권',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24),),
        style: TextButton.styleFrom(
            minimumSize: Size.infinite,
            foregroundColor: Colors.black,
            backgroundColor: Colors.green[700]),
        onPressed: () async {
          if (controller.v_flagButtonPlay.value == false) {
            await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Alert',
                        style: TextStyle(color: Colors.pink, fontSize: 15)),
                    content: Text('기권하시겠습니까?'),
                    actions: <Widget>[
                      TextButton(
                          onPressed: () {
                            step_end_play();
                            Navigator.of(context).pop();},
                          child: const Text('아니오')),
                    ],
                  );
                });
          } else {
            EasyLoading.instance.fontSize = 16;
            EasyLoading.instance.displayDuration = const Duration(milliseconds: 500);
            EasyLoading.showToast(' *** Not executed! ***');
          }
        },
      ),);
  }

  //기권버튼 이벤트
  void step_end_play() {
    controller.v_flagButtonPlay.value == true;
    EasyLoading.instance.fontSize = 24;
    EasyLoading.instance.displayDuration = const Duration(milliseconds: 2000);
    EasyLoading.showToast(' *** 기권 패 ***',);

    controller.v_defeat.value++;
    (controller.v_downCount.value < 20) ? controller.v_score.value = controller.v_score.value - 10 : controller.v_score.value = controller.v_score.value - 5;
    // setState(() {});
    DatabaseHelper.insert();
  }
}