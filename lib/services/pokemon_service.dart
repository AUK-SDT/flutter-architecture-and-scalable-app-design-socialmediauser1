import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pokemon.dart';

class PokemonService {
  static const String baseUrl = 'https://graphqlpokemon.favware.tech/v8';

  final http.Client _client;

  PokemonService({http.Client? client}) : _client = client ?? http.Client();

  Future<List<Pokemon>> fetchPokemonList({int count = 151}) async {
    final results = <Pokemon>[];
    for (var dex = 1; dex <= count; dex++) {
      final pokemon = await fetchPokemonByDexNumber(dex);
      results.add(pokemon);
    }
    return results;
  }

  Future<Pokemon> fetchPokemonByDexNumber(int number) async {
    final response = await _client.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'query':
            '''
        {
          getPokemonByDexNumber(number: $number) {
            key species num
            types { name }
            baseStats { hp attack defense specialattack specialdefense speed }
            baseStatsTotal sprite color height weight
          }
        }
        ''',
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load Pokemon: ${response.statusCode}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;

    if (data.containsKey('errors')) {
      throw Exception('GraphQL error: ${data['errors']}');
    }

    return Pokemon.fromJson(data['data']['getPokemonByDexNumber']);
  }
}
