import 'package:book_exchage2/main.dart';

class CartModule{

  Future <List<Map<String,dynamic>>?>getCartItems()async{
    if (cartItems.isNotEmpty){
      return cartItems;
    }else{
      return null;
    }
  }

  Future<String>addToCart(Map<String,dynamic>item)async{
    if (item!=null && item.isNotEmpty){
      if(cartItems.isEmpty==true){
        try{
          cartItems.add(item);
          return 'Items Added Successfully';
        }catch(e){
          return 'Cannot Add this item at this time';
        }
      }else{
        try{
          bool exist = false;
          for(int i = 0 ; i<cartItems.length;i++){
            if(cartItems[i]['BookISBN']==item['BookISBN']){
              exist = true;
            }
          }
          if (exist == false){
            cartItems.add(item);
            return 'Items Added Successfully';
          }else{
            return 'Items Already In Your Cart';
          }
        }catch(e){
          return 'Cannot Add this item at this time';
        }
      }
    }else{
      return 'Cannot Add this item at this time';
    }
  }

  int getCartItemsQTY(){
    try{
      if(cartItems.isNotEmpty){
        return cartItems.length;
      }else{
        return 0;
      }
    }catch(e){
      return 0;
    }
  }

  Future<bool>removeFromCart(int itemIndex)async{
    if (itemIndex!=null){
      try{
        cartItems.removeAt(itemIndex);
        return true;
      }catch(e){
        return false;
      }
    }else{
      return false;
    }
  }

  Future <double>getCartTotalExcludeVat()async{
    try{
      double total = 0.0;
      for(int i = 0 ; i<cartItems.length;i++){
        double? bookPrice=0.0;
        bookPrice =double.tryParse(cartItems[i]['BookPrice'].toString());
        total = total+bookPrice!;
      }
      return total;
    }catch(e){
      return 0.0;
    }
  }

  Future <double>getCartTotalIncludeVat()async{
    try{
      double total = 0.0;
      await getCartTotalExcludeVat().then((value){
        total = value ;
      });
    double vat = 0.15;
    return ((total*vat)+total);
    }catch(e){
      return 0.0;
    }
  }

  double getCartVATAmount(){
    try{
      double total = 0.0;
       getCartTotalExcludeVat().then((value){
        total = value ;
      });
      double vat = 0.15;
      return ((total*vat));
    }catch(e){
      return 0.0;
    }
  }
}