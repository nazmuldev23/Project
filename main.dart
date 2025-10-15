import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

/// --------------------
/// 🌈 Animated Gradient SplashScreen
/// --------------------
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  // Gradient Colors
  final List<Color> _colors1 = [Colors.blueAccent, Colors.blue[900]!];
  final List<Color> _colors2 = [Colors.lightBlue, Colors.indigo];

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _controller.forward();

    //  WeatherScreen
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WeatherScreen()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.lerp(_colors1[0], _colors2[0], _controller.value)!,
                  Color.lerp(_colors1[1], _colors2[1], _controller.value)!,
                ],
              ),
            ),
            child: Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.cloudy_snowing, size: 120, color: Colors.white),
                      SizedBox(height: 20),
                      Text(
                        "Weather Monitoring Apps",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 15),
                      CircularProgressIndicator(color: Colors.white),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// --------------------
/// 🌤️ Weather Screen
class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String city = "Dhaka";
  double? temperature;
  double? tempMax;
  double? tempMin;
  String condition = "";
  bool isLoading = false;

  List<dynamic> forecast = [];

  final TextEditingController _controller = TextEditingController();

  final String apiKey = "89a9a6b1cb08a2c7feab2e08cd299be5";

  Future<void> fetchWeather(String cityName) async {
    setState(() {
      isLoading = true;
      city = cityName;
    });

    final url = Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          temperature = data["main"]["temp"];
          tempMax = data["main"]["temp_max"];
          tempMin = data["main"]["temp_min"];
          condition = data["weather"][0]["main"];
          city = data["name"];
        });
      } else {
        setState(() {
          condition = "City not found!";
          temperature = null;
        });
      }
    } catch (e) {
      setState(() {
        condition = "Error: $e";
        temperature = null;
      });
    }

    await fetchForecast(cityName);

    setState(() {
      isLoading = false;
    });
  }

  Future<void> fetchForecast(String cityName) async {
  final url = Uri.parse(
      "https://api.openweathermap.org/data/2.5/forecast?q=$cityName&appid=$apiKey&units=metric");

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        //forecast = data["list"]; // 5 days
        forecast = data["list"].take(12).toList(); // 5 hours
      });
    }
  } catch (e) {
    debugPrint("Forecast error: $e");
  }
}



  @override
  void initState() {
    super.initState();
    fetchWeather(city);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        title: const Text("Weathers Monitoring Apps"),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.white),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: "Enter city name...",
                            hintStyle: const TextStyle(color: Colors.black),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.2),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.search, color: Colors.white),
                        onPressed: () {
                          if (_controller.text.isNotEmpty) {
                            fetchWeather(_controller.text);
                          }
                        },
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.cloudy_snowing, size: 100, color: Colors.white),
                      const SizedBox(height: 20),
                      Text(
                        temperature != null
                            ? "${temperature!.toStringAsFixed(1)}°C"
                            : "--°C",
                        style: const TextStyle(
                          fontSize: 50,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Max: ${tempMax?.toStringAsFixed(1) ?? "--"}°C   "
                        "Min: ${tempMin?.toStringAsFixed(1) ?? "--"}°C",
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 18),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        city,
                        style: const TextStyle(
                            color: Colors.white, fontSize: 26),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        condition,
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 20),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 140,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: forecast.length,
                    itemBuilder: (context, index) {
                      final hourData = forecast[index];
                      final time =
                          hourData["dt_txt"].toString().substring(11, 16);
                      final temp = hourData["main"]["temp"];
                      final icon = hourData["weather"][0]["icon"];

                      return Container(
                        width: 100,
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(time,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 16)),
                            const SizedBox(height: 8),
                            Image.network(
                              "https://openweathermap.org/img/wn/$icon@2x.png",
                              width: 50,
                              height: 50,
                            ),
                            const SizedBox(height: 8),
                            Text("${temp.toStringAsFixed(0)}°C",
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 18)),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

