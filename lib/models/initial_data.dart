class InitialData {
  late String? name;
  late final String? email;
  late int unpaidOrders;

  InitialData.empty() {
    name = null;
    email = null;
    unpaidOrders = 0;
  }

  InitialData.fromJson(Map<String, dynamic> data) {
    name = data['name'];
    email = data['email'];
    unpaidOrders = data['unpaid_orders'];
  }
}
