

import 'dart:io';

import 'package:ecommerce_app/db/db_helper.dart';
import 'package:ecommerce_app/models/product_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

import '../models/category_model.dart';

class ProductProvider extends ChangeNotifier {
  List<CategoryModel> categoryList = [];
  Future<void> addCategory(String name) {
    final category = CategoryModel(name: name);
    return DbHelper.addCategory(category);
  }
  Future<void> addProduct(ProductModel productModel) {
    return DbHelper.addProduct(productModel);
  }

  getAllCategorise() {
    DbHelper.getAllCategorise().listen((snapshot) {
      categoryList = List.generate(snapshot.docs.length,
          (index) => CategoryModel.fromJson(snapshot.docs[index].data()));
      notifyListeners();
    });
  }
  Future<String>uploadImage(String path)async{
    final imageName='Image_${DateTime.now().microsecondsSinceEpoch}';
    final photoRef=FirebaseStorage.instance.ref()
    .child('Picture/$imageName');
    final uploadTask =photoRef.putFile(File(path));
    final snapshot=await uploadTask.whenComplete(() => null);
    return snapshot.ref.getDownloadURL();
  }
}
