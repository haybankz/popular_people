import 'package:flutter/material.dart';
import 'package:popular_people/application/popular_people/providers/person_detail_provider.dart';
import 'package:popular_people/domain/domain.dart';
import 'package:provider/provider.dart';

class PersonDetailScreen extends StatefulWidget {
  const PersonDetailScreen({Key? key, required this.person}) : super(key: key);
  final PersonEntity person;

  @override
  State<PersonDetailScreen> createState() => _PersonDetailScreenState();
}

class _PersonDetailScreenState extends State<PersonDetailScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      Provider.of<PersonDetailProvider>(context, listen: false)
          .getPersonImage(widget.person.id!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.person.name ?? ""),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Provider.of<PersonDetailProvider>(context, listen: false)
              .getPersonImage(widget.person.id!);
        },
      ),
      body: Center(
        child: Column(
          children: [Text(widget.person.name ?? "")],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
