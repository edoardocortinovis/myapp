import 'package:flutter/material.dart';
import 'package:myapp/views/home_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'auth/login_page.dart'; // Importa la pagina di login

class AppHomePage extends StatelessWidget {
  const AppHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;

    // Verifica se l'utente è autenticato
    final user = supabase.auth.currentUser;

    if (user == null) {
      // Se l'utente non è autenticato, reindirizza alla LoginPage
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      });

      // Mostra una schermata vuota durante il reindirizzamento
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Se l'utente è autenticato, mostra la AppHomePage
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        actions: [
          // Aggiungi il pulsante di logout nell'AppBar
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await supabase.auth.signOut(); // Effettua il logout
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Benvenuto nella tua App Home Page!',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
