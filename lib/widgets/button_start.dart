import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:omok/controller/users_play_controller.dart';
import 'package:omok/controller/variables.dart';
import 'package:get/get.dart';
import 'package:omok/widgets/audio_player.dart';

class StartButton extends StatelessWidget {
  final VariablesController controller = Get.find();
  final UsersPlayController usersPlayController = Get.find();
  late final Function? step_initial;
  final String? label;
  final bool? aiPlay;

  StartButton({
    Key? key, this.step_initial, this.label, this.aiPlay}) :super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 4,
            offset: const Offset(0, 3),
          )
        ],
        borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xffbde2ff),
                Color(0xff0091ff),
              ]
          )
      ),
      child: ElevatedButton(
      style: ElevatedButton.styleFrom(

        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        )
      ),
      onPressed:  () async {
        if(controller.v_flagButtonPlay.value == true) {
              step_initial!();
              if(aiPlay == true) {
                  (controller.v_youStone.value == 'b')
                      ? controller.v_youStone.value = 'w'
                      : controller.v_youStone.value = 'b'; //게이머의 돌
                  await dialogBuilder(context);
                  controller.v_flagButtonPlay.value = false;
                  controller.v_isAiPlay.value = true;
                  press_play();
              } else {
                usersPlayController.connect(context);
              }
        } else {
          EasyLoading.instance.fontSize = 16;
          EasyLoading.instance.displayDuration =
          const Duration(milliseconds: 500);
          if(controller.v_volumn.value == true) audioPlayer('asset/audio/error.mp3');
          EasyLoading.showToast(
              ' *** Not executed! ***');
        }
      },
      child: Container(
        alignment: Alignment.center,
        child: Text(label!, style: const TextStyle(
              fontWeight: FontWeight.bold, color: Colors.white,
              fontSize: 18),),
      ),
              ),
    );
  }

  //이벤트 - 게임시작 버튼을 누르면
  void press_play() {
    //게이머의 돌이 백이면 AI가 먼저 둠
    if (controller.v_youStone.value == 'w') {
      controller.v_listBox.value[7][7] = 'b';
      if(controller.v_volumn.value == true) audioPlayer('asset/audio/stone.mp3');
      controller.v_aiStone.value = 'b';
      controller.v_downCount.value++;
      controller.v_x_count.value = 7;
      controller.v_y_count.value = 7;
      controller.v_down.value = 'w';
    } else {
      controller.v_down.value = 'b';
      controller.v_aiStone.value = 'w';
    }
  }

  Future<void> dialogBuilder(BuildContext context) {
    if(controller.v_volumn.value == true) audioPlayer('asset/audio/start.mp3');
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('대국을 시작합니다.',style: const TextStyle(fontSize: 18, ),),

            content:  Text(controller.v_youStone.value == 'w'
                ? 'YOU: 백돌, 후수입니다.'
                : 'YOU: 흑돌, 선수입니다.', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    if(controller.v_volumn.value == true) audioPlayer('asset/audio/select.ogg');
                    Navigator.of(context)
                        .pop();
                  },
                  child: const Text(
                      '확인')),
            ],
          );
        });
  }


}
