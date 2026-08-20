// Sweet Candy Crush - Blast Studio - Owner: Neeraj
import 'dart:async'; import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
void main(){ WidgetsFlutterBinding.ensureInitialized(); MobileAds.instance.initialize(); runApp(SweetCandyApp());}
class SweetCandyApp extends StatelessWidget{ @override Widget build(BuildContext context){ return MaterialApp(title: 'Sweet Candy Crush - Blast Studio', home: GameScreen(), debugShowCheckedModeBanner: false);}}
class Candy{ double x,y; String emoji; Candy({required this.x, required this.y, required this.emoji});}
class GameScreen extends StatefulWidget{ @override _GameScreenState createState()=>_GameScreenState();}
class _GameScreenState extends State<GameScreen>{
List<Candy> candies=[]; int score=0, timeLeft=30; bool isPlaying=false; Timer? gameTimer, candySpawner; Random random=Random();
BannerAd? _bannerAd; InterstitialAd? _interstitialAd; bool _isBannerLoaded=false;
List<String> candyEmojis=["🍬","🍭","🍫","🍩","🧁","🍪","🍰"];
@override void initState(){ super.initState();
_bannerAd=BannerAd(adUnitId: 'ca-app-pub-3940256099942544/6300978111', size: AdSize.banner, request: AdRequest(), listener: BannerAdListener(onAdLoaded: (_)=>setState(()=>_isBannerLoaded=true), onAdFailedToLoad: (ad,err)=>ad.dispose()))..load();
InterstitialAd.load(adUnitId: 'ca-app-pub-3940256099942544/1033173712', request: AdRequest(), adLoadCallback: InterstitialAdLoadCallback(onAdLoaded: (ad)=>_interstitialAd=ad, onAdFailedToLoad: (err)=>{}));
}
void startGame(){ setState((){ score=0; timeLeft=30; candies.clear(); isPlaying=true;});
gameTimer=Timer.periodic(Duration(seconds: 1),(t){ setState(()=>timeLeft--); if(timeLeft<=0) endGame();});
candySpawner=Timer.periodic(Duration(milliseconds: 500),(t){ if(!isPlaying) return; setState((){ candies.add(Candy(x: random.nextDouble(), y: 0, emoji: candyEmojis[random.nextInt(candyEmojis.length)]));}); for(var c in candies) c.y+=0.04; candies.removeWhere((c)=>c.y>1.2);});}
void endGame(){ gameTimer?.cancel(); candySpawner?.cancel(); setState(()=>isPlaying=false); _interstitialAd?.show(); showDialog(context: context, builder: (_)=>AlertDialog(title: Text('🏆 Game Over!'), content: Text('Sweet Candy Crush - Blast Studio\nOwner: Neeraj\nScore: $score'), actions: [TextButton(onPressed: (){ Navigator.pop(context); startGame();}, child: Text('PLAY AGAIN'))]));}
@override Widget build(BuildContext context){ return Scaffold(appBar: AppBar(title: Text('Sweet Candy Crush - Blast Studio 🍬', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)), backgroundColor: Color(0xFFAD1457), foregroundColor: Colors.white, actions: [Padding(padding: EdgeInsets.all(12), child: Text('Score: $score', style: TextStyle(fontWeight: FontWeight.bold)))]),
body: Container(decoration: BoxDecoration(gradient: LinearGradient(colors: [Color(0xFFFCE4EC), Color(0xFFF8BBD0)])), child: isPlaying? Stack(children: List.generate(candies.length, (i)=>Positioned(left: MediaQuery.of(context).size.width*candies[i].x, top: MediaQuery.of(context).size.height*candies[i].y, child: GestureDetector(onTap: ()=>setState((){ score+=10; candies.removeAt(i);}), child: Text(candies[i].emoji, style: TextStyle(fontSize: 45)))))): Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.extension, size: 80, color: Color(0xFFAD1457)), SizedBox(height: 10), Text('Sweet Candy Crush', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFFAD1457))), Text('Blast Studio - By Neeraj', style: TextStyle(letterSpacing: 2)), SizedBox(height: 25), ElevatedButton(onPressed: startGame, style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFAD1457), padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15)), child: Text('PLAY NOW', style: TextStyle(color: Colors.white)))]))),
bottomNavigationBar: _isBannerLoaded? Container(height: 60, child: AdWidget(ad: _bannerAd!)): null,);}}