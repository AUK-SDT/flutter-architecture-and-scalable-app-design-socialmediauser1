import 'dart:convert';
import 'package:http/http.dart' as http;

/// A thin GraphQL client wrapping [http.Client].
/// Sends POST requests to the Favware Pokémon GraphQL API.
/// Throws [Exception] on HTTP errors or GraphQL errors in the response body.
class GraphqlClient {
  static const String _baseUrl = 'https://graphqlpokemon.favware.tech/v8';

  final http.Client _client;

  GraphqlClient({http.Client? client}) : _client = client ?? http.Client();

  /// Executes a GraphQL [gqlQuery] and returns the raw decoded response map.
  /// The caller is responsible for extracting the relevant path from `data`.
  /// Throws [Exception] if the server returns a non-200 status or if the
  /// response body contains GraphQL errors.
  Future<Map<String, dynamic>> query(String gqlQuery) async {
    final response = await _client.post(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'query': gqlQuery}),
    );

    if (response.statusCode != 200) {
      throw Exception('HTTP ${response.statusCode}: ${response.reasonPhrase}');
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;

    if (decoded.containsKey('errors')) {
      throw Exception('GraphQL error: ${decoded['errors']}');
    }

    return decoded;
  }
}