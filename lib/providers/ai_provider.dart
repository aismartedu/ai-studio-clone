import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class AiProvider extends ChangeNotifier {
  String geminiKey = '';
  String groqKey = '';
  String deepseekKey = '';
  String selectedProvider = 'gemini';
  String customServer = 'https://app.aismartedu.my.id';

  AiProvider() { _loadKeys(); }

  Future<void> _loadKeys() async {
    final prefs = await SharedPreferences.getInstance();
    geminiKey = prefs.getString('gemini_key') ?? '';
    groqKey = prefs.getString('groq_key') ?? '';
    deepseekKey = prefs.getString('deepseek_key') ?? '';
    selectedProvider = prefs.getString('selected_provider') ?? 'gemini';
    customServer = prefs.getString('custom_server') ?? 'https://app.aismartedu.my.id';
    notifyListeners();
  }

  Future<void> saveApiKeys({
    required String gemini,
    required String groq,
    required String deepseek,
    required String provider,
    required String server,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('gemini_key', gemini);
    await prefs.setString('groq_key', groq);
    await prefs.setString('deepseek_key', deepseek);
    await prefs.setString('selected_provider', provider);
    await prefs.setString('custom_server', server);

    geminiKey = gemini; groqKey = groq; deepseekKey = deepseek;
    selectedProvider = provider; customServer = server;
    notifyListeners();
  }

  String get currentApiKey {
    switch (selectedProvider) {
      case 'groq': return groqKey;
      case 'deepseek': return deepseekKey;
      default: return geminiKey;
    }
  }

  Future<String> sendPromptToServer({required String prompt, File? image}) async {
    try {
      final url = '$customServer/api/chat';
      final request = http.MultipartRequest('POST', Uri.parse(url));
      request.fields['prompt'] = prompt;
      request.fields['provider'] = selectedProvider;
      request.fields['api_key'] = currentApiKey;

      if (image != null) {
        request.files.add(await http.MultipartFile.fromPath('image', image.path));
      }

      final streamed = await request.send();
      final response = await http.Response.fromStream(streamed);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['response'] ?? 'Berhasil';
      }
      return 'Error ${response.statusCode}';
    } catch (e) {
      return 'Koneksi gagal: $e';
    }
  }
}
