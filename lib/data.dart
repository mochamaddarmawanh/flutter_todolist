import 'package:shared_preferences/shared_preferences.dart';

abstract class Data {
  Future<List<String>> getData();
  Future<void> saveData(List<String> tasks);
}

class SharedPreferencesData extends Data {
  @override
  Future<List<String>> getData() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> tasks = prefs.getStringList('tasks') ?? [];
      return tasks;
    } catch (e) {
      print('Error getting data: $e');
      return []; // Mengembalikan daftar kosong jika terjadi kesalahan
    }
  }

  @override
  Future<void> saveData(List<String> tasks) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('tasks', tasks);
    } catch (e) {
      print('Error saving data: $e');
    }
  }
}


// ================ polimerfisme; dynamic polymorphism (overriding) ================

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

// // output: 
// // Dog barks
// // Cat meows
// // Cow moos