import 'package:omok/controller/users_play_controller.dart';
import 'package:omok/controller/variables.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:omok/models/users_play_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:omok/main.dart';
import 'package:omok/database/database.dart';

import '../widgets/audio_player.dart';

final VariablesController controller = Get.find();
final UsersPlayController usersController = Get.find();
late int i; //루프용
late int j; //루프용
late int ii; //루프용
late int jj; //루프용

void step_check() {
  if (controller.v_downCount.value < 9) return;
  step_check_5(); //체크하기(행 5조건 체크)
  if (controller.v_flagButtonPlay.value == true) return;
  step_check_downCount(); //체크하기 (무승부 조건 체크)
}

//체크하기(행5 조건 체크)
void step_check_5() {
  step_check_row();
  if (controller.v_flagButtonPlay.value == false) step_check_col();
  if (controller.v_flagButtonPlay.value == false) step_check_grd1();
  if (controller.v_flagButtonPlay.value == false) step_check_grd2();
  if (controller.v_flagButtonPlay.value == false) return;

  if(controller.v_isAiPlay == false) {
    final data = UsersPlayModel(
      roomId: usersController.usersPlayData!.roomId,
      x: controller.v_x_count.value,
      y: controller.v_y_count.value,
      result: 'defeat',
    );
    usersController.sendMessage(data: data);
  }
  EasyLoading.instance.fontSize = 24;
  EasyLoading.instance.displayDuration = const Duration(milliseconds: 2000);
  EasyLoading.showToast((controller.v_down.value == controller.v_youStone.value ? ' *** You Win *** ' : ' *** You Lose *** '),);

  if (controller.v_down.value == controller.v_youStone.value) {
    if(controller.v_volumn.value == true) audioPlayer('asset/audio/win.mp3');
    controller.v_win.value++;
    (controller.v_downCount.value < 20) ? controller.v_score.value = controller.v_score.value + 30 : controller.v_score.value = controller.v_score.value + 20;
  } else {
    if(controller.v_volumn.value == true) audioPlayer('asset/audio/lose.mp3');
    controller.v_defeat.value++;
    (controller.v_downCount.value < 20) ? controller.v_score.value = controller.v_score.value - 20 : controller.v_score.value = controller.v_score.value - 10;
  }
  DatabaseHelper.insert();
}

//체크하기(무승부 조건 체크)
void step_check_downCount() {
  if (controller.v_downCount.value < 120) return; //120수보다 크거나 같으면 무승부
  controller.v_flagButtonPlay.value = true;

  if(controller.v_isAiPlay == false) {
    final data = UsersPlayModel(
      roomId: usersController.usersPlayData!.roomId,
      x: controller.v_x_count.value,
      y: controller.v_y_count.value,
      result: 'tie',
    );
    usersController.sendMessage(data: data);
  }


  EasyLoading.instance.fontSize = 24;
  EasyLoading.instance.displayDuration = const Duration(milliseconds: 2000);
  EasyLoading.showToast(' *** 무승부 *** ');

  controller.v_tie.value++;
  controller.v_score.value = controller.v_score.value + 10;
  DatabaseHelper.insert();
}

//체크하기(행5 조건 체크)
void step_check_row() {
  for ( i = 0; i < controller.v_rowBox.value; i++) {
    for ( j = 0; j <= controller.v_colBox.value - 5; j++) {
      int _v_count = 0;
      for( jj = 0; jj < 5; jj++) {
        if (controller.v_listBox.value[i][j + jj] != controller.v_down.value) break;
        _v_count++;
      }
      if (_v_count == 5) {
        controller.v_flagButtonPlay.value = true;
        return;
      }
    }
  }
}

//체크하기(열5 조건 체크)
void step_check_col() {
  for ( j = 0; j < controller.v_colBox.value; j++ ) {
    for( i = 0; i <= controller.v_rowBox.value - 5; i++ ) {
      int _v_count = 0;
      for ( ii = 0; ii < 5; ii++ ) {
        if (controller.v_listBox.value[i + ii][j] != controller.v_down.value) break;
        _v_count++;
      }
      if (_v_count == 5) {
        controller.v_flagButtonPlay.value = true;
        return;
      }
    }
  }
}

//체크하기(대각선 우측 하향 5조건 체크
void step_check_grd1() {
  for ( i = 0; i <= controller.v_rowBox.value - 5; i++) {
    for ( j = 0; j <= controller.v_colBox.value - 5; j++) {
      int _v_count = 0; //동일한 수
      for(jj = 0; jj < 5; jj++) {
        if ( controller.v_listBox.value[i + jj][j + jj] != controller.v_down.value) break;
        _v_count++;
      }
      if (_v_count == 5) {
        controller.v_flagButtonPlay.value = true;
        return;
      }
    }
  }
}

//체크하기(대각선 우축 상향 5조건 체크)
void step_check_grd2() {
  for ( i = 4; i < controller.v_rowBox.value; i++) {
    for ( j = 0; j <= controller.v_colBox.value - 5; j++ ) {
      int _v_count = 0; //동일한 수
      for ( jj = 0; jj < 5; jj++) {
        if (controller.v_listBox.value[i - jj][j + jj] != controller.v_down.value) break;
        _v_count++;
      }
      if (_v_count == 5) {
        controller.v_flagButtonPlay.value = true;
        return;
      }
    }
  }
}

