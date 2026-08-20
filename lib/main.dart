import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(QuoteVerseApp());
}

class QuoteVerseApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QuoteVerse',
      theme: ThemeData(
        primaryColor: Colors.deepPurple,
      ),
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;

  final List<Map<String, String>> quotes = [
    {"text": "Mehnat itni karo ki kismat bhi kahe, ab tera haq banta hai.", "cat": "Motivation"},
    {"text": "Waqt sabko milta hai zindagi badalne ke liye, par zindagi dobara nahi milti waqt badalne ke liye.", "cat": "Life"},
    {"text": "Attitude to apna bhi khatarnak hai, jise bhulaya usse bhula diya.", "cat": "Attitude"},
    {"text": "Mohabbat karna asan hai, nibhana mushkil.", "cat": "Love"},
    {"text": "Sabr rakho, behtar waqt zarur aayega.", "cat": "Sukoon"},
  ];

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/6300978111',
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) => setState(() => _isAdLoaded = true),
        onAdFailedToLoad: (ad, err) => ad.dispose(),
      ),
    )..load();
  }

  void _copy(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Copied ✓'), backgroundColor: Colors.deepPurple),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QuoteVerse ✨', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: quotes.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(quotes[index]["text"]!),
                    subtitle: Text("#${quotes[index]["cat"]!}"),
                    trailing: IconButton(
                      icon: Icon(Icons.copy, color: Colors.deepPurple),
                      onPressed: () => _copy(quotes[index]["text"]!),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_isAdLoaded) Container(height: 60, child: AdWidget(ad: _bannerAd!)),
        ],
      ),
    );
  }
}