import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import 'package:namma_kahoot_client/namma_kahoot_client.dart';

// Since this is purely a client-side SPA in Jaspr, we connect to the local server
final client = Client('http://localhost:8080/');

final clientProvider = Provider<Client>((ref) {
  return client;
});
