import 'package:flutter/material.dart';
import 'package:omok/controller/variables.dart';
import 'package:get/get.dart';
import 'package:omok/utilities/step_down_stone.dart';

class GameBoard extends StatelessWidget {
  final VariablesController controller = Get.find();
  late int i; //루프용
  late int j; //루프용
  late int ii; //루프용
  late int jj; //루프용

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          //MediaQuery 이용해 해상도가 다른 기기에서 게임판을 항상 정사각형으로 유지(가로 세로 동일)
          width: (MediaQuery.of(context).size.width > MediaQuery.of(context).size.height - 300
              ? MediaQuery.of(context).size.height - 300
              : MediaQuery.of(context).size.width),
          height: (MediaQuery.of(context).size.width > MediaQuery.of(context).size.height - 300
              ? MediaQuery.of(context).size.height - 300
              : MediaQuery.of(context).size.width),
          color: Colors.yellow,
          child: Image.asset('asset/image/omok_bg.png',
              fit: BoxFit.contain),
        ),
        //13*13 바둑돌 이미지
        Container(
          width: (MediaQuery.of(context).size.width > MediaQuery.of(context).size.height - 300
              ? MediaQuery.of(context).size.height - 300
              : MediaQuery.of(context).size.width),
          height: (MediaQuery.of(context).size.width > MediaQuery.of(context).size.height - 300
              ? MediaQuery.of(context).size.height - 300
              : MediaQuery.of(context).size.width),
          child: Column(
            children: [
              Expanded(flex: 2, child: Container(),),
              //정확한 버튼 위치 설정하기 위함

              for( j = 0 ; j < controller.v_colBox.value ; j ++) Expanded(flex: 30, child: Container(
                child: Row(
                    children: [
                      Expanded(flex: 3, child: Container(),),
                      for ( i = 0 ; i < controller.v_rowBox.value ; i++  ) Expanded(flex: 30, child:Container(
                        padding: EdgeInsets.all(0),
                        margin: EdgeInsets.all(0),
                        child: Image.asset(
                            'asset/image/${controller.v_listBox.value[j][i]}.png'),
                      )),
                      Expanded(flex: 3, child: Container(),),
                    ]
                ),
              ),),
              Expanded(flex: 4, child: Container(),),
            ],
          ),
        ),
        //13*13 버튼
        Container(
          width: (MediaQuery.of(context).size.width > MediaQuery.of(context).size.height - 300
              ? MediaQuery.of(context).size.height - 300
              : MediaQuery.of(context).size.width),
          height: (MediaQuery.of(context).size.width > MediaQuery.of(context).size.height - 300
              ? MediaQuery.of(context).size.height - 300
              : MediaQuery.of(context).size.width),
          child: Column(
            children: [
              Expanded(flex: 2, child: Container(),),
              //정확한 버튼 위치 설정하기 위함
              for( int l = 0; l< controller.v_colBox.value ; l++) Expanded(
                  flex:30, child: Container(
                  child: Row(
                    children: [
                      Expanded(flex: 1, child: Container(),),
                      for(int k = 0 ; k < controller.v_rowBox.value ; k ++ ) Expanded(flex: 30, child: Container(
                        alignment: Alignment.center,
                        child: TextButton(
                          child: Text(controller.v_listBox_count.value[l][k],
                              style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold)),
                          onPressed: () {
                           if (controller.v_down.value == controller.v_youStone.value){
                             step_downStone(l, k);
                           } else { return;}
                          },),),),
                      // ~첫번째 반복 입력 2~14까지 (Row 항목 전체 13개 완성)
                      Expanded(flex: 1, child: Container(),),
                    ],
                  )
              )
              ),
              // ~두번째 바복 입력 2~14까지(Column 항목 전체 13개를 완성
              Expanded(flex: 4, child: Container(),),
            ],
          ),
        ),
      ],
    );
  }
}