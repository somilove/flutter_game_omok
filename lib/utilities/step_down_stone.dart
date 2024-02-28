import 'package:omok/controller/users_play_controller.dart';
import 'package:omok/controller/variables.dart';
import 'package:get/get.dart';
import 'package:omok/models/users_play_model.dart';
import 'package:omok/utilities/step_down_stone_ai.dart';
import 'package:omok/utilities/step_check.dart';
import 'dart:async'; //타이머


  final VariablesController controller = Get.find();
  final UsersPlayController usersController = Get.find();
  
  //게임판을 누르면 바둑판에 돌을 놓기
  void step_downStone(x, y) async {
    if (controller.v_flagButtonPlay.value == true) return; //게임중이 아니라면 종료
    //돌을 놓았으니 게임판에 표시하고 다음에 놓을 돌을 결정함
    if (controller.v_listBox.value[x][y] == 'n') { //돌을 놓을 수 있는 위치인지 확인
      controller.v_listBox.value[x][y] = controller.v_down.value; //흑돌 or 백돌
      controller.v_downCount.value++;
      controller.v_listBox_count.value[x][y] = 'O'; //v_downCount.toString(); //마지막 수에 O을 표시
      controller.v_listBox_count.value[controller.v_x_count.value][controller.v_y_count.value] = ''; //수순표시(이전버튼)
      controller.v_x_count.value = x; //마지막 수의 위치를 저장 (by gamer or AI)
      controller.v_y_count.value = y; //마지막 수의 위치를 저장 (by gamer or AI)
      // setState(() {});
      // if(controller.v_volumn.value == true) audioPlayer()
    } else {return;}
    //돌을 놓았으니 끝날 조건인지 체크
    step_check(); //게임 끝낫는데 aiPlay 아닐때 웹소켓에 결과통보로직 추가
    if (controller.v_flagButtonPlay.value == true ) return; //게임이 끝났으면 종료
    (controller.v_down.value == 'b') ? controller.v_down.value = 'w' : controller.v_down.value = 'b'; //돌을 놓았으니 다음 놓을 돌 v_down 변경
    controller.v_x_previous.value = x; //이전 착수한 변수(by gamer) => 방굼 둔 돌의 위치로 저장 => AI 최적수 찾기와 체크로직에서 사용할 변수
    controller.v_y_previous.value = y; //이전 착수한 변수(by gamer) => 방굼 둔 돌의 위치로 저장 => AI 최적수 찾기와 체크로직에서 사용할 변수

    //AI 착수 1초 지연시키기
    if(controller.v_isAiPlay.value) {
      controller.v_x_AI.value =  13; //AI 착수 행 초기화
      controller.v_y_AI.value = 13; //AI 착수 열 초기화
      await Timer(Duration(seconds: 1), () {
        //AI가 돌을 놓고 끝날 조건 체크
        step_downStone_AI(); //AI 착수 실행
        controller.v_downCount.value++;
        controller.v_listBox_count.value[controller.v_x_AI.value][controller.v_y_AI.value] = 'O'; //v_downCount.toString(); //수순표시 => AI가  착수한 버튼의 텍스트에 'O'를
        controller.v_listBox_count.value[controller.v_x_count.value][controller.v_y_count.value] = ''; //수순표시 => 이전 버튼의 텍스트에 ''을 넣어줌
        controller.v_x_count.value = controller.v_x_AI.value; //마지막 AI 수의 위치 저장
        controller.v_y_count.value = controller.v_y_AI.value; //마지막 AI 수의 위치 저장
        // setState(() {}); //화면을 갱신하고
        step_check();
        (controller.v_down.value == 'b') ? controller.v_down.value = 'w' : controller.v_down.value = 'b'; //다음 놓을 돌 변경
      });
    } else { //aiPlay 아닐 경우
      //소켓에 xy보내기
      final data = UsersPlayModel(
        roomId: usersController.usersPlayData!.roomId,
        x: controller.v_x_count.value,
        y: controller.v_y_count.value,
      );
      usersController.sendMessage(data: data);
    }

  }



