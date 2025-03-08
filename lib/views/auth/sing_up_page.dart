import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'login_page.dart'; // Importa la pagina di accesso

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _firstNameController =
      TextEditingController(); // Controller per il nome
  final _lastNameController =
      TextEditingController(); // Controller per il cognome
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _supabase = Supabase.instance.client;

  Future<void> _signUp() async {
    try {
      // Registra l'utente con email e password
      final response = await _supabase.auth.signUp(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (response.user != null) {
        // Salva i dati dell'utente nella tabella `utenti`
        await _supabase
            .from('utenti') // Nome della tabella
            .upsert({
              'uuid': response.user!.id, // Usa l'UUID nella colonna `uuid`
              'nome': _firstNameController.text,
              'cognome': _lastNameController.text,
              'email': _emailController.text,
              // Non memorizzare la password in chiaro!
            });

        // Mostra un messaggio di successo
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registrazione completata!')),
        );

        // Reindirizza l'utente alla pagina di accesso (LoginPage)
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Errore durante la registrazione: $e')),
      );
      setState(() {}); // Forza il reload della pagina
      // Mostra un messaggio di errore
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrati')),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 3,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Campo Nome
                TextField(
                  controller: _firstNameController,
                  decoration: InputDecoration(
                    labelText: 'Nome',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                ),
                const SizedBox(height: 20),

                // Campo Cognome
                TextField(
                  controller: _lastNameController,
                  decoration: InputDecoration(
                    labelText: 'Cognome',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                ),
                const SizedBox(height: 20),

                // Campo Email
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                ),
                const SizedBox(height: 20),

                // Campo Password
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                ),
                const SizedBox(height: 20),

                // Bottone Registrati
                ElevatedButton(
                  onPressed: _signUp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange, // Colore arancione
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Registrati',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
