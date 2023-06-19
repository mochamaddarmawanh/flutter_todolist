import 'package:shared_preferences/shared_preferences.dart';

abstract class Data {
  Future<List<String>> getData();
  Future<void> saveData(List<String> tasks);
}

class SharedPreferencesData extends Data {
  @override
  Future<List<String>> getData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> tasks = prefs.getStringList('tasks') ?? [];
    return tasks;
  }

  @override
  Future<void> saveData(List<String> tasks) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('tasks', tasks);
  }
}

// ================ polimerfisme ================

// abstract class Animal {
//   void makeSound();
// }

// class Dog extends Animal {
//   void makeSound() {
//     print("Dog barks");
//   }
// }

// class Cat extends Animal {
//   void makeSound() {
//     print("Cat meows");
//   }
// }

// class Cow extends Animal {
//   void makeSound() {
//     print("Cow moos");
//   }
// }

// void main() {
//   List<Animal> animals = [Dog(), Cat(), Cow()];

//   for (Animal animal in animals) {
//     animal.makeSound();
//   }
// }

// Dog barks
// Cat meows
// Cow moos