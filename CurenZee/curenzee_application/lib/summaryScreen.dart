import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class SummaryScreen extends StatelessWidget {
  final Map<String, dynamic> data;
  FlutterTts flutterTts = FlutterTts();
  late int totalValue;
  SummaryScreen(this.data);

  @override
  Widget build(BuildContext context) {
    List<dynamic> detections = data['detections'] ?? [];
    print("Data received: ${detections}");

    int totalValue = detections.fold(0, (sum, item) {
      int value = int.tryParse(item['value'].toString()) ?? 0;
      int count = int.tryParse(item['count'].toString()) ?? 0;
      return sum + (value * count);
    });

    Future<void> speakTotalValue() async {
      await flutterTts.setLanguage("en-US");
      await flutterTts.setPitch(1.0);
      await flutterTts.speak("The total value is $totalValue Rupees");
    }

    return Scaffold(
      appBar: AppBar(title: Text("Summary")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F1F1),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Column(
                  children: [
                    //text start with left

                    Text(
                      "Quantity",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.start, // Align text to the left
                    ),
                    SizedBox(height: 10),
                    // Dynamic list of detections
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: detections.length,
                      itemBuilder: (context, index) {
                        var item = detections[index];
                        return Column(
                          children: [
                            Divider(color: Colors.black),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Rs. ${item['value']}",
                                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "X",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    Text(
                                      "${item['count']}",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    Divider(color: Colors.black),
                  ],
                ),
              ),
              SizedBox(height: 20),
              // Total section
              Container(
                padding: EdgeInsets.all(16),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xFFF5F1F1),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Column(
                  children: [
                    Text(
                      "Total",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Rs. $totalValue",
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                        shadows: [
                          Shadow(
                            offset: Offset(0, 4),
                            blurRadius: 4,
                            color: Color(0xFF000000).withOpacity(0.25),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              GestureDetector(
                onTap: speakTotalValue,
                child: Container(
                  width: 66,
                  height: 66,
                  decoration: BoxDecoration(
                    color: Color(0xFFD14334),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x3F000000),
                        blurRadius: 4,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(Icons.volume_up, color: Colors.white, size: 52),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
