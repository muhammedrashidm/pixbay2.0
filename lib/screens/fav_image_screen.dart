import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:picbay2/models/image_modal.dart';
import 'package:picbay2/providers/initial_data_provider.dart';
import 'package:picbay2/screens/image_expanded_view.dart';
import 'package:provider/provider.dart';

class FavImages extends StatelessWidget {
  const FavImages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
      ),
      body: Consumer<InitialDataProvider>(
        builder: (BuildContext context, initialImageData, Widget? child) {
          if (initialImageData.faveImages.isNotEmpty) {
            return Container(
              child: GridView.builder(
                  itemCount: initialImageData.faveImages.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemBuilder: (context, index) {
                    ImageModal image = initialImageData.faveImages[index];
                    return Stack(
                      children: [
                        Positioned(
                          child: GestureDetector(
                            onTap: () {
                              initialImageData.setCurrentImage(image);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const ImageView()),
                              );
                            },
                            child: Hero(
                              tag: 'image${image.id}',
                              child: Container(
                                margin: const EdgeInsets.all(5),
                                height: 25,
                                width: 25,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(initialImageData
                                            .faveImages[index].largeImageUrl
                                            .toString()))),
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
                              initialImageData.removeFromFav(
                                  initialImageData.faveImages[index]);
                            },
                            child: Container(
                              child: const Icon(
                                Icons.favorite,
                                size: 30,
                                color: Colors.white,
                              ),
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Colors.white70),
                              padding: EdgeInsets.all(1),
                            ),
                          ),
                          bottom: 10,
                          right: 10,
                        )
                      ],
                    );
                  }),
            );
          } else {
            return Center(
                child: Container(
              child: Text('No Images Saved so far'),
            ));
          }
        },
      ),
    );
  }
}
