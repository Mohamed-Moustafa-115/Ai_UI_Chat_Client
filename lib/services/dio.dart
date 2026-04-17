import 'dart:developer';

import 'package:ai_chat_client/vars.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioService {
  final Dio _dio = Dio();
  String apiKey = "";
  Future<String> sendMessage(String message) async {
    try {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 90,

          filter: (options, args) {
            // don't print requests with uris containing '/posts'
            if (options.path.contains('/posts')) {
              return false;
            }
            // don't print responses with unit8 list data
            return !args.isResponse || !args.hasUint8ListData;
          },
        ),
      );
      var response = await _dio.post(
        options: Options(
          headers: {
            "Authorization": "Bearer $apiKey",
            "Content-Type": "application/json",
          },
        ),
        "https://api.openai.com/v1/responses",
        data: {"model": "gpt-5.4-mini", "input": message},
      );

      // Try to extract a response string from the API payload
      final resp = response.data is Map && response.data.containsKey('response')
          ? response.data['response']?.toString() ?? ''
          : response.data?.toString() ?? '';
      log("Response: $resp");
      return resp;
    } on DioException catch (e) {
      print("Error: ${e.message}");
      print("Status code: ${e.response?.statusCode}");
      return '';
    } catch (e) {
      print("Unexpected error: $e");
      return '';
    }
  }

  Future<List<String>> getAvalibleModels() async {
    log("send message");
    List<String> models = [];
    try {
      var response = await _dio.get("http://localhost:11434/api/tags");
      // log("Response: ${response.data}");
      if (response.statusCode == 200) {
        var data = response.data["models"];
        for (var item in data) {
          models.add(item['name']);
        }
        log("Response: $models");
        return models;
      } else {
        print("Failed to load models. Status code: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Error: $e");
      return [];
    }
  }
}
