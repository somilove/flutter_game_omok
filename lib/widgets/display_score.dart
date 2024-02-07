import 'package:flutter/material.dart';
import 'package:omok/variable/variables.dart';
import 'package:get/get.dart';

class DisplayScore extends StatelessWidget {
  final VariablesController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green[700],
      child: Row(
        children: [
          //3 body 하단 전적 텍스트
          Expanded(flex: 1, child: Container(
            color: Colors.orange[300],
            alignment: Alignment.center,
            margin: const EdgeInsets.fromLTRB(4, 4, 4, 4),
            child: const Text(
              '전적',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24),
            ),
          ),
          ),
          //3 body 하단 전적(승무패 점수)
          Expanded(flex: 3, child: Container(
              color: Colors.orange[700],
              alignment: Alignment.center,
              margin: const EdgeInsets.fromLTRB(4, 4, 4, 4),
              child: Column(
                children: [
                  Expanded(flex: 1,
                    child: Container(
                      child: Row(
                        children: [
                          Expanded(flex: 1, child: Container(
                            alignment: Alignment.centerRight,
                            margin: const EdgeInsets.fromLTRB(4, 4, 0, 4),
                            child: Text(controller.v_win.value.toString(),
                                style: const TextStyle(
                                    color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24)),
                          )
                          ),
                          Expanded(flex: 1, child: Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets
                                .fromLTRB(0, 4, 0, 4),
                            child: Text('승',
                              style: TextStyle(
                                  color: Colors.green[100], fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ),
                          ),
                          Expanded(flex: 1, child: Container(
                            alignment: Alignment
                                .centerRight,
                            margin: const EdgeInsets
                                .fromLTRB(0, 4, 0, 4),
                            child: Text( controller.v_tie.value.toString(),
                                style: const TextStyle(
                                    color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24)),
                          ),
                          ),
                          Expanded(flex: 1, child: Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                            child: const Text('무',
                              style: TextStyle(
                                  color: Colors.yellow, fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ),
                          ),
                          Expanded(flex: 1, child: Container(
                            alignment: Alignment.centerRight,
                            margin: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                            child: Text(controller.v_defeat.value.toString(),
                                style: const TextStyle(
                                    color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24)),
                          ),
                          ),
                          Expanded(flex: 1, child: Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                            child: const Text('패',
                              style: TextStyle(
                                  color: Colors.red, fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  //body 하단 전적(점수)
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: Row(
                        children: [
                          Expanded(flex: 1, child: Container(),),
                          //body 하단 전적(점수) 텍스트
                          Expanded(flex: 1, child: Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                            child: const Text('점수',
                              style: TextStyle(
                                  color: Colors.white60, fontWeight: FontWeight.bold, fontSize: 20),),
                          ),
                          ),
                          Expanded(
                            flex: 1, child: Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                            child: Text( controller.v_score.value.toString(),
                              style: const TextStyle(
                                  color: Colors.white, fontWeight: FontWeight.bold, fontSize: 28),),
                          ),
                          ),
                          Expanded(flex: 1, child: Container(),),
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