import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:omok/controller/variables.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:omok/models/users_play_model.dart';
import 'dart:convert';
// json data encode, decode
// encoding : Map형식의 데이터를 문자열로 변환
// decoding : JSON문자열(서버에서 전송된 데이터)을 Map 타입으로 변환

class UsersPlayController extends GetxController {
  late final WebSocketChannel? channel;
  late final UsersPlayModel? usersPlayData;
  final VariablesController controller = Get.find();


  @override
  void onInit() async {
    super.onInit();
  }

  @override
  void dispose() {
    channel!.sink.close();
    super.dispose();
  }


  Future<void> connect() async {


    channel = WebSocketChannel.connect(
      Uri.parse('ws://43.203.34.6:3000/ws/omok'),
    );
    StreamSubscription subscription = await channel!.stream.listen(print);
    //channel!.stream.listen((data) => print(data)); 와 동일

    //onData() : 스트림에서 데이터가 생길때마다 실행
    subscription.onData((jsonData) {
      Map<String, dynamic> map = jsonDecode(jsonData);
      if (map.containsKey('matched')) {
        usersPlayData = UsersPlayModel.fromJson(map['matched']);
        update();
      } else if (map.containsKey('NextTurn')) {
        usersPlayData = UsersPlayModel.fromJson(map['NextTurn']);
        update();
      } else { //"result"
        usersPlayData = UsersPlayModel.fromJson(map['result']);
        update();
      }
    });

    subscription.onError((error) {
      print('value : $error');
    });

    //데이터 발생이 끝났을 때
    subscription.onDone(() {
      print('stream done...');
    });
  }
}