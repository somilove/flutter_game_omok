import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; //가로 세로 회전 기능
import 'omokList.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:just_audio/just_audio.dart'; //소리 mp3
import 'package:flutter_easyloading/flutter_easyloading.dart'; //팝업 메시지_토스트
import 'package:url_launcher/url_launcher.dart'; //웹페이지 열기에 사용
import 'package:intl/intl.dart'; //달력
import 'package:omok/variable/variables.dart';
import 'package:get/get.dart';
import 'package:omok/database/database.dart';
import 'package:omok/widgets/game_board.dart';
import 'package:omok/widgets/button_start.dart';
import 'package:omok/widgets/button_stop.dart';
import 'package:omok/widgets/display_score.dart';

void main() {
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
    Future<Database> database =
    DatabaseHelper.initDatabase(); //실행결과를 future로 받아 database에 값이 넘어온 후에 사용가능하도록 함

    Get.put(VariablesController());


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
  late int i; //루프용
  late int j; //루프용
  late int ii; //루프용
  late int jj; //루프용

  @override
  void dispose() {
    _player.stop();
    _player.dispose();
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
        controller.v_listBox.value[i][j] = 'n'; //반복문을 사용해 게임판의 중간 컨테이너인 돌 이미지를 투명으로,
        controller.v_listBox_count.value[i][j] = ''; //또 맨 위 컨테이너의 버튼 텍스트 값을 빈칸(null)으로 초기화
      }
    }
    //setState()를 싫애하면 위젯의 build 함수가 실행되면서 변경값이 화면에 반영된다.
    // setState(() {});
  }

    @override
    Widget build(BuildContext context) {
      return GetX<VariablesController>(
        builder: (controller) => Scaffold(
          backgroundColor: Colors.transparent,
          //백그라운드를 투명하게 만듦
          appBar: AppBar(
            title: const Text(
              'AI 오목',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            backgroundColor: Colors.lightGreen[300],
            actions: [
              //개인정보처리방침 연결 버튼
              IconButton(
                  onPressed: () async {
                    if (controller.v_flagButtonPlay.value == false) {
                      //게임중이 아닐 때 작동하도록 하기 위해 controller.v_flagButtonPlay.value 변수값 체크하여 false일 경우 실행하지 않고 토스트 메시지를 보임
                      EasyLoading.instance.fontSize = 16;
                      EasyLoading.instance.displayDuration =
                      const Duration(milliseconds: 500); //메시지 유지시간 0.5초
                      EasyLoading.showToast(' *** Not executed! *** ');
                    } else {
                      const url = 'https://www.naver.com/';
                      await launchUrl(Uri.parse(url),
                          mode: LaunchMode.externalApplication //외부브라우저 사용 모드
                      );
                    }
                  },
                  icon: const Icon(Icons.lock)),
              //플레이스토어 앱 연결버튼
              IconButton(
                onPressed: () async {
                  if (controller.v_flagButtonPlay.value == false) {
                    //게임중이 아닐 때 작동하도록 하기 위해 controller.v_flagButtonPlay.value 변수값 체크하여 false일 경우 실행하지 않고 토스트 메시지를 보임
                    EasyLoading.instance.fontSize = 16;
                    EasyLoading.instance.displayDuration =
                    const Duration(milliseconds: 500); //메시지 유지시간 0.5초
                    EasyLoading.showToast(' *** Not executed! *** ');
                  } else {
                    const url = 'https://www.youtube.com/';
                    await launchUrl(Uri.parse(url),
                        mode: LaunchMode.externalApplication //외부브라우저 사용 모드
                    );
                  }
                },
                icon: const Icon(Icons.play_arrow),
              ),
              //음악소리 on/off 버튼
              IconButton(
                  onPressed: () {
                    controller.v_volumn.value ? false : true;
                    setState(() {});
                  },
                  icon:
                  controller.v_volumn.value ? const Icon(Icons.volume_mute) : const Icon(
                      Icons.volume_off)),
              //결과 화면으로 이동하는 버튼
              IconButton(
                  onPressed: () {
                    if (controller.v_flagButtonPlay.value == true) {
                      Navigator.of(context).pushNamed('/omokList', arguments: widget.db);
                    } else {
                      EasyLoading.instance.fontSize = 16;
                      EasyLoading.instance.displayDuration =
                      const Duration(milliseconds: 500);
                      EasyLoading.showToast(' *** Not executed! ***');
                    }
                  },
                  icon: const Icon(Icons.military_tech))
            ],
          ),
          body:
          //body 상단, 바둑판 배경이미지
          Column(
              children: [
                //오목 게임판 & 돌
                GameBoard(),
                //body 하단
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Colors.lightGreen[300],
                    child: Column(
                      children: [
                        //하단 위
                        Expanded(
                          flex: 1,
                          child: Container(
                            color: Colors.black12,
                            padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                            child: Row(
                              children: [
                                //3 body 하단 텍스트 (YOU)
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          color: Colors.yellow[200],
                                          alignment: Alignment.center,
                                          child: const Text(
                                            'YOU',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          margin: const EdgeInsets.fromLTRB(
                                              0, 5, 0, 0),
                                          alignment: Alignment.center,
                                          child: Image.asset(
                                            'asset/image/${controller.v_youStone.value}.png',),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                //3 body 하단 버튼 게임시작
                                Expanded(
                                  flex: 1,
                                  child: StartButton(step_initial),
                                ),
                                //3 body 하단 버튼 기권
                                Expanded(
                                  flex: 1,
                                  child: StopButton(),
                                ),
                                //3 body 하단 텍스트(현재 수순)
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    // color: Colors.green,
                                    child: Column(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Container(

                                            color: Colors.yellow[200],
                                            alignment: Alignment.center,
                                            child: const Text('현재 수순',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            margin: const EdgeInsets.fromLTRB(
                                                0, 5, 0, 0),
                                            alignment: Alignment.center,
                                            child: Text(controller.v_downCount.value.toString(),
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 24),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ),
                        //하단 아래
                        Expanded(flex: 1,
                          child: DisplayScore()
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
        ),
      );
    }


  final _player = AudioPlayer();
  Future audioPlayer(parm_mp3) async {
    await _player.setAsset(parm_mp3);
    _player.play();
  }

}

