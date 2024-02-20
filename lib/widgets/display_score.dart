import 'package:flutter/material.dart';
import 'package:omok/controller/variables.dart';
import 'package:get/get.dart';

class DisplayScore extends StatelessWidget {
  final VariablesController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Column(
        children: [
          //3 body 하단 전적 텍스트
          Expanded(flex: 1, child: Container(
            // decoration: BoxDecoration(
            //   border: Border.all(color: Colors.white)
            // ),
            padding: EdgeInsets.only(left: 24),
            // color: Colors.black87,
            alignment: Alignment.center,
            // margin: const EdgeInsets.fromLTRB(4, 4, 4, 4),
            child: const Text('record',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 27,
                  color: Colors.white),
            ),
          ),
          ),
          Divider(
            color: Colors.white,
          ),
          //3 body 하단 전적(승무패 점수)
          Expanded(flex: 3, child: Container(
              // decoration: BoxDecoration(
              //     border: Border.all(color: Colors.white)
              // ),
              // color: Colors.black,
              alignment: Alignment.center,
              // margin: const EdgeInsets.fromLTRB(4, 4, 4, 4),
              child: Column(
                children: [
                  Expanded(flex: 1,
                    child: Container(
                      child: Row(
                        children: [
                          Expanded(flex: 1, child: Container(
                            alignment: Alignment.center,
                            // margin: const EdgeInsets.fromLTRB(4, 4, 0, 4),
                            child: Text('${controller.v_win.value} 승',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24)),
                          )
                          ),
                          Expanded(flex: 1, child: Container(
                            alignment: Alignment.center,
                            // margin: const EdgeInsets
                            //     .fromLTRB(0, 4, 0, 4),
                            child: Text( '${controller.v_tie.value}  무',
                                style: const TextStyle(
                                    color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24)),
                          ),
                          ),
                          Expanded(flex: 1, child: Container(
                            alignment: Alignment.center,
                            // margin: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                            child: Text('${controller.v_defeat.value}  패',
                                style: const TextStyle(
                                    color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24)),
                          ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(color: Colors.white),
                  //body 하단 전적(점수)
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.only(left: 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //body 하단 전적(점수) 텍스트
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              // margin: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                              child: const Text('score',
                                style: TextStyle(
                                    color: Colors.white, fontWeight: FontWeight.bold, fontSize: 26),),
                            ),
                          ),
                          VerticalDivider(color: Colors.white,),
                          Expanded(
                            child: Container(
                            alignment: Alignment.center,
                            // margin: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                            child: Text( controller.v_score.value.toString(),
                              style: const TextStyle(
                                  color: Colors.white, fontWeight: FontWeight.bold, fontSize: 26),),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                ],
              )
          ),
          ),
        ],
      ),
    );
  }
}