import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

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
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 建立 app bar
    var key = GlobalKey<_ImageBrowerState>();
    var images = <String>[
      "assets/03_2.png",
      "assets/03_3.png",
      "assets/04_3.png"
    ];
    var imgBrowser = _ImageBrowser(key, images);
    var previousBtn = IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        imgBrowser.previousImage();
      },
    );
    var nextBtn = IconButton(
      icon: const Icon(Icons.arrow_forward),
      onPressed: () {
        imgBrowser.nextImage();
      },
    );

    final widget = Center(
        child: Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        Container(
          child: imgBrowser,
        ),
        Container(
          child: Row(
            children: <Widget>[previousBtn, nextBtn],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
          margin: EdgeInsets.symmetric(vertical: 10.0),
        ),
      ],
    ),);

    final appBar = AppBar(
      title: Text("瀏覽影像"),
    );
    return Container(
      child: Scaffold(
        appBar: appBar,
        body: widget,
      ),
    );
    //throw UnimplementedError();
  }
}

class _ImageBrowser extends StatefulWidget {
  final GlobalKey<_ImageBrowerState> _key;
  List<String> _images;
  late int _imageIndex;

  _ImageBrowser(this._key, this._images) : super(key: _key) {
    _imageIndex = 0;
  }

  @override
  State<StatefulWidget> createState() => _ImageBrowerState();

  previousImage() => _key.currentState!.previousImage();

  nextImage() => _key.currentState!.nextImage();
}

class _ImageBrowerState extends State<_ImageBrowser> {
  @override
  Widget build(BuildContext context) {
    var img = PhotoView(
      imageProvider: AssetImage(widget._images[widget._imageIndex]),
      minScale: PhotoViewComputedScale.contained * 0.6,
      maxScale: PhotoViewComputedScale.covered,
      enableRotation: true,
      backgroundDecoration: BoxDecoration(
        color: Colors.white,
      ),
    );
    return img;
  }

  previousImage() {
    setState(() {
      widget._imageIndex--;
      if (widget._imageIndex < 0) {
        widget._imageIndex = widget._images.length - 1;
      }
    });
  }

  nextImage() {
    setState(() {
      widget._imageIndex++;
      if (widget._imageIndex >= widget._images.length) {
        widget._imageIndex = 0;
      }
    });
  }
}
