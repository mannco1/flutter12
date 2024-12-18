import 'package:flutter/material.dart';
import 'package:pks/components/global.dart';
import 'package:pks/pages/cart.dart';
import 'package:pks/pages/home_page.dart';
import 'package:pks/pages/favourite.dart';
import 'package:pks/pages/profile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'components/account.dart';
GlobalData appData = GlobalData();
Future<void> main() async {
  await Supabase.initialize(url: 'https://vochvgkwxupvkwfdfpci.supabase.co', anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZvY2h2Z2t3eHVwdmt3ZmRmcGNpIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzMwNjk4OTQsImV4cCI6MjA0ODY0NTg5NH0.AlkZEVl4hHEtpmWAvQ97YqoT_gqaA02Sk3R7h_bCkz0'
  );
  runApp(const MyApp());
}
class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int selectedIndex = 0;
  List<Widget> pages = [HomePage(), Favourite(),Cart(),AuthGate()];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'xdd',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent, brightness: Brightness.light),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Аптечка"),
        ),
        body: pages[selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          items:const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.medication_liquid_outlined), label: "Товары"),
            BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Избранное"),
            BottomNavigationBarItem(icon: Icon(Icons.shopping_cart),label: "Корзина"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Профиль")
          ],
          selectedItemColor: Colors.lightBlueAccent,
          unselectedItemColor: Colors.blueGrey,
          currentIndex: selectedIndex,
          useLegacyColorScheme: true,
          onTap: (int barItemIndex) => {
            setState(() {
              selectedIndex = barItemIndex;
            })
          },
        ),
      ),
    );
  }
}