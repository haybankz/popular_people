import 'package:flutter_dotenv/flutter_dotenv.dart';

class Strings {
  static String baseUrl = "https://api.themoviedb.org/3";
  static String apiKey = dotenv.env['API_KEY'] ?? "";
  static String imageStorageUrl = dotenv.env["IMAGE_STORAGE_URL"] ?? "";
  static const String noInternet = "No Internet connection";
  static const connectionTimeOut = "Connection timeout";
  static const connectionCancelled = "Connection was cancelled";
  static const unableToFetch = "Unable to fetch resource";
  static const parsing = "Unable to read server response";
  static const heroTag = "hero-tag";
}
