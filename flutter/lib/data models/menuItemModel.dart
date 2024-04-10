List<MenuItem> menulist = [];

class MenuItem {
  final String name;
  final double price;
  final int count;
  final String imageUrl;
  final String description;
  final String category;

  MenuItem({
    required this.name,
    required this.price,
    required this.count,
    required this.imageUrl,
    required this.description,
    required this.category,
  });
}
