class Order {
  late String? orderNo,
      productName,
      shippingAddress,
      shippingCode,
      mobileNumber,
      price;
  late int type, status;

  Order.fromJson(Map<String, dynamic> data) {
    orderNo = data['order_no'];
    productName = data['product_name'];
    shippingAddress = data['shipping_address'];
    shippingCode = data['shipping_code'];
    mobileNumber = data['mobile_number'];
    price = data['price'].toString();
    type = data['type'];
    status = data['status'];
  }
}
