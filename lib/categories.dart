import 'package:flutter/material.dart';

class CategoriesDropdownList extends StatelessWidget {
  final changeCategory;
  final Category currentCategory;
  final List<Category> categories;
  const CategoriesDropdownList(
      {this.changeCategory, this.currentCategory, this.categories});

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: Center(
        child: Column(
          children: <Widget>[
            DropdownButton(
              value: currentCategory,
              items: prepareDropdownMenuItems(categories),
              onChanged: onChangeCategory,
            ),
          ],
        ),
      ),
    );
  }

  List<DropdownMenuItem<Category>> prepareDropdownMenuItems(
      List<Category> categories) {
    List<DropdownMenuItem<Category>> items = List();
    for (Category category in categories) {
      items.add(DropdownMenuItem(
        value: category,
        child: Text(category.name),
      ));
    }
    return items;
  }

  onChangeCategory(Category selectedCategory) {
    this.changeCategory(selectedCategory);
  }
}

class Category {
  int id;
  String name;

  Category(this.id, this.name);
}

List<Category> getCategories() {
  return <Category>[
    Category(0, 'General'),
    Category(1, 'Business'),
    Category(2, 'Entertainment'),
    Category(3, 'Science'),
    Category(4, 'Health'),
    Category(5, 'Sports'),
    Category(6, 'Technology'),
  ];
}
