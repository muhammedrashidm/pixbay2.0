import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:picbay2/models/image_modal.dart';
import 'package:picbay2/providers/initial_data_provider.dart';
import 'package:picbay2/screens/fav_image_screen.dart';
import 'package:picbay2/screens/image_expanded_view.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int page;

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textEditingController = TextEditingController();
  @override
  void initState() {
    _textEditingController.text = '';
    page = 1;
    Timer(const Duration(seconds: 1), () {
      _getData();
    });

    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          page++;
        });
        _getMoreData();
      }
    });
  }

  _getData() async {
    context
        .read<InitialDataProvider>()
        .getInitList(1, _textEditingController.text);
  }

  _getMoreData() async {
    context
        .read<InitialDataProvider>()
        .getMoreList(page, _textEditingController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<InitialDataProvider>(
        builder: (BuildContext context, initialImageData, Widget? child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
                color: Colors.amber,
                height: 100,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: SizedBox(
                        width: 100,
                        child: TextField(
                          controller: _textEditingController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.amberAccent,
                            focusColor: Colors.amberAccent,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 10),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(width: 0.5),
                              gapPadding: 2,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            hintText: 'Enter a search term',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                        onTap: () => _getData(),
                        child: const Icon(
                          Icons.search,
                          size: 35,
                        )),
                    const SizedBox(
                      width: 20,
                    ),
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const FavImages()),
                          );
                        },
                        child: Stack(
                          children: [
                            const Icon(
                              Icons.favorite,
                              size: 35,
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                decoration: const BoxDecoration(
                                    color: Colors.blueGrey,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                width: 20,
                                height: 20,
                                child: Center(
                                  child: Text(
                                    initialImageData.faveImages.length
                                        .toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ))
                  ],
                ),
              ),
              Expanded(
                  child: initialImageData.list.isEmpty
                      ? _errorBuilder(initialImageData)
                      : _successBuilder(initialImageData))
            ],
          );
        },
      ),
    );
  }

  Widget _successBuilder(InitialDataProvider initialImageData) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      child: GridView.builder(
          padding: const EdgeInsets.only(top: 10),
          controller: _scrollController,
          itemCount: initialImageData.list.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2),
          itemBuilder: (context, index) {
            List<ImageModal> images = initialImageData.list;
            ImageModal image = images[index];
            List<ImageModal> favImages = [];
            if (initialImageData.faveImages.isNotEmpty) {
              favImages = initialImageData.faveImages;
            }
            var exist = favImages.where((element) {
              return element.id == images[index].id;
            });
            if (index == images.length - 1) {
              return Container(
                  height: 20, child: const CupertinoActivityIndicator());
            }

            return Stack(
              children: [
                Positioned(
                  child: GestureDetector(
                    onTap: () {
                      initialImageData.setCurrentImage(image);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ImageView()),
                      );
                    },

                    // NetworkImage(
                    //           initialImageData.list[index].largeImageUrl
                    //               .toString(),
                    //         )
                    child: Hero(
                      tag: 'image${image.id}',
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        height: 25,
                        width: 25,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: FadeInImage.assetNetwork(
                              image: initialImageData.list[index].largeImageUrl
                                  .toString(), placeholder: '',
                            ).image,
                          ),
                        ),
                      ),
                    ),
                  ),
                  right: 0,
                  left: 0,
                  top: 0,
                  bottom: 0,
                ),
                Positioned(
                  child: GestureDetector(
                    onTap: () {
                      exist.isNotEmpty
                          ? initialImageData
                              .removeFromFav(initialImageData.list[index])
                          : initialImageData
                              .setFaveImage(initialImageData.list[index]);
                    },
                    child: Container(
                      child: Icon(
                        exist.isNotEmpty
                            ? Icons.favorite
                            : Icons.favorite_outline,
                        size: 30,
                        color: Colors.white,
                      ),
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.white70),
                      padding: const EdgeInsets.all(1),
                    ),
                  ),
                  bottom: 10,
                  right: 10,
                )
              ],
            );
          }),
    );
  }

  Widget _errorBuilder(InitialDataProvider initialImageData) {
    if (initialImageData.error) {
      return Center(
          child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Network Eror'),
            ElevatedButton(
                onPressed: () {
                  _getData();
                },
                child: const Text('Retry'))
          ],
        ),
      ));
    }
    if (initialImageData.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return const Center(child: Text('Looks Like Nothing Found'));
  }
}




// context
//                                         .read<InitialDataProvider>()
//                                         .faveImages!
//                                         .length
//                                         .toString(),