import 'dart:convert';

import 'package:picbay2/models/image_modal.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FaveCacheRepo {
  final SharedPreferences sharedPreferences;

  FaveCacheRepo({required this.sharedPreferences});

  List<ImageModal> setList(ImageModal data) {
    Map<int, ImageModal> _favMap = {};
    late List<String>? stringList;
    List<ImageModal>? imageList = [];
    stringList = [];
    if (sharedPreferences.containsKey('FAVE_LIST')) {
      stringList = sharedPreferences.getStringList('FAVE_LIST');
      imageList = stringListToModelList(stringList!);
      for (var item in imageList) {
        _favMap.putIfAbsent(item.id!, () => item);
      }
    }
    // ///////////////////
    if (_favMap.containsKey(data.id)) {
    } else {
      _favMap.putIfAbsent(data.id!, () => data);
    }

    List<ImageModal> filteredImages =
        _favMap.entries.map((e) => e.value).toList();
    List<String> newStringList = [];

    for (var item in filteredImages) {
      newStringList.add(imageModalToJson(item));
    }

    sharedPreferences.setStringList("FAVE_LIST", newStringList);

    return filteredImages;
  }

  List<ImageModal> stringListToModelList(List<String> data) {
    List<ImageModal> listData = [];
    data.map((e) => listData.add(ImageModal.fromJson(jsonDecode(e)))).toList();
    return listData;
  }

  List<ImageModal> getList() {
    if (sharedPreferences.containsKey('FAVE_LIST')) {
      return stringListToModelList(
          sharedPreferences.getStringList('FAVE_LIST')!);
    }
    return [];
  }

  List<ImageModal> removeFromList(ImageModal data) {
    late List<String>? stringList;
    List<ImageModal>? imageList = [];
    Map<int, ImageModal> _favMap = {};
    if (sharedPreferences.containsKey('FAVE_LIST')) {
      stringList = sharedPreferences.getStringList('FAVE_LIST');
      imageList = stringListToModelList(stringList!);
      for (var item in imageList) {
        _favMap.putIfAbsent(item.id!, () => item);
      }
    }
    // ///////////////////
    if (_favMap.containsKey(data.id)) {
      _favMap.remove(data.id!);
    } else {}

    List<ImageModal> filteredImages =
        _favMap.entries.map((e) => e.value).toList();
    List<String> newStringList = [];

    for (var item in filteredImages) {
      newStringList.add(imageModalToJson(item));
    }

    sharedPreferences.setStringList("FAVE_LIST", newStringList);

    return filteredImages;
  }
}
