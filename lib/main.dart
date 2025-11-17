import 'package:flutter/material.dart';
import 'movie_service.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();   
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  print("Firebase integrado");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Widgets Demo',
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MovieService movieService = MovieService();
  List movies = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  void fetchMovies() async {
    final fetchedMovies = await movieService.searchMovies('Musical'); 
    setState(() {
      movies = fetchedMovies;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('¡Bienvenido a Flutter!'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            'https://www.shutterstock.com/blog/wp-content/uploads/sites/5/2021/01/masterclass-cover2.jpg',
            fit: BoxFit.cover,
          ),

          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 60),
                const Text(
                  '¡Bienvenido a El Catálogo de Películas!',
                  style: TextStyle(
                    color: Color.fromARGB(255, 146, 215, 225),
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Catálogo de Películas',
                  style: TextStyle(
                    color: Color.fromARGB(255, 95, 231, 46),
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 40),

                isLoading
                    ? const CircularProgressIndicator()
                    : movies.isEmpty
                        ? const Text(
                            'No se encontraron películas',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          )
                        : ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: movies.length,
                            itemBuilder: (context, index) {
                              final movie = movies[index];
                              return Card(
                                color: Colors.white70,
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                child: ListTile(
                                  leading: movie['Poster'] != 'N/A'
                                      ? Image.network(movie['Poster'], width: 50)
                                      : const Icon(Icons.movie),
                                  title: Text(movie['Title']),
                                  subtitle: Text('Año: ${movie['Year']}'),
                                ),
                              );
                            },
                          ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
