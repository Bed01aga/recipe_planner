import 'package:flutter/material.dart';
import 'screens/search_screen.dart';
import 'screens/favorites_screen.dart';
import 'package:flutter/services.dart';

void main() async {
  // Гарантируем инициализацию привязки виджетов
  WidgetsFlutterBinding.ensureInitialized();

  // Устанавливаем предпочтительную ориентацию — только портретный режим
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    // Если нужно разрешить портретный режим в обе стороны, можно добавить:
    // DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plánovač receptů',
      theme: ThemeData(primarySwatch: Colors.green),
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hlavní obrazovka'),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavoritesScreen()),
              );
            },
          ),
        ],
      ),
      body: SearchScreen(), // Например, здесь у нас экран поиска
    );
  }
}
