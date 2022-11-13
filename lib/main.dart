import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '瀏覽影像',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  get assets => null;

  @override
  Widget build(BuildContext context) {
    // 建立 app bar
    var key = GlobalKey<_ImageBrowserState>();
    var images = <String>[
      "assets/03_2.png",
      "assets/03_3.png",
      "assets/04_3.png",
      "assets/test_gif.gif",
    ];
    var imgBrowser = _ImageBrowser(key, images,0);
    var shareBtn = IconButton(
      icon: const Icon(Icons.share),
      onPressed: () async {
        // Share.share("test")
        // Share.shareXFiles([XFile(imgBrowser.getImageLink())]);
          final url = Uri.parse("https://raw.githubusercontent.com/221934420a/image_1031/master/${imgBrowser.getImageLink()}");
          final response = await http.get(url);
          final bytes = response.bodyBytes;
          final temp = await getTemporaryDirectory();
          final endIndex = imgBrowser.getImageLink().toString().length;
          final path = '${temp.path}${imgBrowser.getImageLink().substring(7,endIndex)}';
          print(path);
          File(path).writeAsBytesSync(bytes);
          await Share.shareFiles([path]);
        // imgBrowser.getImageLink()
      },
    );

    final widget = Center(
      child: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          InkWell(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(imgBrowser.getImageLink()),
              ));
            },
            child: Container(
              child: imgBrowser,
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            margin: const EdgeInsets.symmetric(vertical: 50.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[shareBtn],
            ),
          ),
        ],
      ),
    );

    final appBar = AppBar(
      title: const Text("瀏覽影像"),
    );
    return Scaffold(
      appBar: appBar,
      body: widget,
    );
    //throw UnimplementedError();
  }
}

class _ImageBrowser extends StatefulWidget {
  final GlobalKey<_ImageBrowserState> _key;
  final List<String> _images;
  late int _imageIndex;

  _ImageBrowser(this._key, this._images, this._imageIndex) : super(key: _key);

  @override
  State<StatefulWidget> createState() => _ImageBrowserState();

  getImageLink() {
    return _key.currentState!.getImageName();
  }
}

class _ImageBrowserState extends State<_ImageBrowser> {
  @override
  Widget build(BuildContext context) {
    // var img = PhotoView(
    //   imageProvider: AssetImage(widget._images[widget._imageIndex]),
    //   minScale: PhotoViewComputedScale.contained * 0.6,
    //   maxScale: PhotoViewComputedScale.covered,
    //   enableRotation: true,
    //   backgroundDecoration: const BoxDecoration(
    //     color: Colors.white,
    //   ),
    // );
    var img = ImageSlideshow(
      width: double.infinity,
      height: double.infinity,
      initialPage: widget._imageIndex,
      indicatorColor: Colors.blue,
        isLoop: true,
        onPageChanged: (value) {
          setState(() {
            widget._imageIndex = value;
          });
        },
        children: [
      for (var i = 0; i < widget._images.length; i++)
        Image.asset(widget._images[i]),
    ]);

    return img;
  }

  getImageName() {
    return widget._images[widget._imageIndex];
  }
}
