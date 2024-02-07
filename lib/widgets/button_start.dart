import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:omok/variable/variables.dart';
import 'package:get/get.dart';
import 'package:omok/main.dart';
import 'package:sqflite/sqflite.dart';

class StartButton extends StatelessWidget {
  final VariablesController controller = Get.find();
  late final Function step_initial;
  StartButton(this.step_initial);

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.pink,
        margin: const EdgeInsets.fromLTRB(
            5, 0, 0, 0),
        child: TextButton(
          style: TextButton.styleFrom(
              minimumSize: Size.infinite,
              //글자크기영역이 24보다 작게되면 컨테이너의 최대 영역으로 설정
              foregroundColor: Colors.black,
              backgroundColor: Colors.green[700]),
          onPressed: () async {
            if (controller.v_flagButtonPlay.value == true) {
              step_initial();
              (controller.v_youStone.value == 'b')
                  ? controller.v_youStone.value = 'w'
                  : controller.v_youStone.value = 'b'; //게이머의 돌
              await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(controller.v_youStone.value == 'w'
                          ? '게이머는 백으로 후수입니다'
                          : '게이머는 흑으로 선공합니다'),
                      actions: <Widget>[
                        TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pop();
                            },
                            child: const Text(
                                '확인')),
                      ],
                    );
                  });
              if (controller.v_flagButtonPlay.value == true) {
                press_play();
              }
            } else {
              EasyLoading.instance.fontSize = 16;
              EasyLoading.instance.displayDuration =
              const Duration(milliseconds: 500);
              EasyLoading.showToast(
                  ' *** Not executed! ***');
            }
          },
          child: const Text('연습\n게임',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24),),
        )
    );
  }

  //이벤트 - 게임시작 버튼을 누르면
  void press_play() {
    controller.v_flagButtonPlay.value = false; //false버튼 못누름, 게임중
    //게이머의 돌이 백이면 AI가 먼저 둠
    if (controller.v_youStone.value == 'w') {
      controller.v_listBox.value[7][7] = 'b';
      controller.v_aiStone.value = 'b';
      controller.v_downCount.value++;
      controller.v_x_count.value = 7;
      controller.v_y_count.value = 7;
      controller.v_down.value = 'w';
    } else {
      controller.v_down.value = 'b';
      controller.v_aiStone.value = 'w';
    }
    // setState(() {});
  }
}