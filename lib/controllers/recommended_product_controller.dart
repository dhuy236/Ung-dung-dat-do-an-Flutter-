import 'package:my_app/data/repository/popular_product_repo.dart';
import 'package:get/get.dart';
import 'package:my_app/data/repository/recommended_product_repo.dart';
import 'package:my_app/models/products_model.dart';
import 'package:http/http.dart' as http;



class RecommendedProductController extends GetxController{
  final RecommendedProductRepo recommendedProductRepo;
  RecommendedProductController({required this.recommendedProductRepo});
  List<ProductModel> _recommendedProductList=[];
  List<ProductModel> get recommendedProductList => _recommendedProductList;

  bool _isLoaded = false;
  bool get isLoaded=>_isLoaded;

  Future<void> getRecommendedProductList()async{
   Response response = await recommendedProductRepo.getRecommendedProductList();
   if(response.statusCode==200){
    print("got products recommended");
    _recommendedProductList=[];
    _recommendedProductList.addAll(Product.fromJson(response.body).Products);
    //print(_popularProductList);
    _isLoaded=true;
    update();
   }else{

   }
  }

}