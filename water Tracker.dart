import 'package:flutter/material.dart';

import '../widget/add_water_btn.dart';

class WaterTracker extends StatefulWidget {
  const WaterTracker({super.key});

  @override
  State<WaterTracker> createState() => _WaterTrackerState();
}

class _WaterTrackerState extends State<WaterTracker> {

  int currentInTake = 0;
  final int goal = 2000;

  void waterAdd(int amount){
    setState(() {
      currentInTake = (currentInTake+amount).clamp(0, goal);
    });
  }

  void resetWater(){
    setState(() {
      currentInTake = 0;
    });
  }


  @override
  Widget build(BuildContext context) {

    double progress=(currentInTake/goal).clamp(0.0, 1.0);
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Water Tracker',
        style: TextStyle(fontSize: 20),
        ),
        backgroundColor: Colors.amberAccent,
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 30,),
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.amberAccent.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 2
                  )
                ]
              ),
              child: Column(
                children: [
                  Text("Today's InTank",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
                  SizedBox(height: 5,),
                  Text('$currentInTake LTR',style: TextStyle(
                    fontSize: 28,
                  fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),)
                ],
              ),
            ),
            SizedBox(height: 30,),


            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 150,
                  width: 150,
                  child: CircularProgressIndicator(
                    value:  progress,
                    backgroundColor: Colors.grey,
                    color: Colors.redAccent,
                    strokeWidth: 15,
                  ),
                ),
                Text('${(progress*100).toInt()}%',
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold
                ),)
              ],
            ),
            SizedBox(height: 30,),
            Wrap(
              spacing: 20,
              children: [
                water_button(
                  amount: 200,
                  icon: Icons.local_drink,
                  onClick: ()=>waterAdd(200),),
                water_button(
                  amount: 500,
                  icon: Icons.local_drink,
                  onClick: ()=>waterAdd(500),),
                water_button(
                  amount: 1000,
                  icon: Icons.local_drink,
                  onClick: ()=>waterAdd(1000),),
              ],
            ),
            SizedBox(height: 40,),

            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red
                  ),
                    onPressed: ()=>resetWater(), child: Text('Reset',style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white

                ),

                )),
              ),
            )

          ],
        ),
      ),
    );
  }
}


