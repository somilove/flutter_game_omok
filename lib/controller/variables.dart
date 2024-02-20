import "package:get/get.dart";

class VariablesController extends GetxController {
  var v_image_volumn = 'asset/image/volumn_on.png'.obs;
  var v_volumn = true.obs;
  var v_youStone = 'n'.obs; //게이머의 돌 black, white
  var v_rivalStone = 'n'.obs;
  var v_aiStone = 'n'.obs; //AI의 돌 black, white
  var v_downCount = 0.obs; //현재 수순
  var v_win = 0.obs; //( 승 = v_win)
  var v_tie = 0.obs; //( 무 = v_tie)
  var v_defeat = 0.obs; //(패 = v_defeat)
  var v_score = 0.obs; //점수

  var v_rowBox = 13.obs; //행 v_listBox의 2차원 배열요소수
  var v_colBox = 13.obs;
//v_x_count, v_y_count => 마지막에 놓은 돌의 위치를 저장하는 변수
  var v_x_count = 0.obs; //마지막 놓은 돌의 행 위치
  var v_y_count = 0.obs; //마지막 놓은 돌의 열 위치
  var v_down = 'n'.obs; //다음 놓을 돌 (흑돌이라면 b, 백돌이라면 w)
  var v_x_previous = 13.obs; //이전 착수 행
  var v_y_previous = 13.obs; //이전 착수 열
  var v_x_AI = 13.obs; //AI 착수 => 최적수를 찾기 위한 단순 루프용 변수 추가
  var v_y_AI = 13.obs; //AI 착수
  var v_count = 5.obs; //오목의 연속수를 체크용
  var v_scoreTop = 0.obs; //오목의 연속수를 체크용
  var v_scoreRow = 0.obs;
  var v_scoreCol = 0.obs;
  var v_scoreGrd1 = 0.obs;
  var v_scoreGrd2 = 0.obs;
  var v_today = ''.obs; //DB 입력시 px(primary key)로 사용되는 일시 / 게임 종료될때 현재시간 년월일시분초를 String 타입으로 관리
  var v_isAiPlay = false.obs;

  //모든 Flag 설정
  var v_flagButtonPlay = true.obs; //게임 시작 버튼

  //모든 배열 설정
  //화면에 놓여진 돌 n: 비어있음, w:백돌, b:흑돌
  var v_listBox = List.generate(13, (i) => List.generate(13, (j) => '')).obs;
  //바둑판 배열(13행 * 13열) => 수순
  var v_listBox_count = List.generate(
      13, (i) => List.generate(13, (j) => '')).obs;

}


