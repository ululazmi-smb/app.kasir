class Menu {
  final String id;
  final String title;
  final String description;
  final String image;
  final int price;
  int quantity; // Tambahkan properti quantity

  Menu({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.price,
    this.quantity = 0, // Atur nilai default quantity menjadi 0
  });
}
