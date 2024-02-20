import 'package:omok/controller/variables.dart';
import 'package:get/get.dart';

//모든 배열 설정
//화면에 놓여진 돌 n: 비어있음, w:백돌, b:흑돌
// final controller.v_listBox.value = List.generate(13, (i) => List.generate(13, (j) => ''));
//바둑판 배열(13행 * 13열) => 수순
// final controller.v_listBox.value_count = List.generate(
//     13, (i) => List.generate(13, (j) => ''));
late int i; //루프용
late int j; //루프용
late int ii; //루프용
late int jj; //루프용
final VariablesController controller = Get.find();

//AI가 돌을 놓음 ==문단 착점하기_인공지능(최적수 찾기)
void step_downStone_AI() {
  // 1. 5수 이내일 경우 상대방 마지막수 근처에 착점
  if (controller.v_downCount.value < 5 ) {
    step_downStone_5downCount();
    if(controller.v_x_AI.value != 13) return; //AI가 돌을 놓았다면 종료
  }
  // 2. AI4찾기
  step_downStone_AI4();
  if (controller.v_x_AI.value != 13) return;
  //3. YOU4 찾기
  step_downStone_YOU4();
  if (controller.v_x_AI.value != 13) return;
  // 4, AI3 찾기
  step_downStone_AI3();
  if (controller.v_x_AI.value != 13) return;
  // 5. YOU3 찾기
  step_downStone_YOU3();
  if (controller.v_x_AI.value != 13) return;
  // 6. 최고 점수 찾기
  step_downStone_attack();
  if (controller.v_x_AI.value != 13) return;
}

// 1. 5수 이내일 경우 상대방 마지막수 근처에 착점
void step_downStone_5downCount() {
  //외곽에 두면 중앙을 확인하여 착점
  if (controller.v_y_previous.value < 3 || controller.v_y_previous.value > 9 || controller.v_x_previous.value < 3 ||
      controller.v_x_previous.value > 9) { //게이머가 외곽에 두었으면 중앙에 빈자리를 찾아 착수
    if (controller.v_listBox.value[6][6] == 'n') {
      controller.v_x_AI.value = 6;
      controller.v_y_AI.value = 6;
      controller.v_listBox.value[controller.v_x_AI.value][controller.v_y_AI.value] = controller.v_down.value;
      return;
    }
    if (controller.v_listBox.value[7][6] == 'n') {
      controller.v_x_AI.value = 7;
      controller.v_y_AI.value = 6;
      controller.v_listBox.value[controller.v_x_AI.value][controller.v_y_AI.value] = controller.v_down.value;
      return;
    }
    if (controller.v_listBox.value[7][7] == 'n') {
      controller.v_x_AI.value = 7;
      controller.v_y_AI.value = 7;
      controller.v_listBox.value[controller.v_x_AI.value][controller.v_y_AI.value] = controller.v_down.value;
      return;
    }
  }

  //행 중앙에 있으면 좌우에 착점
  if (controller.v_x_previous.value == 6) {
    if (controller.v_y_previous.value < 7 &&
        controller.v_listBox.value[controller.v_x_previous.value][controller.v_y_previous.value + 1] == 'n') {
      controller.v_x_AI.value = controller.v_x_previous.value;
      controller.v_y_AI.value = controller.v_y_previous.value - 1;
      controller.v_listBox.value[controller.v_x_AI.value][controller.v_y_AI.value] = controller.v_down.value;
      return;
    }
    if (controller.v_y_previous.value > 6 &&
        controller.v_listBox.value[controller.v_x_previous.value][controller.v_y_previous.value - 1] == 'n') {
      controller.v_x_AI.value = controller.v_x_previous.value;
      controller.v_y_AI.value = controller.v_x_previous.value + 1;
      controller.v_listBox.value[controller.v_x_AI.value][controller.v_y_AI.value] = controller.v_down.value;
      return;
    }
  }

  //열 중앙에 있으면 상하에 착점
  if (controller.v_y_previous.value == 6) {
    if (controller.v_x_previous.value < 7 &&
        controller.v_listBox.value[controller.v_x_previous.value + 1][controller.v_y_previous.value] == 'n') {
      controller.v_x_AI.value = controller.v_x_previous.value - 1;
      controller.v_y_AI.value = controller.v_y_previous.value ;
      controller.v_listBox.value[controller.v_x_AI.value][controller.v_y_AI.value] = controller.v_down.value;
      return;
    }
    if (controller.v_x_previous.value > 6 &&
        controller.v_listBox.value[controller.v_x_previous.value - 1][controller.v_y_previous.value] == 'n') {
      controller.v_x_AI.value = controller.v_x_previous.value + 1;
      controller.v_y_AI.value = controller.v_y_previous.value;
      controller.v_listBox.value[controller.v_x_AI.value][controller.v_y_AI.value] = controller.v_down.value;
      return;
    }
  }

  //좌상단에 있으면 좌상단에 착점
  if (controller.v_y_previous.value < 7 && controller.v_x_previous.value < 7 &&
      controller.v_listBox.value[controller.v_x_previous.value - 1][controller.v_y_previous.value - 1] == 'n') {
    controller.v_x_AI.value = controller.v_x_previous.value - 1;
    controller.v_y_AI.value = controller.v_y_previous.value - 1;
    controller.v_listBox.value[controller.v_x_AI.value][controller.v_y_AI.value] = controller.v_down.value;
    return;
  }

  //좌하단에 있으면 좌하단에 착점
  if (controller.v_y_previous.value < 7 && controller.v_x_previous.value > 6 &&
      controller.v_listBox.value[controller.v_x_previous.value + 1][controller.v_y_previous.value - 1] == 'n') {
    controller.v_x_AI.value = controller.v_x_previous.value + 1;
    controller.v_y_AI.value = controller.v_y_previous.value - 1;
    controller.v_listBox.value[controller.v_x_AI.value][controller.v_y_AI.value] = controller.v_down.value;
    return;
  }
  //우상단에 있으면 우상단에 착점
  if (controller.v_y_previous.value > 6 && controller.v_x_previous.value < 7 &&
      controller.v_listBox.value[controller.v_x_previous.value - 1][controller.v_y_previous.value + 1] == 'n') {
    controller.v_x_AI.value = controller.v_x_previous.value - 1;
    controller.v_y_AI.value = controller.v_y_previous.value + 1;
    controller.v_listBox.value[controller.v_x_AI.value][controller.v_y_AI.value] = controller.v_down.value;
    return;
  }
  //우하단에 있으면 우하단에 착점
  if (controller.v_y_previous.value > 6 && controller.v_x_previous.value > 6 &&
      controller.v_listBox.value[controller.v_x_previous.value + 1][controller.v_y_previous.value + 1] == 'n') {
    controller.v_x_AI.value = controller.v_x_previous.value + 1;
    controller.v_y_AI.value = controller.v_y_previous.value + 1;
    controller.v_listBox.value[controller.v_x_AI.value][controller.v_y_AI.value] = controller.v_down.value;
    return;
  }

  //위 조건에 위치에 돌이 이미 놓여 착수불가할 경우. 마지막으로 게이머가 둔 수의 8개 주변을 확인하여 빈곳이면 착점한다.
  if (controller.v_listBox.value[controller.v_x_previous.value - 0][controller.v_y_previous.value + 1] == 'n') {
    controller.v_x_AI.value = controller.v_x_previous.value - 0;
    controller.v_y_AI.value = controller.v_y_previous.value + 1;
    controller.v_listBox.value[controller.v_x_AI.value][controller.v_y_AI.value] = controller.v_down.value;
    return;
  }
  if (controller.v_listBox.value[controller.v_x_previous.value + 1][controller.v_y_previous.value + 1] == 'n') {
    controller.v_x_AI.value = controller.v_x_previous.value + 1;
    controller.v_x_AI.value = controller.v_x_previous.value + 1;
    controller.v_listBox.value[controller.v_x_AI.value][controller.v_y_AI.value] = controller.v_down.value;
    return;
  }
  if (controller.v_listBox.value[controller.v_x_previous.value + 1][controller.v_y_previous.value + 0] == 'n') {
    controller.v_x_AI.value = controller.v_x_previous.value + 1;
    controller.v_x_AI.value = controller.v_x_previous.value + 0;
    controller.v_listBox.value[controller.v_x_AI.value][controller.v_y_AI.value] = controller.v_down.value;
    return;
  }
  if (controller.v_listBox.value[controller.v_x_previous.value + 1][controller.v_y_previous.value - 1] == 'n') {
    controller.v_x_AI.value = controller.v_x_previous.value + 1;
    controller.v_x_AI.value = controller.v_x_previous.value - 1;
    controller.v_listBox.value[controller.v_x_AI.value][controller.v_y_AI.value] = controller.v_down.value;
    return;
  }
  if (controller.v_listBox.value[controller.v_x_previous.value + 0][controller.v_y_previous.value - 1] == 'n') {
    controller.v_x_AI.value = controller.v_x_previous.value + 0;
    controller.v_x_AI.value = controller.v_x_previous.value - 1;
    controller.v_listBox.value[controller.v_x_AI.value][controller.v_y_AI.value] = controller.v_down.value;
    return;
  }
  if (controller.v_listBox.value[controller.v_x_previous.value - 1][controller.v_y_previous.value - 1] == 'n') {
    controller.v_x_AI.value = controller.v_x_previous.value - 1;
    controller.v_y_AI.value = controller.v_y_previous.value - 1;
    controller.v_listBox.value[controller.v_x_AI.value][controller.v_y_AI.value] = controller.v_down.value;
    return;
  }
  if (controller.v_listBox.value[controller.v_x_previous.value - 1][controller.v_y_previous.value - 0] == 'n') {
    controller.v_x_AI.value = controller.v_x_previous.value - 1;
    controller.v_y_AI.value = controller.v_y_previous.value - 0;
    controller.v_listBox.value[controller.v_x_AI.value][controller.v_y_AI.value] = controller.v_down.value;
    return;
  }
  if (controller.v_listBox.value[controller.v_x_previous.value - 0][controller.v_y_previous.value - 1] == 'n') {
    controller.v_x_AI.value = controller.v_x_previous.value - 0;
    controller.v_y_AI.value = controller.v_y_previous.value - 1;
    controller.v_listBox.value[controller.v_x_AI.value][controller.v_y_AI.value] = controller.v_down.value;
    return;
  }
}

// 2. AI4 찾기
void step_downStone_AI4() {
  step_downStone_AI4_row(); //가로
  if (controller.v_x_AI.value != 13) return; //AI가 돌을 놓았다면 종료
  step_downStone_AI4_col(); //세로
  if (controller.v_x_AI.value != 13) return; //AI가 돌을 놓았다면 종료
  step_downStone_AI4_grd1(); //대각선1의 우측하향
  if (controller.v_x_AI.value != 13) return; //AI가 돌을 놓았다면 종료
  step_downStone_AI4_grd2(); //대각선2의 우착상향
  if (controller.v_x_AI.value != 13) return; //AI가 돌을 놓았다면 종료
}

// 2-1. AI4 찾기 ----행(가로방향 4)
void step_downStone_AI4_row() {
  for (i = 0; i < controller.v_rowBox.value; i++) {
    for (j = 0; j <= controller.v_colBox.value - 5; j ++) {
      int _v_count_n = 0; //빈곳 수
      int _v_count_AI = 0; //AI 수
      int _v_x_AI = 0;
      int _v_y_AI = 0;

      for (jj = 0; jj < 5; jj++) {
        if (controller.v_listBox.value[i][j + jj] == controller.v_youStone.value) break;
        if (controller.v_listBox.value[i][j + jj] == 'n') {
          _v_count_n++;
          _v_x_AI = i;
          _v_y_AI = j + jj;
        } else {
          _v_count_AI++;
        }
      }

      if (_v_count_n == 1 && _v_count_AI == 4) {
        controller.v_x_AI.value = _v_x_AI;
        controller.v_y_AI.value = _v_y_AI;
        controller.v_listBox.value[controller.v_x_AI.value][controller.v_y_AI.value] = controller.v_down.value;
        return;
      }
    }
  }
}

//2-2. AI4 찾기 ---열(세로방향 4)
void step_downStone_AI4_col() {
  for (j = 0; j < controller.v_colBox.value; j++) {
    for (i = 0; i <= controller.v_rowBox.value - 5; i++) {
      int _v_count_n = 0;
      int _v_count_AI = 0;
      int _v_x_AI = 0;
      int _v_y_AI = 0;
      for (ii = 0; ii < 5; ii++) {
        if (controller.v_listBox.value[i + ii][j] == controller.v_youStone.value) break;
        if (controller.v_listBox.value[i + ii][j] == 'n') {
          _v_count_n++;
          _v_x_AI = i + ii;
          _v_y_AI = j;
        } else {
          _v_count_AI++;
        }
      }
      if (_v_count_n == 1 && _v_count_AI == 4) {
        controller.v_x_AI.value = _v_x_AI;
        controller.v_y_AI.value = _v_y_AI;
        controller.v_listBox.value[controller.v_x_AI.value][controller.v_y_AI.value] = controller.v_down.value;
        return;
      }
    }
  }
}

//2-3. AI4 찾기 --- 대각선 우측 하향
void step_downStone_AI4_grd1() {
  for (i = 0; i <= controller.v_rowBox.value - 5; i++) {
    for (j = 0; j <= controller.v_colBox.value - 5; j++) {
      int _v_count_n = 0;
      int _v_count_AI = 0;
      int _v_x_AI = 0;
      int _v_y_AI = 0;
      for (jj = 0; jj < 5; jj++) {
        if (controller.v_listBox.value[i + jj][j + jj] == controller.v_youStone.value) break;
        if (controller.v_listBox.value[i + jj][j + jj] == 'n') {
          _v_count_n++;
          _v_x_AI = i + jj;
          _v_y_AI = j + jj;
        } else {
          _v_count_AI++;
        }
      }
      if (_v_count_n == 1 && _v_count_AI == 4) {
        controller.v_x_AI.value = _v_x_AI;
        controller.v_y_AI.value = _v_y_AI;
        controller.v_listBox.value[controller.v_x_AI.value][controller.v_y_AI.value] = controller.v_down.value;
        return;
      }
    }
  }
}

//2-4 AI4찾기 ---대각선 우측 상향
void step_downStone_AI4_grd2() {
  for (i = 4; i < controller.v_rowBox.value; i ++) {
    for (j = 0; j < controller.v_colBox.value - 5; j++) {
      int _v_count_n = 0;
      int _v_count_AI = 0;
      int _v_x_AI = 0;
      int _v_y_AI = 0;
      for (jj = 0; jj < 5; jj++) {
        if (controller.v_listBox.value[i - jj][j + jj] == controller.v_youStone.value) break;
        if (controller.v_listBox.value[i - jj][j + jj] == 'n') {
          _v_count_n++;
          _v_x_AI = i - jj;
          _v_y_AI = j + jj;
        } else {
          _v_count_AI++;
        }
      }
      if (_v_count_n == 1 && _v_count_AI == 4) {
        controller.v_x_AI.value = _v_x_AI;
        controller.v_y_AI.value = _v_y_AI;
        controller.v_listBox.value[controller.v_x_AI.value][controller.v_y_AI.value] = controller.v_down.value;
        return;
      }
    }
  }
}

//3. YOU4 찾기
void step_downStone_YOU4() {
  step_downStone_YOU4_row();
  if (controller.v_x_AI.value != 13) return;
  step_downStone_YOU4_col();
  if (controller.v_x_AI.value != 13) return;
  step_downStone_YOU4_grd1();
  if (controller.v_x_AI.value != 13) return;
  step_downStone_YOU4_grd2();
  if (controller.v_x_AI.value != 13) return;
}

//3-1. YOU4 찾기 ---행
void step_downStone_YOU4_row() {
  for (i = 0; i < controller.v_rowBox.value; i++) {
    for (j = 0; j <= controller.v_colBox.value - 5; j++) {
      int _v_count_n = 0;
      int _v_count_YOU = 0;
      int _v_x_AI = 0;
      int _v_y_AI = 0;
      for (jj = 0; jj < 5; jj++) {
        if (controller.v_listBox.value[i][j + jj] == controller.v_aiStone.value) break;
        if (controller.v_listBox.value[i][j + jj] == 'n') {
          _v_count_n++;
          _v_x_AI = i;
          _v_y_AI = j + jj;
        } else {
          _v_count_YOU++;
        }
      }
      if (_v_count_n == 1 && _v_count_YOU == 4) {
        controller.v_x_AI.value = _v_x_AI;
        controller.v_y_AI.value = _v_y_AI;
        controller.v_listBox.value[controller.v_x_AI.value][controller.v_y_AI.value] = controller.v_down.value;
        return;
      }
    }
  }
}

//3-2. YOU4 찾기 ---열
void step_downStone_YOU4_col() {
  for (j = 0; j < controller.v_colBox.value; j++) {
    for (i = 0; i <= controller.v_rowBox.value - 5; i++) {
      int _v_count_n = 0;
      int _v_count_YOU = 0;
      int _v_x_AI = 0;
      int _v_y_AI = 0;
      for (ii = 0; ii < 5; ii++) {
        if (controller.v_listBox.value[i + ii][j] == controller.v_aiStone.value) break;
        if (controller.v_listBox.value[i + ii][j] == 'n') {
          _v_count_n++;
          _v_x_AI = i + ii;
          _v_y_AI = j;
        } else {
          _v_count_YOU++;
        }
      }
      if (_v_count_n == 1 && _v_count_YOU == 4) {
        controller.v_x_AI.value = _v_x_AI;
        controller.v_y_AI.value = _v_y_AI;
        controller.v_listBox.value[controller.v_x_AI.value][controller.v_y_AI.value] = controller.v_down.value;
        return;
      }
    }
  }
}

// 3-3. YOU4 찾기 --- 대각선 우측 하향
void step_downStone_YOU4_grd1() {
  for (i = 0; i <= controller.v_rowBox.value - 5; i++) {
    for (j = 0; j <= controller.v_colBox.value - 5; j++) {
      int _v_count_n = 0; //빈곳 수
      int _v_count_YOU = 0; //YOU수
      int _v_x_AI = 0;
      int _v_y_AI = 0;
      for (jj = 0; jj < 5; jj++) {
        if (controller.v_listBox.value[i + jj][j + jj] == controller.v_aiStone.value) break;
        if (controller.v_listBox.value[i + jj][j + jj] == 'n') {
          _v_count_n++;
          _v_x_AI = i + jj;
          _v_y_AI = j + jj;
        } else {
          _v_count_YOU++;
        }
      }
      if (_v_count_n == 1 && _v_count_YOU == 4) {
        controller.v_x_AI.value = _v_x_AI;
        controller.v_y_AI.value = _v_y_AI;
        controller.v_listBox.value[controller.v_x_AI.value][controller.v_y_AI.value] = controller.v_down.value;
        return;
      }
    }
  }
}

// 3-4. YOU4 찾기 --- 대각선 우측 상향
void step_downStone_YOU4_grd2() {
  for (i = 4; i < controller.v_rowBox.value; i++) {
    for (j = 0; j <= controller.v_colBox.value - 5; j++) {
      int _v_count_n = 0;
      int _v_count_YOU = 0;
      int _v_x_AI = 0;
      int _v_y_AI = 0;
      for (jj = 0; jj < 5; jj++) {
        if (controller.v_listBox.value[i - jj][j + jj] == controller.v_aiStone.value) break;
        if (controller.v_listBox.value[i - jj][j + jj] == 'n') {
          _v_count_n++;
          _v_x_AI = i - jj;
          _v_y_AI = j + jj;
        } else {
          _v_count_YOU++;
        }
      }
      if (_v_count_n == 1 && _v_count_YOU == 4) {
        controller.v_x_AI.value = _v_x_AI;
        controller.v_y_AI.value = _v_y_AI;
        controller.v_listBox.value[controller.v_x_AI.value][controller.v_y_AI.value] = controller.v_down.value;
        return;
      }
    }
  }
}


//4. AI3 찾기
void step_downStone_AI3() {
  step_downStone_AI3_row();
  if (controller.v_x_AI.value != 13) return;
  step_downStone_AI3_col();
  if (controller.v_x_AI.value != 13) return;
  step_downStone_AI3_grd1();
  if (controller.v_x_AI.value != 13) return;
  step_downStone_AI3_grd2();
  if (controller.v_x_AI.value != 13) return;
}

// 4-1. AI3찾기 ---행
void step_downStone_AI3_row() {
  for (i = 0; i < controller.v_rowBox.value; i++) {
    for (j = 0; j <= controller.v_colBox.value - 4; j++) {
      int _v_count_n = 0;
      int _v_count_AI = 0;
      int _v_x_AI = 0; //빈곳 수
      int _v_y_AI = 0; //AI 수
      for (jj = 0; jj < 4; jj++) {
        if (controller.v_listBox.value[i][j + jj] == controller.v_youStone.value) break;
        if (controller.v_listBox.value[i][j + jj] == 'n') {
          _v_count_n++;
          _v_x_AI = i;
          _v_y_AI = j + jj;
        } else {
          _v_count_AI++;
        }
      }
      if(_v_count_n == 1 && _v_count_AI == 3) {
        controller.v_x_AI.value = _v_x_AI;
        controller.v_y_AI.value = _v_y_AI;
        controller.v_listBox.value[controller.v_x_AI.value][controller.v_y_AI.value] = controller.v_down.value;
        return;
      }
    }
  }
}

//4-2. AI3 찾기 ---열
void step_downStone_AI3_col() {
  for (j = 0; j < controller.v_colBox.value; j++) {
    for (i = 0; i <= controller.v_rowBox.value -4; i++) {
      int _v_count_n = 0;
      int _v_count_AI = 0;
      int _v_x_AI = 0;
      int _v_y_AI = 0;
      for (ii = 0; ii < 4; ii++) {
        if (controller.v_listBox.value[i + ii][j] == controller.v_youStone.value) break;
        if (controller.v_listBox.value[i + ii][j] == 'n') {
          _v_count_n++;
          _v_x_AI = i + ii;
          _v_y_AI = j;
        } else {
          _v_count_AI++;
        }
      }
      if (_v_count_n == 1 && _v_count_AI == 3) {
        controller.v_x_AI.value = _v_x_AI;
        controller.v_y_AI.value = _v_y_AI;
        controller.v_listBox.value[controller.v_x_AI.value][controller.v_y_AI.value] = controller.v_down.value;
        return;
      }
    }
  }
}

//4-3. AI3 찾기 --- 대각선 우측하향
void step_downStone_AI3_grd1() {
  for (i = 0; i <= controller.v_rowBox.value - 4; i ++) {
    for (j = 0; j <= controller.v_colBox.value - 4; j++) {
      int _v_count_n = 0;
      int _v_count_AI = 0;
      int _v_x_AI = 0;
      int _v_y_AI = 0;
      for (jj = 0; jj < 4; jj++) {
        if (controller.v_listBox.value[i + jj][j + jj] == controller.v_youStone.value) break;
        if (controller.v_listBox.value[i + jj][j + jj] == 'n') {
          _v_count_n++;
          _v_x_AI = i + jj;
          _v_y_AI = j + jj;
        } else {
          _v_count_AI++;
        }
      }
      if (_v_count_n == 1 && _v_count_AI == 3) {
        controller.v_x_AI.value = _v_x_AI;
        controller.v_y_AI.value = _v_y_AI;
        controller.v_listBox.value[controller.v_x_AI.value][controller.v_y_AI.value] = controller.v_down.value;
        return;
      }
    }
  }
}

//4_4. AI3 찾기 --- 대각선 우측상향
void step_downStone_AI3_grd2() {
  for (i = 3; i < controller.v_rowBox.value; i++) {
    for (j = 0; j <= controller.v_colBox.value - 4; j++) {
      int _v_count_n = 0;
      int _v_count_AI = 0;
      int _v_x_AI = 0;
      int _v_y_AI = 0;
      for (jj = 0; jj < 4; jj++) {
        if (controller.v_listBox.value[i - jj][j + jj] == controller.v_youStone.value) break;
        if (controller.v_listBox.value[i - jj][j + jj] == 'n') {
          _v_count_n++;
          _v_x_AI = i - jj;
          _v_y_AI = j + jj;
        } else {
          _v_count_AI++;
        }
      }
      if (_v_count_n == 1 && _v_count_AI == 3) {
        controller.v_x_AI.value = _v_x_AI;
        controller.v_y_AI.value = _v_y_AI;
        controller.v_listBox.value[controller.v_x_AI.value][controller.v_y_AI.value] = controller.v_down.value;
        return;
      }
    }
  }
}



//YOU3 찾기
void step_downStone_YOU3() {
  step_downStone_YOU3_row();
  if (controller.v_x_AI.value != 13) return;
  step_downStone_YOU3_col();
  if (controller.v_x_AI.value != 13) return;
  step_downStone_YOU3_grd1();
  if (controller.v_x_AI.value != 13) return;
  step_downStone_YOU3_grd2();
}

//5-1. YOU3 찾기 --- 행
void step_downStone_YOU3_row() {
  for (i = 0; i < controller.v_rowBox.value; i++) {
    for (j = 1; j <= controller.v_colBox.value - 5; j++) { //양쪽 벽에 붙어 있을 경우 썩은 3
      int _v_count_n = 0;
      int _v_count_YOU = 0;
      int _v_x_AI = 0;
      int _v_y_AI = 0;
      for (jj = 0; jj < 4; jj++) {
        if (controller.v_listBox.value[i][j + jj] == controller.v_aiStone.value) break;
        if (controller.v_listBox.value[i][j + jj] == 'n') {
          _v_count_n++;
          _v_x_AI = i;
          _v_y_AI = j + jj;
        } else {
          if (jj == 0 && controller.v_listBox.value[i][j - 1] == controller.v_aiStone.value)
            break; //양쪽벽에 AI돌이 있는 경우 썩은 3
          if (jj == 3 && controller.v_listBox.value[i][j + jj + 1] == controller.v_aiStone.value) break;
          _v_count_YOU++;
        }
      }
      if (_v_count_n == 1 && _v_count_YOU == 3) {
        controller.v_x_AI.value = _v_x_AI;
        controller.v_y_AI.value = _v_y_AI;
        controller.v_listBox.value[controller.v_x_AI.value][controller.v_y_AI.value] = controller.v_down.value;
        return;
      }
    }
  }
}

//5-2. YOU3 찾기 --- 열
void step_downStone_YOU3_col() {
  for (j = 0; j < controller.v_colBox.value; j++) {
    for (i = 1; i <= controller.v_rowBox.value - 5; i++) { //양쪽 벽에 붙어 있을 경우 썩은 3
      int _v_count_n = 0;
      int _v_count_YOU = 0;
      int _v_x_AI = 0;
      int _v_y_AI = 0;
      for (ii = 0; ii < 4; ii++) {
        if (controller.v_listBox.value[i + ii][j] == controller.v_aiStone.value) break;
        if (controller.v_listBox.value[i + ii][j] == 'n') {
          _v_count_n++;
          _v_x_AI = i + ii;
          _v_y_AI = j;
        } else {
          if (ii == 0 && controller.v_listBox.value[i - 1][j] == controller.v_aiStone.value) break;
          if (ii == 3 && controller.v_listBox.value[i + ii + 1][j] == controller.v_aiStone.value) break;
          _v_count_YOU++;
        }
      }
      if (_v_count_n == 1 && _v_count_YOU == 3) {
        controller.v_x_AI.value = _v_x_AI;
        controller.v_y_AI.value = _v_y_AI;
        controller.v_listBox.value[controller.v_x_AI.value][controller.v_y_AI.value] = controller.v_down.value;
        return;
      }
    }
  }
}

//5-3. YOU3 찾기 --- 대각선 우측 하향
void step_downStone_YOU3_grd1() {
  for (i = 1; j < controller.v_rowBox.value - 5; i++) { //양쪽 벽에 붙어 있을 경우 썩은 3
    for (j = 1; j <= controller.v_colBox.value - 5; j++) {
      int _v_count_n = 0;
      int _v_count_YOU = 0;
      int _v_x_AI = 0;
      int _v_y_AI = 0;
      for (jj = 0; jj < 4; jj++) {
        if (controller.v_listBox.value[i + jj][j + jj] == controller.v_aiStone.value) break;
        if (controller.v_listBox.value[i + jj][j + jj] == 'n') {
          _v_count_n++;
          _v_x_AI = i + jj;
          _v_y_AI = j + jj;
        } else {
          if (jj == 0 && controller.v_listBox.value[i - 1][j - 1] == controller.v_aiStone.value) break;
          if (jj == 3 && controller.v_listBox.value[i + jj + 1][j + jj + 1] == controller.v_aiStone.value)
            break;
          _v_count_YOU++;
        }
      }
      if (_v_count_n == 1 && _v_count_YOU == 3) {
        controller.v_x_AI.value = _v_x_AI;
        controller.v_y_AI.value = _v_y_AI;
        controller.v_listBox.value[controller.v_x_AI.value][_v_y_AI] = controller.v_down.value;
        return;
      }
    }
  }
}

//5-4. YOU3 찾기 --- 대각선 우측 상향
void step_downStone_YOU3_grd2() {
  for (i = 4; j > controller.v_rowBox.value - 1; i++) {
    for (j = 0; j <= controller.v_colBox.value - 5; j++) {
      int _v_count_n = 0;
      int _v_count_YOU = 0;
      int _v_x_AI = 0;
      int _v_y_AI = 0;
      for (jj = 0; jj < 4; jj++) {
        if (controller.v_listBox.value[i - jj][j + jj] == controller.v_aiStone.value) break;
        if (controller.v_listBox.value[i - jj][j + jj] == 'n') {
          _v_count_n++;
          _v_x_AI = i - jj;
          _v_y_AI = j + jj;
        } else {
          if (jj == 0 && controller.v_listBox.value[i + 1][j - 1] == controller.v_aiStone.value) break;
          if (jj == 3 && controller.v_listBox.value[i - jj - 1][j + jj + 1] == controller.v_aiStone.value)
            break;
          _v_count_YOU++;
        }
      }
      if (_v_count_n == 1 && _v_count_YOU == 3) {
        controller.v_x_AI.value = _v_x_AI;
        controller.v_y_AI.value = _v_y_AI;
        controller.v_listBox.value[controller.v_x_AI.value][_v_y_AI] = controller.v_down.value;
        return;
      }
    }
  }
}


//6. 최고 점수 찾기
void step_downStone_attack() {
  controller.v_scoreTop.value = 0; //최고점수

  for (i = 0; i < controller.v_rowBox.value; i++) {
    for (j = 0; j < controller.v_colBox.value; j++) {
      if (controller.v_listBox.value[i][j] == 'n') { //돌이 없으면 실행
        controller.v_scoreRow.value = 0;
        controller.v_scoreCol.value = 0;
        controller.v_scoreGrd1.value = 0;
        controller.v_scoreGrd2.value = 0;

        step_downStone_attack_row(i, j);
        step_downStone_attack_col(i, j);
        step_downStone_attack_grd1(i, j);
        step_downStone_attack_grd2(i, j);

        if (controller.v_scoreTop.value < controller.v_scoreRow.value + controller.v_scoreCol.value + controller.v_scoreGrd1.value + controller.v_scoreGrd2.value) {
          controller.v_scoreTop.value = controller.v_scoreRow.value + controller.v_scoreCol.value + controller.v_scoreGrd1.value + controller.v_scoreGrd2.value;
          controller.v_x_AI.value = i;
          controller.v_y_AI.value = j;
        }
      }
    }
  }
  controller.v_listBox.value[controller.v_x_AI.value][controller.v_y_AI.value] = controller.v_down.value;
  return;
}

//6-1. 최고 점수 찾기 ---행
void step_downStone_attack_row(x, y) {
  //좌 방향으로 계속 검토(비어있으면 1, you 돌이면 -1, AI 돌이면 3)
  if (y == 0) {
    controller.v_scoreRow.value = controller.v_scoreRow.value - 5; //벽에 붙어있으면 -5점
  } else {
    controller.v_count.value = 0;
    for (jj = y - 1; jj >= 0; jj--) {
      if (controller.v_count.value == 4) break; else controller.v_count.value++;
      if (controller.v_listBox.value[x][jj] == 'n') {
        controller.v_scoreRow.value = controller.v_scoreRow.value + 1;
      } else if (controller.v_listBox.value[x][jj] == controller.v_youStone.value) {
        controller.v_scoreRow.value = controller.v_scoreRow.value - 3;
        break;
      } else {
        controller.v_scoreRow.value = controller.v_scoreRow.value + 2 + (5 - controller.v_count.value); //가까이 있을수록 큰 점수 부여
      }
    }
  }

  //우 방향으로 계속 검토 (비어있으면 1, youehfdlaus -1, AI 돌이면 3
  if (y == controller.v_colBox.value - 1) {
    controller.v_scoreRow.value = controller.v_scoreRow.value - 5;
  } else {
    controller.v_count.value = 0;
    for (jj = y + 1; jj < controller.v_colBox.value; jj++) {
      if (controller.v_count.value == 4) break; else controller.v_count.value++;
      if (controller.v_listBox.value[x][jj] == 'n') {
        controller.v_scoreRow.value = controller.v_scoreRow.value + 1;
      } else if (controller.v_listBox.value[x][jj] == controller.v_youStone.value) {
        controller.v_scoreRow.value = controller.v_scoreRow.value -3;
        return;
      } else {
        controller.v_scoreRow.value = controller.v_scoreRow.value + 2 + (5 - controller.v_count.value);
      }
    }
  }
}

void step_downStone_attack_col(x, y) {
  //상 방향으로 계속 검토(비어있으면 1, you돌이면 -1, AI돌이면 3
  if (x == 0) {
    controller.v_scoreCol.value = controller.v_scoreCol.value - 5;
  } else {
    controller.v_count.value = 0;
    for (ii = x - 1; ii >= 0; ii--) {
      if (controller.v_count.value == 4) break; else controller.v_count.value++;
      if (controller.v_listBox.value[ii][y] == 'n') {
        controller.v_scoreCol.value = controller.v_scoreCol.value + 1;
      } else if (controller.v_listBox.value[ii][y] == controller.v_youStone.value) {
        controller.v_scoreCol.value = controller.v_scoreCol.value - 3;
        break;
      } else {
        controller.v_scoreCol.value = controller.v_scoreCol.value + 2 + (5 - controller.v_count.value); //가까이 있을 수록 큰 점수 부여
      }
    }
  }

  //하 방향으로 계속 검토(비어있으면 1, you돌이면 -1, AI돌이면 3
  if (x == controller.v_rowBox.value - 1) {
    controller.v_scoreCol.value = controller.v_scoreCol.value - 5;
  } else {
    controller.v_count.value = 0;
    for (ii = x + 1; ii < controller.v_rowBox.value; ii++) {
      if (controller.v_count.value == 4) break; else controller.v_count.value++;
      if (controller.v_listBox.value[ii][y] == 'n') {
        controller.v_scoreCol.value = controller.v_scoreCol.value + 1;
      } else if (controller.v_listBox.value[ii][y] == 'n') {
        controller.v_scoreCol.value = controller.v_scoreCol.value - 3;
        return;
      } else {
        controller.v_scoreRow.value = controller.v_scoreRow.value + 2 + (5 - controller.v_count.value); //가까이 있을수록 큰 점수 부여
      }
    }
  }
}

//6-3. 최고점수 찾기 --- 대각선 우측 하향
void step_downStone_attack_grd1(x, y) {
  //좌상 방향으로 계속 검터(비어있으면 1, you돌이면 -1, AI돌이면 3
  if (x == 0 || y == 0) {
    controller.v_scoreGrd1.value = controller.v_scoreGrd1.value - 5;
  } else {
    for (controller.v_count.value = 1; controller.v_count.value < 5; controller.v_count.value++) {
      if (x - controller.v_count.value < 0 || y - controller.v_count.value < 0) break;
      if (controller.v_listBox.value[x - controller.v_count.value][y - controller.v_count.value] == 'n') {
        controller.v_scoreGrd1.value = controller.v_scoreGrd1.value + 1;
      } else if (controller.v_listBox.value[x - controller.v_count.value][y - controller.v_count.value] == controller.v_youStone.value) {
        controller.v_scoreGrd1.value = controller.v_scoreGrd1.value - 3;
        break;
      } else {
        controller.v_scoreGrd1.value = controller.v_scoreGrd1.value + 2 + (6 - controller.v_count.value);
      }
    }
  }

  //우하 방향으로 계속 검토(비어있으면 1, you 돌이면 -1, AI 돌이면 3
  if (x == controller.v_rowBox.value - 1 || y == controller.v_colBox.value - 1) {
    controller.v_scoreGrd1.value = controller.v_scoreGrd1.value - 5;
  } else {
    for (controller.v_count.value = 1; controller.v_count.value < 5; controller.v_count.value++) {
      if (x + controller.v_count.value > controller.v_colBox.value - 1 || y + controller.v_count.value > controller.v_rowBox.value - 1) break;
      if (controller.v_listBox.value[x + controller.v_count.value][y + controller.v_count.value] == 'n') {
        controller.v_scoreGrd1.value = controller.v_scoreGrd1.value + 1;
      } else if (controller.v_listBox.value[x + controller.v_count.value][y + controller.v_count.value] == controller.v_youStone.value) {
        controller.v_scoreGrd1.value = controller.v_scoreGrd1.value - 3;
      } else {
        controller.v_scoreGrd1.value = controller.v_scoreGrd1.value + 2 + (5 - controller.v_count.value);
      }
    }
  }
}

void step_downStone_attack_grd2(x, y) {
  if (x == 0 || y + controller.v_count.value == controller.v_rowBox.value - 1) {
    controller.v_scoreGrd2.value = controller.v_scoreGrd2.value - 5;
  } else {
    for (controller.v_count.value = 1; controller.v_count.value < 5; controller.v_count.value++) {
      if (x - controller.v_count.value < 0 || y + controller.v_count.value > controller.v_rowBox.value - 1) break;
      if (controller.v_listBox.value[x - controller.v_count.value][y + controller.v_count.value] == 'n') {
        controller.v_scoreGrd2.value = controller.v_scoreGrd2.value + 1;
      } else if (controller.v_listBox.value[x - controller.v_count.value][y + controller.v_count.value] == controller.v_youStone.value) {
        controller.v_scoreGrd2.value = controller.v_scoreGrd2.value - 3;
        break;
      } else {
        controller.v_scoreGrd2.value = controller.v_scoreGrd2.value + 2 + (6 - controller.v_count.value); //가까이 있을수록 큰 점수 부여
      }
    }
  }
  if (x == controller.v_rowBox.value - 1 || y == 0) {
    controller.v_scoreGrd2.value = controller.v_scoreGrd2.value - 5;
  } else {
    for (controller.v_count.value = 1; controller.v_count.value < 5; controller.v_count.value++) {
      if (x + controller.v_count.value > controller.v_colBox.value - 1 || y - controller.v_count.value < 0) break;
      if (controller.v_listBox.value[x + controller.v_count.value][y - controller.v_count.value] == 'n') {
        controller.v_scoreGrd2.value = controller.v_scoreGrd2.value + 1;
      } else if (controller.v_listBox.value[x + controller.v_count.value][y - controller.v_count.value] == controller.v_youStone.value) {
        controller.v_scoreGrd2.value = controller.v_scoreGrd2.value - 3;
        return;
      } else {
        controller.v_scoreGrd2.value = controller.v_scoreGrd2.value + 2 + (5 - controller.v_count.value);
      }
    }
  }
}