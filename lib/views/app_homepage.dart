import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../model/attraction_list_item.dart'; // Importa il modello
import '../views/widgets/attraction_list.dart'; // Importa il widget AttractionList
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
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      });

      // Mostra una schermata vuota durante il reindirizzamento
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Se l'utente è autenticato, mostra la griglia delle attrazioni
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tripsphere'),
        actions: [
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
      body: const AttractionGrid(), // Usa il widget AttractionGrid
    );
  }
}

class AttractionGrid extends StatefulWidget {
  const AttractionGrid({super.key});

  @override
  _AttractionGridState createState() => _AttractionGridState();
}

class _AttractionGridState extends State<AttractionGrid> {
  List<AttractionListItem> attractions = [];

  @override
  void initState() {
    super.initState();
    loadAttractions();
  }

  Future<void> loadAttractions() async {
    try {
      // Carica il file JSON dalle assets
      final String response = await rootBundle.loadString(
        'assets/attractions.json',
      );
      final Map<String, dynamic> data = json.decode(response);
      final List<dynamic> attractionList = data['attractionList'];

      // Mappa i dati JSON in una lista di AttractionListItem
      setState(() {
        attractions =
            attractionList
                .map(
                  (json) =>
                      AttractionListItem(name: json['name'], url: json['url']),
                )
                .toList();
      });
    } catch (e) {
      print('Errore nel caricamento del JSON: $e');
    }
  }

  Future<void> _reloadPage() async {
    setState(() {
      attractions = []; // Resetta la lista delle attrazioni
    });
    await loadAttractions(); // Ricarica le attrazioni
  }

  @override
  Widget build(BuildContext context) {
    return attractions.isEmpty
        ? const Center(
          child: CircularProgressIndicator(),
        ) // Mostra un indicatore di caricamento
        : Column(
          children: [
            Expanded(
              child: AttractionList(
                attractionList:
                    attractions, // Passa la lista delle attrazioni al widget AttractionList
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FloatingActionButton(
                onPressed: _reloadPage, // Bottone per ricaricare la pagina
                child: const Icon(Icons.refresh),
              ),
            ),
          ],
        );
  }
}
