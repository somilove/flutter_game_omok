import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:omok/controller/variables.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:omok/models/users_play_model.dart';
import 'dart:convert';
import 'package:omok/widgets/button_start.dart';

import '../database/database.dart';

// json data encode, decode
// encoding : Map형식의 데이터를 문자열로 변환
// decoding : JSON문자열(서버에서 전송된 데이터)을 Map 타입으로 변환

class UsersPlayController extends GetxController {
  WebSocketChannel? _channel;
  late UsersPlayModel? usersPlayData;
  final VariablesController controller = Get.find();



  Future<void> connect(context) async {
    print(_channel);
    if (_channel != null) {
      return;
    }

    _channel = WebSocketChannel.connect(
      Uri.parse('ws://43.203.34.6:3000/ws/omok'),
    );
    StreamSubscription subscription = await _channel!.stream.listen(print);
    //channel!.stream.listen((data) => print(data)); 와 동일

    //onData() : 스트림에서 데이터가 생길때마다 실행
    subscription.onData((jsonData) async {
      Map<String, dynamic?> map = jsonDecode(jsonData);
      if (map.containsKey('Matched')) {
        usersPlayData = UsersPlayModel.fromJson(map['Matched']);
        (usersPlayData!.step == 0 //데이가 업데이트될때까지 어떻게 기다릴지 ?
                &&
                usersPlayData!.isTurn == true)
            ? controller.v_youStone.value = 'b'
            : controller.v_youStone.value = 'w';
        controller.v_down.value = 'b';
        await StartButton().dialogBuilder(context);
        controller.v_flagButtonPlay.value = false;
        controller.v_isAiPlay.value = false;
        // update();
      } else if (map.containsKey('NextTurn')) {
        usersPlayData = UsersPlayModel.fromJson(map['NextTurn']);
        controller.v_listBox.value[usersPlayData!.x!][usersPlayData!.y!] =
            controller.v_down.value;
        controller.v_downCount.value++;
        controller.v_listBox_count.value[usersPlayData!.x!][usersPlayData!.y!] =
            'O'; //v_downCount.toString(); //마지막 수에 O을 표시
        controller.v_listBox_count.value[controller.v_x_count.value]
            [controller.v_y_count.value] = ''; //수순표시(이전버튼)
        controller.v_x_count.value = usersPlayData!.y!; //마지막 수의 위치를 저장
        controller.v_y_count.value = usersPlayData!.y!; //마지막 수의 위치를 저장
        (controller.v_down.value == 'b')
            ? controller.v_down.value = 'w'
            : controller.v_down.value = 'b';
        // update();
      } else {
        //"result"
        usersPlayData = UsersPlayModel.fromJson(map['Result']);
        switch (usersPlayData!.result) {
          case 'defeat':
            print('패배입니다');
            usersPlayData = UsersPlayModel.fromJson(map['Result']);
            controller.v_listBox.value[usersPlayData!.x!][usersPlayData!.y!] =
                controller.v_down.value;
            controller.v_downCount.value++;
            controller.v_listBox_count.value[usersPlayData!.x!]
                    [usersPlayData!.y!] =
                'O'; //v_downCount.toString(); //마지막 수에 O을 표시
            controller.v_listBox_count.value[controller.v_x_count.value]
                [controller.v_y_count.value] = ''; //수순표시(이전버튼)
            controller.v_flagButtonPlay.value = true;
            EasyLoading.instance.fontSize = 24;
            EasyLoading.instance.displayDuration =
                const Duration(milliseconds: 2000);
            EasyLoading.showToast(' *** You Lose *** ');
            controller.v_defeat.value++;
            (controller.v_downCount.value < 20)
                ? controller.v_score.value = controller.v_score.value - 20
                : controller.v_score.value = controller.v_score.value - 10;
            DatabaseHelper.insert();
            closeConnection();
            break;
          case 'win':
            print('승리입니다 : 상대방 기권');
              controller.v_listBox_count.value[controller.v_x_count.value]
              [controller.v_y_count.value] = ''; //수순표시(이전버튼)
            controller.v_flagButtonPlay.value = true;
            EasyLoading.instance.fontSize = 24;
            EasyLoading.instance.displayDuration =
                const Duration(milliseconds: 2000);
            EasyLoading.showToast(' *** You Win *** ');
            controller.v_win.value++;
            (controller.v_downCount.value < 20)
                ? controller.v_score.value = controller.v_score.value + 30
                : controller.v_score.value = controller.v_score.value + 20;
            DatabaseHelper.insert();
            closeConnection();
            break;

          case 'tie':
            print('무승부입니다');
            controller.v_listBox.value[usersPlayData!.x!][usersPlayData!.y!] =
                controller.v_down.value;
            controller.v_downCount.value++;
            controller.v_listBox_count.value[usersPlayData!.x!]
                    [usersPlayData!.y!] =
                'O'; //v_downCount.toString(); //마지막 수에 O을 표시
            controller.v_listBox_count.value[controller.v_x_count.value]
                [controller.v_y_count.value] = ''; //수순표시(이전버튼)
            controller.v_flagButtonPlay.value = true;
            EasyLoading.instance.fontSize = 24;
            EasyLoading.instance.displayDuration =
                const Duration(milliseconds: 2000);
            EasyLoading.showToast(' *** 무승부 *** ');
            controller.v_tie.value++;
            controller.v_score.value = controller.v_score.value + 10;
            DatabaseHelper.insert();
            closeConnection();
            break;
        }
        // update();
      }
    });

    subscription.onError((error) {
      print('value : $error');
    });

    //데이터 발생이 끝났을 때(연결이 끊겼을때)
    subscription.onDone(() {
      print('stream done...');
    });
  }

  void sendMessage({required UsersPlayModel data}) {
    final result = jsonEncode({"NextTurn": data});
    print('result');
    _channel!.sink.add(result);
  }

  void closeConnection() async {
    print(_channel);
    //기권하는 경우
    if(_channel != null) {
      await _channel!.sink.close();
      _channel = null;
      print('연결 종료');
    }
  }
}
