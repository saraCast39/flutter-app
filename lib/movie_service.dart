import 'dart:convert';
import 'package:http/http.dart' as http;

class MovieService {
  final String apiKey = '1bdb2aaa'; 
  final String baseUrl = 'http://www.omdbapi.com/';

  
  Future<List> searchMovies(String title) async {
    final url = Uri.parse('$baseUrl/?apikey=$apiKey&s=$title&type=movie');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['Response'] == 'True') {
        return data['Search']; 
      } else {
        return []; 
      }
    } else {
      throw Exception('Error al consultar OMDb');
    }
  }
}
