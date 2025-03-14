import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; //가로 세로 회전 기능
import 'package:omok/controller/users_play_controller.dart';
import 'package:omok/widgets/audio_player.dart';
import 'screens/omokList.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart'; //팝업 메시지_토스트
import 'package:omok/controller/variables.dart';
import 'package:get/get.dart';
import 'package:omok/database/database.dart';
import 'package:omok/widgets/game_board.dart';
import 'package:omok/widgets/button_start.dart';
import 'package:omok/widgets/button_stop.dart';
import 'package:omok/widgets/display_score.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
  configLoading();
}

//여러 default 파라미터 값 설정
void configLoading() {
  EasyLoading.instance
    //메시지 실행 시 재설정
    ..displayDuration = const Duration(milliseconds: 1000) //토스트 메시지 유지시간
    ..fontSize = 16.0 //폰트크기
    ..toastPosition = EasyLoadingToastPosition.center //배치위치
    //고정 설정
    ..loadingStyle = EasyLoadingStyle.dark //배경색상
    ..radius = 30.0;
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp]); //세로 고정
    Future<Database> database = DatabaseHelper
        .initDatabase(); //실행결과를 future로 받아 database에 값이 넘어온 후에 사용가능하도록 함
    Get.put(VariablesController()); //Get.put을 통해 컨트롤러 주입
    Get.put(UsersPlayController());

    return GetMaterialApp(
      title: 'AI Omok',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {'/omokList': (context) => OmokListApp(database)},
      home: Container(color: Colors.white, child: DatabaseApp(database)),
      builder: EasyLoading.init(),
    );
  }
}

class DatabaseApp extends StatefulWidget {
  final Future<Database> db; //final로 선언시 db를 실행중에 설정되는 상수로 만들어준다
  DatabaseApp(this.db);

  @override
  State<StatefulWidget> createState() => _DatabaseApp();
}

class _DatabaseApp extends State<DatabaseApp> {
  final VariablesController controller = Get.find();
  //부모위젯에서 Get.put해준적 있다면 Get.find로 컨트롤러 불러올 수 있음

  late int i; //루프용
  late int j; //루프용
  late int ii; //루프용
  late int jj; //루프용

  @override
  void dispose() {
    player.stop();
    player.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    step_initial();
  }

  //게임판 초기화
  void step_initial() {
    controller.v_downCount.value = 0; //현재 수순을 0으로 초기화
    for (i = 0; i < controller.v_rowBox.value; i++) {
      for (j = 0; j < controller.v_colBox.value; j++) {
        controller.v_listBox.value[i][j] =
            'n'; //반복문을 사용해 게임판의 중간 컨테이너인 돌 이미지를 투명으로,
        controller.v_listBox_count.value[i][j] =
            ''; //또 맨 위 컨테이너의 버튼 텍스트 값을 빈칸(null)으로 초기화
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetX<VariablesController>(
      init: VariablesController(),
      builder: (controller) => Scaffold(
        backgroundColor: Colors.transparent,
        //백그라운드를 투명하게 만듦
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'OMOK LOVER',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white, fontSize: 23),
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xff293859),
                      Color(0xff00194f),
                    ]
                )
            ),
          ),
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(color: Color(0xffbde2ff)),
          actions: [
            //음악소리 on/off 버튼
            if (controller.v_volumn.value == true)
              IconButton(
                  onPressed: () {
                    if (controller.v_volumn.value == true) {
                      controller.v_volumn.value = false;
                    } else {
                      controller.v_volumn.value = true;
                    }
                  },
                  icon: const Icon(Icons.volume_mute)),
            if (controller.v_volumn.value == false)
              IconButton(
                  onPressed: () {
                    if (controller.v_volumn.value == true) {
                      controller.v_volumn.value = false;
                    } else {
                      controller.v_volumn.value = true;
                    }
                  },
                  icon: const Icon(Icons.volume_off)),

            //결과 화면으로 이동하는 버튼
            TextButton(
                onPressed: () {
                  if (controller.v_flagButtonPlay.value == true) {
                    Navigator.of(context)
                        .pushNamed('/omokList', arguments: widget.db);
                  } else {
                    EasyLoading.instance.fontSize = 16;
                    EasyLoading.instance.displayDuration =
                        const Duration(milliseconds: 500);
                    EasyLoading.showToast('게임이 진행중입니다');
                    if(controller.v_volumn.value == true) audioPlayer('asset/audio/error.mp3');
                  }
                },
                child: const Text(
                  'Log',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xffbde2ff)),
                ))
          ],
        ),
        body:
            //body 상단, 바둑판 배경이미지
            Column(children: [
          //오목 게임판 & 돌
          GameBoard(),
          //body 하단
          Expanded(
            flex: 1,
            child: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                    Color(0xffbde2ff),
                    Color(0xff0091ff),
                  ])),
              // color: Colors.lightBlue[100],
              child: Column(
                children: [
                  //하단 위
                  Expanded(
                    flex: 1,
                    child: Container(
                      color: Colors.black12,
                      padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          //3 body 하단 텍스트 (YOU)
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black87.withOpacity(0.2),
                                            spreadRadius: 2,
                                            blurRadius: 4,
                                            offset: const Offset(0, 3),
                                          )
                                        ],
                                        gradient: const LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              Color(0xffcce9ff),
                                              Color(0xff72bffc),
                                            ]),
                                        border: Border.all(
                                            color: Colors.white, width: 1),
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    alignment: Alignment.center,
                                    child: const Text(
                                      'YOU',
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                                // Divider(color: Colors.black,),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.all(2),
                                    alignment: Alignment.center,
                                    child: Image.asset(
                                      'asset/image/${controller.v_youStone.value}.png',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // const VerticalDivider(
                          //   color: Colors.black,
                          // ),
                          const SizedBox(
                            width: 3,
                          ),
                          //3 body 하단 텍스트(현재 수순)
                          Expanded(
                            child: Container(
                              // color: Colors.green,
                              child: Column(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                              Colors.black87.withOpacity(0.2),
                                              spreadRadius: 2,
                                              blurRadius: 4,
                                              offset: const Offset(0, 3),
                                            )
                                          ],
                                          gradient: const LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                Color(0xffcce9ff),
                                                Color(0xff72bffc),
                                              ]),
                                          border: Border.all(
                                              color: Colors.white, width: 1),
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      alignment: Alignment.center,
                                      child: const Text(
                                        '수순',
                                        style: TextStyle(
                                          color: Colors.black87,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                    ),
                                  ),
                                  // Divider(color: Colors.black,),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      // margin: const EdgeInsets.fromLTRB(
                                      //     0, 5, 0, 0),
                                      alignment: Alignment.center,
                                      child: Text(
                                        controller.v_downCount.value.toString(),
                                        style: const TextStyle(
                                            color: Colors.black87,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 3,
                          ),
                          Expanded(
                              flex: 3,
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Container(
                                      // margin: const EdgeInsets.all(5),
                                      child: Row(
                                        // crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: StartButton(
                                              step_initial: step_initial,
                                              label: '매칭\n하기',
                                              aiPlay: false,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 3,
                                          ),
                                          //3 body 하단 버튼 게임시작
                                          Expanded(
                                            flex: 1,
                                            child: StartButton(
                                              step_initial: step_initial,
                                              label: '연습\n하기',
                                              aiPlay: true,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              )),
                          const SizedBox(
                            width: 3,
                          ),
                          //3 body 하단 버튼 기권
                          Expanded(
                            flex: 1,
                            child: StopButton(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  //하단 아래
                  Expanded(flex: 1, child: DisplayScore()),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
