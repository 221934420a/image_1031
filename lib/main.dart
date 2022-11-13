import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:carousel_slider/carousel_slider.dart';

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
    var imgBrowser = _ImageBrowser(key, images, 0);
    var shareBtn = IconButton(
      icon: const Icon(Icons.share),
      onPressed: () async {
        // Share.share("test")
        // Share.shareXFiles([XFile(imgBrowser.getImageLink())]);
        final url = Uri.parse(
            "https://raw.githubusercontent.com/221934420a/image_1031/master/${imgBrowser.getImageLink()}");
        final response = await http.get(url);
        final bytes = response.bodyBytes;
        final temp = await getTemporaryDirectory();
        final endIndex = imgBrowser.getImageLink().toString().length;
        final path =
            '${temp.path}${imgBrowser.getImageLink().substring(7, endIndex)}';
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
            margin: const EdgeInsets.symmetric(vertical: 100.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    key.currentState!.previousPage();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () {
                    key.currentState!.nextPage();
                  },
                ),
              ],
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

  nextPage() {
    _key.currentState!.nextPage();
  }

  prevPage() {
    _key.currentState!.previousPage();
  }
}

class _ImageBrowserState extends State<_ImageBrowser> {
  CarouselController buttonCarouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    // var img = ImageSlideshow(
    //   width: double.infinity,
    //   height: double.infinity,
    //   initialPage: widget._imageIndex,
    //   indicatorColor: Colors.blue,
    //     isLoop: true,
    //     onPageChanged: (value) {
    //       setState(() {
    //         widget._imageIndex = value;
    //       });
    //     },
    //     children: [
    //   for (var i = 0; i < widget._images.length; i++)
    //     Image.asset(widget._images[i]),
    // ]);

    var images = <Widget>[
      for (var i = 0; i < widget._images.length; i++)
        Image.asset(widget._images[i])
    ];
    // var img = Column(
    //   children: <Widget>[
    //   CarouselSlider(
    //   items: images,
    //   options: CarouselOptions(height: double.infinity,autoPlay: false),
    //   carouselController: buttonCarouselController,
    // ),
    //     ElevatedButton(
    //       onPressed: () => buttonCarouselController.nextPage(
    //           duration: Duration(milliseconds: 300), curve: Curves.linear),
    //       child: Text('→'),
    //     )
    //   ]
    // );
    var img = CarouselSlider(
      items: images,
      options: CarouselOptions(
          height: double.infinity,
          autoPlay: false,
          onPageChanged: (value, reason) {
            setState(() {
              widget._imageIndex = value;
            });
          }),
      carouselController: buttonCarouselController,
    );
    // var img = CarouselSlider(
    //   items: images,
    //   options: CarouselOptions(height: double.infinity,autoPlay: false),
    //   carouselController: buttonCarouselController,
    // );

    return img;
  }

  nextPage() {
    buttonCarouselController.nextPage(
        duration: Duration(milliseconds: 300), curve: Curves.linear);
  }

  previousPage() {
    buttonCarouselController.previousPage(
        duration: Duration(milliseconds: 300), curve: Curves.linear);
  }

  getImageName() {
    return widget._images[widget._imageIndex];
  }
}
