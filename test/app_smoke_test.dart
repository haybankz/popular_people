import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:popular_people/application/application.dart';
import 'package:popular_people/application/widgets/widgets.dart';
import 'package:popular_people/dependency_container.dart';
import 'package:popular_people/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  setUp(() async {
    await initDI();
  });

  testWidgets("App smoke test", (WidgetTester tester) async {
    dotenv.testLoad(
        fileInput: File('test/test_resources/.env').readAsStringSync());

    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    //check that the AppBar is displayed
    expect(find.byType(AppBar), findsOneWidget);

    // check that the people list is displayed
    final count = tester
        .widgetList<ListView>(find.byKey(const ValueKey("peopleListViewKey")))
        .length;
    // if data was fetch successfully, a listview should be displayed
    if (count == 1) {
      await _navigateToPersonDetailsScreen(tester);

      /// check that person details screen is loaded
      _testForPersonDetailScreen();

      // get last item in the image gridview
      Finder imageItem = find.byType(ImageWidget).at(1);
      //tap last grid item
      await tester.tap(imageItem);
      // wait for image screen
      await tester.pumpAndSettle();

      _testForImageScreen();
    } else {
      _testForErrorWidget();
    }
  });
}

Future<void> _navigateToPersonDetailsScreen(WidgetTester tester) async {
  // get first list item
  Finder item = find.byType(PersonWidget).first;
  //tap list item
  await tester.tap(item);
  // wait until person detail screen loads
  await tester.pumpAndSettle();
}

void _testForPersonDetailScreen() {
  // expect that person images is loaded
  expect(find.byType(Image), findsWidgets);
  // expect that texts are loaded (person name, known for, gender)
  expect(find.byType(Text), findsNWidgets(4));
  //expect that 2 icons are loaded, back icon and star icon for popularity
  expect(find.byType(Icon), findsNWidgets(2));
}

void _testForImageScreen() {
  expect(find.byType(Image), findsOneWidget);
  expect(find.byType(IconButton), findsOneWidget);
  expect(find.text('Save'), findsOneWidget);
}

void _testForErrorWidget() {
  // if data fetch encounter an error, an error widget containing an icon and a text button with text(Click to retry) will be displayed
  expect(find.byType(TextButton), findsOneWidget);
  expect(find.text("Click to retry"), findsOneWidget);
  expect(find.byType(Icon), findsOneWidget);
}
