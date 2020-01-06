import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_share_content/flutter_share_content.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import  "package:jagnik/appimage.dart";

var time = DateTime.now().millisecondsSinceEpoch;
var today = DateTime.now().weekday;
var apiUrl = "http://dailybits.in/da.php?time=" + time.toString();
const days = [
  "Monday",
  "Tuesday",
  "Wednusday",
  "Thursday",
  "Friday",
  "Saturday",
  "Sunday"
];
final _random = new Random();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jagnik',
      theme: ThemeData(
        buttonTheme: ButtonThemeData(
            buttonColor: Color(0xffAA00FF),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0))),
            textTheme: ButtonTextTheme.primary),
        primarySwatch: Colors.blue,
      ),
      home: Splash(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  File _image;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  double _initialSliderHeight = 80;
  double _sliderHeight = 80;
  TabController tabController;
  TextStyle selectedTextstyle;
  String imageSource = "internet";
  GlobalKey previewContainer = new GlobalKey();
  Image _image2;
  double editBoxSize = 200.0;
  double x = 10.0;
  double y = 100.0;
  BoxDecoration editBoxDecorator = BoxDecoration(
      border: Border.all(color: Colors.lightBlueAccent, width: 2.0),
      borderRadius: BorderRadius.all(Radius.circular(5.0)));
  final String appName = "JAGNIK";
  String textToShare = "Happy ${days[today - 1]}!";
  Color _appBackgroundColor = Color(0xff880E4F);
  final textController = TextEditingController();
  String previewImage;
  double fontSize = 40.0;
  String selectedFont = "Lato";
  TextAlign textAlign = TextAlign.start;
  bool showProgressOnGenerate= false;
  String filterApplied = "default";
  Widget zoom;
  Widget oldzoom;
  List<double> filterMatrix = [
    1,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
  ];

  List backgrounds = [
    "https://images.unsplash.com/photo-1472552944129-b035e9ea3744",
    "https://images.unsplash.com/photo-1577283617116-cad711fc556d",
    "https://images.unsplash.com/photo-1577261041320-fc4ec1e6b2a2",
    "https://images.unsplash.com/photo-1577218545339-2506e153c843",
    "https://images.unsplash.com/photo-1577269330970-d4f24a498e2f",
    "https://images.unsplash.com/photo-1577318530987-f2f4b903ad37",
    "https://images.unsplash.com/photo-1577234231282-d5017c6ac8b4",
    "https://images.unsplash.com/photo-1577154881361-c957822c3a0c",
  ];

  List quotes = [
    "There is nothing permanent except change",
    "You cannot shake hands with a clenched fist",
    "Let us sacrifice our today so that our children can have a better tomorrow",
    "Learning never exhausts the mind",
    "There is no charm equal to tenderness of heart.",
    "All that we see or seem is but a dream within a dream.",
    "The only journey is the one within.",
    "Life without love is like a tree without blossoms or fruit.",
    "No act of kindness, no matter how small, is ever wasted.",
    "You can kiss yourself in the mirror, but only on the lips.",
    "It is far better to be alone, than to be in bad company.",
    "Independence is happiness.",
    "The supreme art of war is to subdue the enemy without fighting.",
    "Keep your face always toward the sunshine - and shadows will fall behind you.",
    "Being entirely honest with oneself is a good exercise.",
    "Happiness can exist only in acceptance.",
    "Love has no age, no limit, and no death.",
    "You can't blame gravity for falling in love.",
    "Honesty is the first chapter in the book of wisdom.",
    "The journey of a thousand miles begins with one step.",
    "The best preparation for tomorrow is doing your best today.",
    "Ever tried. Ever failed. No matter. Try Again. Fail again. Fail better",
    "Not all those who wander are lost.",
    "Whoever is happy will make others happy too.",
    "I have not failed. I've just found 10,000 ways that won't work.",
    "Tell me and I forget. Teach me and I remember. Involve me and I learn.",
    "There is nothing on this earth more to be prized than true friendship.",
    "There is only one happiness in this life, to love and be loved.",
    "If opportunity doesn't knock, build a door.",
    "The secret of getting ahead is getting started.",
    "Wise men speak because they have something to say, Fools because they have to say something.",
    "The World is my country, all mankind are my brethren, and to do good is my religion.",
    "Problems are not stop signs, they are guidelines.",
    "All our dreams can come true, if we have the courage to pursue them.",
    "We know what we are, but know not what we may be.",
    "It's not what you look at that matters, it's what you see.",
    "A single rose can be my garden... a single friend, my world.",
    "Friends show their love in times of trouble, not in happiness.",
    "Life is not a problem to be solved, but a reality to be experienced.",
    "The only true wisdom is in knowing you know nothing.",
    "Everything has beauty, but not everyone sees it.",
    "Believe you can and you're halfway there.",
    "The future belongs to those who believe in the beauty of their dreams.",
    "Change your thoughts and you change your world.",
    "Love isn't something you find. Love is something that finds you.",
    "Do all things with love.",
    "Where there is love there is life.",
    "Nothing is impossible, the word itself says 'I'm possible'!",
    "Try to be a rainbow in someone's cloud.",
    "It is during our darkest moments that we must focus to see the light."
  ];

  String backgroundImage =
      "https://images.unsplash.com/photo-1577261041320-fc4ec1e6b2a2";

  void initState() {
    tabController = new TabController(length: 3, vsync: this);
    selectedTextstyle =
        TextStyle(color: Colors.white, fontSize: 40, fontFamily: "Lato");
    localPath();
    textToShare = quotes[_random.nextInt(quotes.length)];
    textController.text = textToShare;
    _loadAImagesFromDownload();
    super.initState();
  }

  Future<String> _loadAImagesFromAsset() async {
    try {
      var images = await rootBundle.loadString('assets/images.json');
      var responseJSON = json.decode(images);
      return images;
    } catch (err) {
      return null;
    }
  }

  Future<List<String>> _loadAImagesFromDownload() async {
    try {
      final directory = await getExternalStorageDirectory();
      var images = await rootBundle.loadString(directory.path + '/images.json');
      var responseJSON = json.decode(images);
      List<String> img = List();
      for (var _i = 0; _i < responseJSON["images"].length; _i++) {
        img.add(responseJSON["images"][_i]);
      }
      setState(() {
        backgrounds = img;
        backgroundImage = img[0];
      });
      return img;
    } catch (err) {
      return null;
    }
  }

  List layouts = [
    {"text": "Lato"},
    {"text": "PoiretOne"},
    {"text": "Monoton"},
    {"text": "BungeeInline"},
    {"text": "ConcertOne"},
    {"text": "FrederickatheGreat"},
    {"text": "Martel"},
    {"text": "Vidaloka"}
  ];

  List fontsizes = [
    {"size": 40.0},
    {"size": 50.0},
    {"size": 60.0}
  ];

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    double _maxHeightBottomSheet = _height - _initialSliderHeight - 20;
    double _middleHeightBottomSheet = _height / 2 - _initialSliderHeight;
    var _layouts = layouts.map<Widget>((book) => _fontView(book)).toList();
    var _fontSizes = fontsizes.map<Widget>((font) {
      return Container(
          child: GestureDetector(
              onTap: () {
                setState(() {
                  fontSize = font["size"];
                  selectedTextstyle = TextStyle(
                      fontSize: font["size"],
                      fontFamily: selectedFont,
                      color: Colors.white);
                });
              },
              child: Container(
                color: Colors.blueGrey,
                alignment: Alignment.center,
                child: Text(
                  "A",
                  style: TextStyle(
                      fontSize: font["size"] - 20, color: Colors.white),
                ),
              )));
    }).toList();

    var _textAlignments = ["left", "center", "right"].map<Widget>((align) {
      return Container(
          child: GestureDetector(
        onTap: () {
          setState(() {
            textAlign = align == "left"
                ? TextAlign.left
                : align == "center" ? TextAlign.center : TextAlign.right;
          });
        },
        child: Container(
            color: Colors.blueGrey,
            child: Icon(
              align == "left"
                  ? Icons.format_align_left
                  : align == "center"
                      ? Icons.format_align_center
                      : Icons.format_align_right,
              color: Colors.white,
              size: 20,
            )),
      ));
    }).toList();

    var _sizedPad = SizedBox(
      width: 10,
      child: Container(color: Colors.blueGrey),
    );
    var menusOnFont = _fontSizes..addAll(_textAlignments);
    editBoxSize = _width - 10;
    var _backgrounds = [_pickfromGallery()]..addAll(
        backgrounds.map<Widget>((image) => _makeBackground(image)).toList());

    var _backgroundImageFromSource;
    if (imageSource == "internet")
      _backgroundImageFromSource = DecorationImage(
          colorFilter: ColorFilter.matrix(filterMatrix),
          image:
              NetworkImage(backgroundImage + "?w=" + _width.toInt().toString()),
          fit: BoxFit.cover);
    else if (imageSource == "gallery") {
      _backgroundImageFromSource = DecorationImage(
          colorFilter: ColorFilter.matrix(filterMatrix),
          image: FileImage(new File(backgroundImage)),
          fit: BoxFit.cover);
    }

    double dragPositionY = 0;
    return Scaffold(
        body: Stack(
      children: <Widget>[
//        mainBackground(context, _width, _height, _backgroundImageFromSource,
//            backgroundImage, imageSource, filterMatrix),
        buildBackground(context, _width, _height, _backgroundImageFromSource,
            backgroundImage, imageSource, filterMatrix),
        _screenShotButton(context),
        _previewDownloadedImage(),
        _appBottomSheetMenus(
            context,
            _width,
            _height,
            _middleHeightBottomSheet,
            _maxHeightBottomSheet,
            _layouts,
            _backgrounds,
            _fontSizes,
            menusOnFont),
        showProgressOnGenerate ? Center(child: CircularProgressIndicator(),) : Column()
      ],
    ));
  }

  Border _imagePreviewBorder = Border.all(color: Colors.black, width: 2.0);

  Widget _previewDownloadedImage() {
    return previewImage != null
        ? Positioned(
            bottom: 100,
            left: 5,
            child: GestureDetector(
              onTapDown: (tap) {
                setState(() {
                  _imagePreviewBorder =
                      Border.all(color: Colors.white70, width: 2.0);
                });
                share();
              },
              onTapUp: (tap) {
                setState(() {
                  _imagePreviewBorder =
                      Border.all(color: Colors.black, width: 2.0);
                });
              },
              child: Container(
                  width: 100,
                  height: 100,

                  decoration: BoxDecoration(
                      border: _imagePreviewBorder,
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black,
                            blurRadius: 10,
                            offset: Offset(0.3, 0.6))
                      ],
                      color: _appBackgroundColor,
                      shape: BoxShape.rectangle,
                      image: DecorationImage(
                          image: FileImage(new File(previewImage)),
                          fit: BoxFit.cover)
                  )

              ),
            ))
        : Container();
  }


  //Container(
  //             width: _width,
  //              height: _height,
  //              color: Colors.red,
  //
  //              child: ColorFiltered(
  //                colorFilter: ColorFilter.matrix(filterMatrix) ,
  //                child: ZoomableImage(
  //                  new AssetImage("assets/default.jpeg"),
  //                  placeholder: Center(child: CircularProgressIndicator(),),
  //
  //                ),
  //              )
  //           )


  Widget buildBackground(BuildContext context, _width, _height,
      _backgroundImageFromSource, backgroundImage, imageSource, filterMatrix) {
    return  RepaintBoundary(
      key: previewContainer,
      child: Container(
        width: _width,
        height: _height,
        child: Stack(
          children: <Widget>[
            imageSource == "internet"
                ? CachedNetworkImage(
              placeholder: (context, url) =>
                  Center(child: CircularProgressIndicator()),
              imageUrl:
              backgroundImage + "?w=" + _width.toInt().toString(),
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.matrix(filterMatrix),
                    )),
              ),
              errorWidget: (context,url,error) =>
                  Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/default.jpeg"),
                            colorFilter: ColorFilter.matrix(filterMatrix),
                            fit: BoxFit.cover)),
                  ),
            ) : Container(
                 width: _width,
                  height: _height,
                  color: Colors.black87,
                  child: ColorFiltered(
                    colorFilter: ColorFilter.matrix(filterMatrix) ,
                    child: zoom == null ? Container(): zoom
                    ,
                  )
               ),
            lyricsText(_width, _height, context),
            Positioned(
              bottom: 4,
              right: 4,
              child: Container(
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black,
                            blurRadius: 100,
                            offset: Offset(0.3, 0.6))
                      ],
                      image: DecorationImage(
                          image: AssetImage("assets/watermark.png"),
                          colorFilter: ColorFilter.matrix(filterMatrix),
                          fit: BoxFit.cover)),
                  width: 90,
                  height: 24,
                  child: Column()),
            )
          ],
        ),
      ),
    );




  }


  Widget mainBackground(BuildContext context, _width, _height,
      _backgroundImageFromSource, backgroundImage, imageSource, filterMatrix) {

    return RepaintBoundary(
      key: previewContainer,
      child: Container(
        width: _width,
        height: _height,
        child: Stack(
          children: <Widget>[
            imageSource == "internet"
                ? CachedNetworkImage(
                    placeholder: (context, url) =>
                        Center(child: CircularProgressIndicator()),
                    imageUrl:
                        backgroundImage + "?w=" + _width.toInt().toString(),
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.matrix(filterMatrix),
                      )),
                    ),
              errorWidget: (context,url,error) =>
                  Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/default.jpeg"),
                            colorFilter: ColorFilter.matrix(filterMatrix),
                            fit: BoxFit.cover)),
                  ),
                  )
                : Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: FileImage(new File(backgroundImage)),
                            colorFilter: ColorFilter.matrix(filterMatrix),
                            fit: BoxFit.cover)),
                  ),
            lyricsText(_width, _height, context),
            Positioned(
              bottom: 4,
              right: 4,
              child: Container(
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black,
                            blurRadius: 100,
                            offset: Offset(0.3, 0.6))
                      ],
                      image: DecorationImage(
                          image: AssetImage("assets/watermark.png"),
                          colorFilter: ColorFilter.matrix(filterMatrix),
                          fit: BoxFit.cover)),
                  width: 90,
                  height: 24,
                  child: Column()),
            )
          ],
        ),
      ),
    );
  }

  Widget _screenShotButton(BuildContext context) {
    return Positioned(
      top: 30,
      right: 20,
      child: RaisedButton(
        disabledColor: Colors.grey,
        child: Text(
          'Generate',
          style: TextStyle(fontSize: 12),
        ),
        onPressed: () {
          if(!showProgressOnGenerate){
            FocusScope.of(context).requestFocus(FocusNode());
            takeScreenShot(context);

          }
        },
      ),
    );
  }

  Widget _appBottomSheetMenus(
      BuildContext context,
      _width,
      _height,
      _middleHeightBottomSheet,
      _maxHeightBottomSheet,
      _layouts,
      _backgrounds,
      _fontSizes,
      menusOnFont) {
    return Positioned(
      bottom: 0,
      child: Container(
        width: _width,
        decoration: BoxDecoration(shape: BoxShape.rectangle, boxShadow: [
          BoxShadow(
              spreadRadius: 100.0,
              offset: Offset(0, 60),
              color: Color.fromARGB(150, 0, 0, 0),
              blurRadius: 100.0)
        ]),
        child: Column(
          children: <Widget>[
            _bottomSheetScrollButton(context, _width, _height,
                _middleHeightBottomSheet, _maxHeightBottomSheet),
            ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25.0)),
              child: AnimatedContainer(
                duration: Duration(seconds: 1),
                curve: Curves.fastLinearToSlowEaseIn,
                width: _width,
                height: _sliderHeight,
                color: Colors.transparent,
                child: Container(
                  child: Column(
                    children: <Widget>[
                      new TabBar(controller: tabController, tabs: [
                        new Tab(icon: const Icon(Icons.filter_vintage)),
                        new Tab(icon: const Icon(Icons.font_download)),
                        new Tab(icon: const Icon(Icons.image))
                      ]),
                      Expanded(
                          child: SizedBox(
                              child: new TabBarView(
                                  controller: tabController,
                                  children: [
                            _filterList(),
                            CustomScrollView(
                              primary: false,
                              slivers: <Widget>[
                                SliverPadding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 10, 20, 0),
                                  sliver: SliverGrid.count(
                                      crossAxisSpacing: 20,
                                      mainAxisSpacing: 10,
                                      crossAxisCount: 6,
                                      children: menusOnFont),
                                ),
                                SliverPadding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 10, 20, 30),
                                  sliver: SliverGrid.count(
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                      crossAxisCount: 3,
                                      children: _layouts),
                                ),
                              ],
                            ),
                            CustomScrollView(
                              primary: false,
                              slivers: <Widget>[
                                SliverPadding(
                                  padding: const EdgeInsets.all(20),
                                  sliver: SliverGrid.count(
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                      crossAxisCount: 3,
                                      children: _backgrounds),
                                ),
                              ],
                            )
                          ])))
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _bottomSheetScrollButton(BuildContext context, _width, _height,
      _middleHeightBottomSheet, _maxHeightBottomSheet) {
    return
      GestureDetector(
          onTap: () {
            setState(() {
              _sliderHeight = _sliderHeight == _initialSliderHeight
                  ? _middleHeightBottomSheet
                  : _sliderHeight == _maxHeightBottomSheet
                  ? _initialSliderHeight
                  : _maxHeightBottomSheet;
            });
          },
          onVerticalDragUpdate: (drag) {
            setState(() {
              _sliderHeight = drag.globalPosition.dy < _height - 30
                  ? _height - drag.globalPosition.dy
                  : _initialSliderHeight;
            });
          },
          onVerticalDragEnd: (drag) {
            setState(() {
              _sliderHeight = _sliderHeight > _height / 2
                  ? _maxHeightBottomSheet
                  : _sliderHeight > _height / 3
                  ? _middleHeightBottomSheet
                  : _initialSliderHeight;
            });
          },
        child:
      Container(
        width: _width,
        alignment: Alignment.center,
          child: Container(
              width: 140,
              height: 40,
              color: Colors.transparent,
              child: Padding(
                  padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child:

                  RotatedBox(
                    quarterTurns: _sliderHeight == _maxHeightBottomSheet ? 3 : 1,
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: Icon(
                        Icons.first_page,
                        color: Colors.white70,
                        size: 30,
                      ),
                    ),
                  ))),
      )
    );
  }

  Widget _makeBackground(image) {
    return GestureDetector(
      onTap: () {
        setState(() {
          imageSource = "internet";
          backgroundImage = image;
        });
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.blueGrey,
          shape: BoxShape.rectangle,
        ),
        child: CachedNetworkImage(
          placeholder: (context, url) => CircularProgressIndicator(),
          imageUrl: image + "?w=120",
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
                image:
                    DecorationImage(image: imageProvider, fit: BoxFit.cover)),
          ),
          errorWidget: (context, url, error) =>Container(
            child: Icon(Icons.error,color: Colors.white70,),
          ),
        ),
      ),
    );
  }

  Widget _pickfromGallery() {
    return GestureDetector(
      onTap: () {
        setState(() {
          zoom = null;
        });
        getImageFromGallery();
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Color.fromARGB(200, 102, 153, 204),
          shape: BoxShape.rectangle,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.camera,
              size: 50,
              color: Colors.white,
            ),
            Text(
              "Gallery",
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }

  Widget _fontView(fontStyle) {
    var font;
    switch (fontStyle["text"]) {
      case "lato":
        font = TextStyle(color: Colors.white, fontSize: 40, fontFamily: "Lato");
        break;
      case "poiretOne":
        font = TextStyle(
            color: Colors.white, fontSize: 40, fontFamily: "PoiretOne");
        break;
      case "monotone":
        font =
            TextStyle(color: Colors.white, fontSize: 40, fontFamily: "Monoton");
        break;
      case "BungeeInline":
        font = TextStyle(
            color: Colors.white, fontSize: 40, fontFamily: "BungeeInline");
        break;
      case "FrederickatheGreat":
        font = TextStyle(
            color: Colors.white,
            fontSize: 40,
            fontFamily: "FrederickatheGreat");
        break;
      case "ConcertOne":
        font = TextStyle(
            color: Colors.white, fontSize: 40, fontFamily: "ConcertOne");
        break;
      case "Martel":
        font =
            TextStyle(color: Colors.white, fontSize: 40, fontFamily: "Martel");
        break;
      case "Vidaloka":
        font = TextStyle(
            color: Colors.white, fontSize: 40, fontFamily: "Vidaloka");
        break;
      default:
        font = TextStyle(color: Colors.white, fontSize: 40, fontFamily: "Lato");
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFont = fontStyle["text"];
          selectedTextstyle = TextStyle(
              color: Colors.white,
              fontSize: fontSize,
              fontFamily: fontStyle["text"]);
        });
      },
      child: selectedFont == fontStyle["text"]
          ? Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  border: Border.all(color: Colors.lightBlueAccent, width: 3)),
              child: Text(
                fontStyle["text"],
                style: font,
              ),
            )
          : Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  border: Border.all(color: Colors.grey, width: 0)),
              child: Text(
                fontStyle["text"],
                style: font,
              ),
            ),
    );
  }

  takeScreenShot(BuildContext context) async {
    setState(() {
      showProgressOnGenerate = true;
    });
    RenderRepaintBoundary boundary =
        previewContainer.currentContext.findRenderObject();
    double pixelRatio =
        MediaQuery.of(context).size.height / MediaQuery.of(context).size.width;

    ui.Image image = await boundary.toImage(pixelRatio: pixelRatio);
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();
    final directory = await getExternalStorageDirectory();
    var _file = directory.path;
    String now = DateTime.now().toString();
    now = now.split(new RegExp(r"(:|-)")).join("_");
    now = now.split(" ").join("_");
    now = now.split(".").join("_");
    String _filename = '$_file/q-$now.png';
    File imgFile = new File(_filename);
    imgFile.writeAsBytesSync(pngBytes);

//    const MethodChannel _channel = MethodChannel('image_gallery_saver');
//    print(MethodChannel);
//    await _channel.invokeMethod('saveFileToGallery', _filename);

    setState(() {
      previewImage =_filename;
      showProgressOnGenerate =false;
    });
  }

  Widget _filterList() {
    return CustomScrollView(
      primary: false,
      slivers: <Widget>[
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverGrid.count(
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 4,
            children: <Widget>[
              _filterNone(),
              _filterGrayScale(),
              _filterBrightBlack(),
              _filterBrightBlue(),
              _filterBrightYellow(),
              _filterSepia(),
              _filterKodaChrome(),
              _filterInversion(),
              _filterBrightGreen(),
              _filterBrightBlack(),
              _filterBrigh2Black(),
              _filterBrighMagenta(),
              _filterBrightFlorecent(),
              _filterBrightestBlack(),
              _filterLightpink(),
              _filterTest()
            ],
          ),
        ),
      ],
    );
  }

  Widget _filterNone() {
    List<double> _matrix = [
      1,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      0,
      1,
      0
    ];
    return _filter(_matrix, "none");
  }

  Widget _filterGrayScale() {
    List<double> _matrix = [
      0.2126,
      0.7152,
      0.0722,
      0,
      0,
      0.2126,
      0.7152,
      0.0722,
      0,
      0,
      0.2126,
      0.7152,
      0.0722,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
    ];
    return _filter(_matrix, "grayscale");
  }

  Widget _filterInversion() {
    List<double> _matrix = [
      -1,
      0,
      0,
      0,
      255,
      0,
      -1,
      0,
      0,
      255,
      0,
      0,
      -1,
      0,
      255,
      0,
      0,
      0,
      1,
      0,
    ];
    return _filter(_matrix, "invert");
  }

  Widget _filterSepia() {
    List<double> _matrix = [
      0.393,
      0.769,
      0.189,
      0,
      0,
      0.349,
      0.686,
      0.168,
      0,
      0,
      0.272,
      0.534,
      0.131,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
    ];
    return _filter(_matrix, "sepia");
  }

  Widget _filterKodaChrome() {
    List<double> _matrix = [
      1.1285582396593525,
      -0.3967382283601348,
      -0.03992559172921793,
      0,
      63.72958762196502,
      -0.16404339962244616,
      1.0835251566291304,
      -0.05498805115633132,
      0,
      24.732407896706203,
      -0.16786010706155763,
      -0.5603416277695248,
      1.6014850761964943,
      0,
      35.62982807460946,
      0,
      0,
      0,
      1,
      0
    ];
    return _filter(_matrix, "kodachrome");
  }

  Widget _filterBrightYellow() {
    List<double> _matrix = [
      10,
      45,
      0,
      1,
      1,
      2,
      0,
      0,
      0,
      4,
      1,
      0,
      0,
      0,
      7,
      0,
      0,
      0,
      1,
      0
    ];
    return _filter(_matrix, "brightblack");
  }

  Widget _filterBrightBlack() {
    List<double> _matrix = [
      0,
      1,
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      0,
      0,
      1,
      0
    ];
    return _filter(_matrix, "brightblack");
  }

  Widget _filterBrightBlue() {
    List<double> _matrix = [
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      0,
      0,
      1,
      0
    ];
    return _filter(_matrix, "brightblue");
  }

  Widget _filterBrightGreen() {
    List<double> _matrix = [
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      1,
      0
    ];
    return _filter(_matrix, "brightblue");
  }

  Widget _filterBrightFlorecent() {
    List<double> _matrix = [
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      1,
      0
    ];
    return _filter(_matrix, "brightflorecent");
  }

  Widget _filterBrightestBlack() {
    List<double> _matrix = [
      1,
      1,
      1,
      0,
      0,
      1,
      1,
      1,
      0,
      0,
      1,
      1,
      1,
      0,
      0,
      0,
      0,
      0,
      1,
      0
    ];
    return _filter(_matrix, "brightestblack");
  }

  Widget _filterBrigh2Black() {
    List<double> _matrix = [
      0,
      1,
      1,
      0,
      0,
      0,
      1,
      1,
      0,
      0,
      0,
      1,
      1,
      0,
      0,
      0,
      0,
      0,
      1,
      0
    ];
    return _filter(_matrix, "bright2black");
  }

  Widget _filterBrighMagenta() {
    List<double> _matrix = [
      0,
      0,
      1,
      1,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      1,
      1,
      0,
      0,
      0,
      0,
      1,
      0
    ];
    return _filter(_matrix, "brightmagenta");
  }

  Widget _filterLightpink() {
    List<double> _matrix = [
      0.45,
      0,
      1,
      0.5,
      .5,
      0.67,
      0.1,
      0.2,
      0,
      1,
      0,
      0,
      1,
      0.9,
      0,
      0,
      0,
      0,
      1,
      0
    ];
    return _filter(_matrix, "lightpink");
  }

  Widget _filterTest() {
    List<double> _matrix = [
      0,
      0,
      -1,
      0,
      0,
      0,
      0,
      2,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
    ];
    return _filter(_matrix, "test");
  }

  Widget _filter(_matrix, _filterName) {
    return Container(
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            image: DecorationImage(
                colorFilter: ColorFilter.matrix(_matrix),
                image: AssetImage('assets/logo.png'),
                fit: BoxFit.cover)),
        child: RaisedButton(
          color: Colors.transparent,
          onPressed: () {
            setState(() {
              filterApplied = _filterName;
              filterMatrix = _matrix;
            });
          },
        ));
  }

  Future<String> localPath() async {
    // make these changes in first launch of the app
    // check available directories
    // create an application directory too available path
    // store file path in share preferences  to save a file in shared preferences
    try {
      final directory = await getApplicationSupportDirectory();
      List externalDirectory = await getExternalStorageDirectories();
      new Directory(directory.path)
          .create(recursive: true)
          .then((Directory newdir) {
        // if error in directory creation
      });
      return directory.path;
    } catch (err) {
      return null;
    }
  }

  Widget lyricsText(_width, _height, context) {
    return Positioned(
      top: y,
      left: x,
      child: GestureDetector(
          onPanUpdate: (tap) {
            setState(() {
              if ((x + editBoxSize + tap.delta.dx - 100) < _width)
                x += tap.delta.dx;
              if ((y + tap.delta.dy) < _height) y += tap.delta.dy;
            });
          },
          onTap: () {
            showEditBox(context);
            ;
          },
          child: Container(
            width: editBoxSize,
            padding: EdgeInsets.all(10.0),
            child: Text(
              textToShare,
              style: selectedTextstyle,
              textAlign: textAlign,
            ),
          )),
    );
  }

  showEditBox(BuildContext context) {
    return showDialog(
        context: context,
        child: new AlertDialog(
          backgroundColor: Color.fromARGB(240, 200, 200, 200),
          title: new Text("Edit Text"),
          content: Container(
              height: 150,
              child: ListView(
                children: <Widget>[
                  new TextField(
                    minLines: 3,
                    controller: textController,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    autofocus: true,
                    decoration: InputDecoration(hintText: textToShare),
                    onChanged: (newVal) {
                      setState(() {
                        textToShare = newVal;
                      });
                    },
                  ),
                  Wrap(
                    alignment: WrapAlignment.end,
                    children: <Widget>[
                      RaisedButton(
                        child: Text('Done'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      )
                    ],
                  )
                ],
              )),
        ));
  }

  void share() {
    FlutterShareContent.shareContent(
        imageUrl: previewImage == null ? null : previewImage);
  }

  Future getImageFromGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image != null)
      setState(() {
        imageSource = "gallery";
        backgroundImage = image.path;
          zoom = ZoomableImage(
          FileImage(File(backgroundImage)),
          placeholder: Center(child: CircularProgressIndicator(),),
          imageName: backgroundImage,
        );
        oldzoom = zoom;
      });
    else
      if(oldzoom != null)
      setState(() {
        zoom = oldzoom;
      });
  }
}

class Splash extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    startTimer();
    super.initState();
  }

  double logoWidth= 160.0;
  bool loadingHome = true;
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    return Material(
        child: Stack(
      children: <Widget>[
        Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [Color(0xff4A148C), Color(0xffC51162)])),
            child: Center(
                child: AnimatedContainer(
            duration: Duration(milliseconds: 700),
            onEnd: (){
              setState(() {
                logoWidth = logoWidth == 160 ? 155.0 : 160;
              });
            },
            curve: Curves.easeInOut,
            width: logoWidth,
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                    color: Colors.black,
                    blurRadius: 300,
                    offset: Offset(0.3, 0.6))
              ]),
              child: Image(
                image: AssetImage("assets/logo.png"),
              ),
            ))),
        loadingHome ?
        Positioned(
          bottom: 40,
          right: _width /2,
          width: 30,
          height: 30,
          child: CircularProgressIndicator(),
        ): Column(),
        Positioned(
          bottom: 10,
          width: _width,
          child: Text("Jagnik @ 2019 ",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.0,
                fontFamily: "PoiretOne",
                fontWeight: FontWeight.w800,
                color: Colors.white70,
              )),
        )
      ],
    ));
  }

  startTimer() async {
    await _loadDefault();
    navigate();
  }

  navigate() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MyHomePage()),
    );
  }

  _loadDefault() async {
//    final directory = await getApplicationSupportDirectory();
//    List externalDirectory = await getExternalStorageDirectories();
//    await new Directory(directory.path)
//        .create(recursive: true)
//        .then((Directory newdir) {
//      // if error in directory creation
//    });
    await FetchJSON();
  }

  FetchJSON() async {
    try {
      final directory = await getExternalStorageDirectory();
      var Response = await http.get(
        apiUrl,
        headers: {"Accept": "application/json"},
      ).timeout(const Duration(seconds: 10));
      if (Response.statusCode == 200) {
        String responseBody = Response.body;
        var responseJSON = json.decode(responseBody);
        String _filename = directory.path + '/images.json';
        File imgFile = new File(_filename);
        imgFile.writeAsString(responseBody);
      }
    } catch (err) {
      print(err);
    }
    setState(() {
      loadingHome = false;
    });
    return true;
  }
}





