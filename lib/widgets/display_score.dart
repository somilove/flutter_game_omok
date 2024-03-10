import 'package:flutter/material.dart';
import 'package:omok/controller/variables.dart';
import 'package:get/get.dart';

class DisplayScore extends StatelessWidget {
  final VariablesController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return GetX<VariablesController>(
      init: VariablesController(),
      builder: (controller) =>     Container(
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
        // color: Color(0xff00194f),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.center,
                  child: const Text('전적', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),)),
            ),
            const VerticalDivider(color: Colors.white,),
            Expanded(
              flex: 4,
              child: Column(
              children: [
                //3 body 하단 전적(승무패 점수)
                Expanded(flex: 3, child: Container(
                    alignment: Alignment.center,
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
                                          fontSize: 20)),
                                )
                                ),
                                Expanded(flex: 1, child: Container(
                                  alignment: Alignment.center,
                                  // margin: const EdgeInsets
                                  //     .fromLTRB(0, 4, 0, 4),
                                  child: Text( '${controller.v_tie.value} 무',
                                      style: const TextStyle(
                                          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                                ),
                                ),
                                Expanded(flex: 1, child: Container(
                                  alignment: Alignment.center,
                                  // margin: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                                  child: Text('${controller.v_defeat.value} 패',
                                      style: const TextStyle(
                                          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                                ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Divider(color: Colors.white),
                        //body 하단 전적(점수)
                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: const EdgeInsets.only(left: 40),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                //body 하단 전적(점수) 텍스트
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.center,
                                    // margin: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                                    child: const Text('점수',
                                      style: TextStyle(
                                          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),),
                                  ),
                                ),
                                const VerticalDivider(color: Colors.white,),
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.center,
                                    // margin: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                                    child: Text( controller.v_score.value.toString(),
                                      style: const TextStyle(
                                          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),),
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
            )],
        ),
      ),
    );

  }
}