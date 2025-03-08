import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'views/auth/login_page.dart'; // Importa la pagina di login
import 'views/app_homepage.dart'; // Importa la tua AppHomePage
import 'utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inizializza Supabase
  await Supabase.initialize(
    url: 'https://tqaphfhrtpxiabdkuuus.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRxYXBoZmhydHB4aWFiZGt1dXVzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDEzNzE0NTAsImV4cCI6MjA1Njk0NzQ1MH0.DOZSza9EAZcj45n8vzjIvuP_Y9sNGmabGnQHBtiD4ao',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tripsphere',
      theme: tripsphereTheme, // Usa il tuo tema personalizzato
      home: const AuthWrapper(), // Controlla lo stato di autenticazione
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;

    // Verifica se l'utente è autenticato
    final user = supabase.auth.currentUser;

    if (user != null) {
      // Se l'utente è autenticato, mostra la AppHomePage
      return const AppHomePage();
    } else {
      // Altrimenti, mostra la LoginPage
      return const LoginPage();
    }
  }
}
