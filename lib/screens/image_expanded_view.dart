import 'package:flutter/material.dart';
import 'package:picbay2/models/image_modal.dart';
import 'package:picbay2/providers/initial_data_provider.dart';
import 'package:provider/provider.dart';

class ImageView extends StatelessWidget {
  const ImageView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<InitialDataProvider>(
      builder: (BuildContext context, value, Widget? child) {
        ImageModal? image = value.currentImage;
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.amber,
          ),
          body: Column(
            children: [
              Hero(
                tag: 'image${value.currentImage!.id}',
                child: Image.network(
                  value.currentImage!.largeImageUrl.toString(),
                  fit: BoxFit.cover,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    child: Column(
                      children: [
                        const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        ),
                        Text(image!.likes.toString()),
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      children: [
                        const Icon(
                          Icons.comment,
                          color: Colors.red,
                        ),
                        Text(image.comments.toString()),
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      children: [
                        const Icon(
                          Icons.remove_red_eye,
                          color: Colors.red,
                        ),
                        Text(image.views.toString()),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
