// Path: lib/screens/scratchpad_screen.dart

import 'package:flutter/material.dart';
import 'package:signature/signature.dart'; // Çizim paketi
import 'package:flutter_math_fork/flutter_math.dart'; // Soruyu göstermek için

class ScratchpadScreen extends StatefulWidget {
  final String questionTex; // Soruyu buraya taşıyacağız

  const ScratchpadScreen({super.key, required this.questionTex});

  @override
  State<ScratchpadScreen> createState() => _ScratchpadScreenState();
}

class _ScratchpadScreenState extends State<ScratchpadScreen> {
  // Çizim kontrolcüsü (Kalem rengi, kalınlığı vb.)
  late SignatureController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SignatureController(
      penStrokeWidth: 3, // Kalem kalınlığı
      penColor: Colors.white, // Tebeşir rengi :)
      exportBackgroundColor: Colors.black87,
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // Bellek sızıntısını önlemek için dispose etmeliyiz
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87, // Koyu tema (Kara tahta)
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Scratchpad", style: TextStyle(color: Colors.white)),
        actions: [
          // Temizle Butonu
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
            onPressed: () {
              _controller.clear();
            },
          ),
          // Onayla/Kapat Butonu
          IconButton(
            icon: const Icon(Icons.check, color: Colors.greenAccent),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // --- REFERENCE QUESTION AREA ---
          // Kullanıcı işlem yaparken soruyu görsün
          Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            color: Colors.grey[900],
            width: double.infinity,
            child: Center(
              child: Math.tex(
                widget.questionTex,
                textStyle: const TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
          ),

          // --- DRAWING AREA ---
          Expanded(
            child: Signature(
              controller: _controller,
              backgroundColor: Colors.black87, // Arka plan rengi
              height: double.infinity, // Kalan tüm alanı kapla
              width: double.infinity,
            ),
          ),
        ],
      ),
    );
  }
}
