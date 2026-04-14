import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// ================= GLOBAL =================
Map<String, String> user = {};
List<Map<String, dynamic>> history = [];

// Device emission factors (kg CO2 per kg base multiplier)
const Map<String, double> deviceFactors = {
  "Smartphone": 120,
  "Laptop": 200,
  "Tablet": 150,
  "TV": 300,
  "Refrigerator": 450,
  "Washing Machine": 380,
  "Air Conditioner": 500,
  "Printer": 220,
  "Router": 140,
  "Battery": 260,
  "Keyboard": 80,
  "Mouse": 60,
  "Camera": 180,
  "Monitor": 240,
  "Speaker": 160,
  "Smartwatch": 100,
};

// ================= APP =================
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'E-Waste CO2',
      theme: ThemeData(
        primaryColor: const Color(0xFF00C853),
        scaffoldBackgroundColor: const Color(0xFFF4F8FF),
        fontFamily: 'Roboto',
      ),
      home: const LoginPage(),
    );
  }
}

// ================= LOGIN =================
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final email = TextEditingController();
    final pass = TextEditingController();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [Color(0xFF2962FF), Color(0xFF00C853)]),
        ),
        child: Center(
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            margin: const EdgeInsets.all(20),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                const Text("Login",
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                TextField(controller: email, decoration: const InputDecoration(labelText: "Email")),
                TextField(controller: pass, decoration: const InputDecoration(labelText: "Password")),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green),
                  onPressed: () {
                    user["email"] = email.text;
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const MainScreen()));
                  },
                  child: const Text("Login"),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const SignupPage()));
                    },
                    child: const Text("Create Account"))
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

// ================= SIGNUP =================
class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final name = TextEditingController();
    final email = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text("Signup")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          TextField(controller: name, decoration: const InputDecoration(labelText: "Name")),
          TextField(controller: email, decoration: const InputDecoration(labelText: "Email")),
          const SizedBox(height: 20),
          ElevatedButton(
              onPressed: () {
                user["name"] = name.text;
                user["email"] = email.text;
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const MainScreen()));
              },
              child: const Text("Signup"))
        ]),
      ),
    );
  }
}

// ================= MAIN =================
int navIndex = 0;

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final pages = [
    const HomePage(),
    const HistoryPage(),
    const InfoPage(),
    const ProfilePage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[navIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.blue,
        onTap: (i) => setState(() => navIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: "Info"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

// ================= HOME =================
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String device = "Smartphone";
  int age = 1;
  double weight = 0.5;
  String method = "Recycled";

  final devices = deviceFactors.keys.toList();
  final years = List.generate(25, (i) => i + 1);

  double calculateCO2() {
    double factor = deviceFactors[device] ?? 100;
    double disposal = method == "Recycled" ? 0.6 : 1.4;
    return (weight * factor + age * 10) * disposal;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(padding: const EdgeInsets.all(16), children: [

        // HEADER CARD
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
                colors: [Color(0xFF2962FF), Color(0xFF00C853)]),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text("Enter E-Waste Details",
              style: TextStyle(color: Colors.white, fontSize: 18)),
        ),

        const SizedBox(height: 20),

        // MAIN CARD
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 10)
              ]),
          child: Column(children: [

            DropdownButtonFormField(
              value: device,
              decoration: const InputDecoration(labelText: "Device Type"),
              items: devices
                  .map((e) =>
                      DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) => setState(() => device = v!),
            ),

            Slider(
              value: weight,
              min: 0.1,
              max: 10,
              activeColor: Colors.green,
              onChanged: (v) => setState(() => weight = v),
            ),
            Text("${weight.toStringAsFixed(2)} kg"),

            DropdownButtonFormField(
              value: age,
              decoration: const InputDecoration(labelText: "Age"),
              items: years
                  .map((e) =>
                      DropdownMenuItem(value: e, child: Text("$e")))
                  .toList(),
              onChanged: (v) => setState(() => age = v!),
            ),

            DropdownButtonFormField(
              value: method,
              decoration:
                  const InputDecoration(labelText: "Disposal Method"),
              items: ["Recycled", "Not Recycled"]
                  .map((e) =>
                      DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) => setState(() => method = v!),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size(double.infinity, 50)),
              onPressed: () {
                double result = calculateCO2();

                history.add({
                  "device": device,
                  "co2": result,
                  "time": DateTime.now().toString()
                });

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ResultPage(result, device)));
              },
              child: const Text("Estimate Footprint"),
            )
          ]),
        )
      ]),
    );
  }
}

// ================= RESULT =================
class ResultPage extends StatelessWidget {
  final double co2;
  final String device;
  const ResultPage(this.co2, this.device, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Carbon Result")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          // RESULT CARD
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                const Text("Estimated Carbon Footprint"),
                Text("${co2.toStringAsFixed(0)} kg CO2",
                    style: const TextStyle(
                        fontSize: 28, fontWeight: FontWeight.bold)),
                Text("Based on $device"),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // BREAKDOWN
          Card(
            child: Column(children: [
              ListTile(title: const Text("Manufacturing"), trailing: Text("${(co2 * 0.7).toStringAsFixed(0)} kg")),
              ListTile(title: const Text("Usage"), trailing: Text("${(co2 * 0.2).toStringAsFixed(0)} kg")),
              ListTile(title: const Text("End-of-Life"), trailing: Text("${(co2 * 0.1).toStringAsFixed(0)} kg")),
            ]),
          ),

          const SizedBox(height: 20),

          // GREEN TIP
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: Colors.green.shade200,
                borderRadius: BorderRadius.circular(12)),
            child: const Text(
                "🌱 Extending device lifespan by 1 year can reduce emissions up to 30%"),
          )
        ],
      ),
    );
  }
}

// ================= HISTORY =================
class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  String search = "";

  @override
  Widget build(BuildContext context) {
    var data = history
        .where((e) =>
            e["device"].toLowerCase().contains(search.toLowerCase()))
        .toList();

    return Column(
      children: [
        TextField(
          decoration: const InputDecoration(hintText: "Search device"),
          onChanged: (v) => setState(() => search = v),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (_, i) => Card(
              color: Colors.blue.shade50,
              child: ListTile(
                title: Text(data[i]["device"]),
                subtitle: Text(data[i]["time"]),
                trailing: Text("${data[i]["co2"].toStringAsFixed(1)} kg"),
              ),
            ),
          ),
        )
      ],
    );
  }
}

// ================= INFO =================
class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  void showInfo(BuildContext context, String title, String desc, IconData icon, Color color) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 50, color: color),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(desc, style: const TextStyle(fontSize: 15)),
          ],
        ),
      ),
    );
  }

  Widget buildButton(BuildContext context,
      {required String title,
      required IconData icon,
      required Color color,
      required String desc}) {
    return GestureDetector(
      onTap: () => showInfo(context, title, desc, icon, color),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [color.withOpacity(0.8), color]),
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 8)
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 30),
            const SizedBox(width: 15),
            Expanded(
              child: Text(title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white)
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [

            const Text("Information",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),

            buildButton(
              context,
              title: "Lifecycle Emissions",
              icon: Icons.loop,
              color: Colors.blue,
              desc:
                  "Every electronic device produces emissions during manufacturing, usage, and disposal. Manufacturing creates the highest emissions due to raw material extraction. Usage contributes through electricity consumption. Proper recycling reduces environmental impact significantly.",
            ),

            buildButton(
              context,
              title: "Why E-Waste Matters",
              icon: Icons.warning,
              color: Colors.orange,
              desc:
                  "E-waste contains toxic materials like lead and mercury. Improper disposal pollutes soil and water. It affects human health and ecosystems. Recycling helps recover valuable metals and reduces environmental damage.",
            ),

            buildButton(
              context,
              title: "Proper Disposal Methods",
              icon: Icons.recycling,
              color: Colors.green,
              desc:
                  "Devices should be given to certified recycling centers. Never burn or dump electronics. Reuse or donate working devices. Recycling ensures safe material recovery and reduces pollution.",
            ),

            buildButton(
              context,
              title: "How AI Reduces Impact",
              icon: Icons.smart_toy,
              color: Colors.purple,
              desc:
                  "AI helps calculate carbon emissions accurately. It analyzes device lifecycle and usage patterns. AI suggests eco-friendly disposal options. It helps users make smarter environmental decisions.",
            ),
          ],
        ),
      ),
    );
  }
}
// ================= PROFILE =================
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [

          // HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(25),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xFF2962FF), Color(0xFF00C853)]),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
            ),
            child: Column(
              children: const [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 40, color: Colors.green),
                ),
                SizedBox(height: 10),
                Text("Profile",
                    style: TextStyle(color: Colors.white, fontSize: 20))
              ],
            ),
          ),

          const SizedBox(height: 20),

          // DETAILS CARD
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 10)
                ]),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.person, color: Colors.blue),
                  title: const Text("Name"),
                  subtitle: Text(user["name"] ?? "Not Provided"),
                ),
                ListTile(
                  leading: const Icon(Icons.email, color: Colors.green),
                  title: const Text("Email"),
                  subtitle: Text(user["email"] ?? "Not Provided"),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // LOGOUT BUTTON
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                    (route) => false);
              },
              icon: const Icon(Icons.logout),
              label: const Text("Logout"),
            ),
          )
        ],
      ),
    );
  }

}