import 'package:flutter_test/flutter_test.dart';
import 'package:wasteagram/models/waste_post.dart';

void main() {
  DateTime checkDate = DateTime.now();

  WastePost newPost = WastePost(
    imageURL: 'Example.jpg',
    quantity: 3,
    latitude: -103.2,
    longitude: 112.3,
    date: checkDate);

  //Unit tests to check model variable assignments
  test('Expect new post imageURL equals Example.jpg', () {
    expect(newPost.imageURL, 'Example.jpg');
  });

  test('Expect new post quantity equals 3', () {
    expect(newPost.quantity, 3);
  });

  test('Expect new post latitude equals -103.2', () {
    expect(newPost.latitude, -103.2);
  });

  test('Expect new post longitude equals 112.3', () {
    expect(newPost.longitude, 112.3);
  });

  test('Expect new post date equals ${checkDate}', () {
    expect(newPost.date, checkDate);
  });
}