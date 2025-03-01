import 'package:flutter/material.dart';
import 'package:omok/controller/users_play_controller.dart';
import 'package:omok/controller/variables.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:omok/database/database.dart';
import 'package:omok/widgets/audio_player.dart';

class StopButton extends StatelessWidget {
  final UsersPlayController usersController = Get.find();
  final VariablesController controller = Get.find();

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
                Colors.white,
                Colors.black87,
              ]
          )
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          // foregroundColor: Colors.transparent,
          backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            )
        ),
        onPressed: () async {
          if (controller.v_flagButtonPlay.value == false) {
            if(controller.v_volumn.value == true) audioPlayer('asset/audio/select.ogg');
            await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    // title: const Text('Alert',
                    //     style: TextStyle(color: Colors.pink, fontSize: 15)),
                    content: const Text('기권하시겠습니까?', style: TextStyle(fontSize: 20),),
                    actions: <Widget>[
                      TextButton(
                          onPressed: () {
                            step_end_play();
                            Navigator.of(context).pop();},
                          child: const Text('예', style: TextStyle(fontSize: 16))),
                      TextButton(
                          onPressed: () {
                            if(controller.v_volumn.value == true) audioPlayer('asset/audio/select.ogg');
                                                                                                           Navigator.of(context).pop();},
                          child: const Text('아니오', style: TextStyle(fontSize: 16))),
                    ],
                  );
                });
          } else {
            if(controller.v_volumn.value == true) audioPlayer('asset/audio/error.mp3');
            EasyLoading.instance.fontSize = 16;
            EasyLoading.instance.displayDuration = const Duration(milliseconds: 500);
            EasyLoading.showToast('게임을 먼저 진행해주세요');
          }
        },
        child: const Text('기권',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.white,
              fontSize: 18),),
      ),
    );
  }

  //기권버튼 이벤트
  void step_end_play() {
    controller.v_flagButtonPlay.value = true;
    EasyLoading.instance.fontSize = 24;
    EasyLoading.instance.displayDuration = const Duration(milliseconds: 2000);
    EasyLoading.showToast('You Lose\n기권 패',);
    if(controller.v_volumn.value == true) audioPlayer('asset/audio/lose.mp3');
    controller.v_defeat.value++;
    (controller.v_downCount.value < 20) ? controller.v_score.value = controller.v_score.value - 10 : controller.v_score.value = controller.v_score.value - 5;
    if(controller.v_isAiPlay.value == false) {
      usersController.closeConnection();
    }
    controller.refresh();
    DatabaseHelper.insert();
  }
}