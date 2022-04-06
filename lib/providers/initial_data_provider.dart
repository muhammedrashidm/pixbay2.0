import 'package:flutter/cupertino.dart';
import 'package:picbay2/data_repos/fav_cach_repo.dart';
import 'package:picbay2/data_repos/initial_repo.dart';
import 'package:picbay2/models/image_modal.dart';

class InitialDataProvider with ChangeNotifier {
  final InitialDataRepo initialDataRepo;
  final FaveCacheRepo faveCacheRepo;
  List<ImageModal> _list = [];
  List<ImageModal> _faveImages = [];
  ImageModal? _currentImage;
  bool _isLoading = true;
  bool _error = false;

  InitialDataProvider(
      {required this.faveCacheRepo, required this.initialDataRepo});

  List<ImageModal> get list => _list;
  bool get isLoading => _isLoading;
  bool get error => _error;
  List<ImageModal> get faveImages => _faveImages;
  ImageModal? get currentImage => _currentImage;

  void getInitList(int page, String searchTerm) async {
    _list = [];
    _isLoading = true;
    notifyListeners();
    try {
      List<ImageModal> data = await initialDataRepo.getList(page, searchTerm);
      _list.addAll(data);
    } catch (error) {
      _error = true;
    }

    _isLoading = false;
    notifyListeners();
  }

  void getMoreList(int page, String searchTerm) async {
    _isLoading = true;
    notifyListeners();
    try {
      List<ImageModal> data = await initialDataRepo.getList(page, searchTerm);
      _list.addAll(data);
    } catch (error) {
      _error = true;
    }

    _isLoading = false;
    notifyListeners();
  }

  getFavImages() => _faveImages = faveCacheRepo.getList();

  setFaveImage(ImageModal image) {
    _faveImages = faveCacheRepo.setList(image);
    notifyListeners();
  }

  removeFromFav(ImageModal image) {
    _faveImages = faveCacheRepo.removeFromList(image);
    notifyListeners();
  }

  setCurrentImage(ImageModal image) {
    _currentImage = image;
    notifyListeners();
  }
}
