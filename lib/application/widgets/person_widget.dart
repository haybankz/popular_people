import 'package:flutter/material.dart';
import 'package:popular_people/application/popular_people/popular_people.dart';
import 'package:popular_people/core/core.dart';
import 'package:popular_people/domain/domain.dart';

class PersonWidget extends StatelessWidget {
  const PersonWidget({
    Key? key,
    required this.person,
  }) : super(key: key);

  final PersonEntity person;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Hero(
        tag: "person_${person.id}",
        child: _PersonImage(imageUrl: person.profilePath ?? ""),
      ),
      title: Text(
        person.name ?? "",
        style: Theme.of(context).textTheme.headline6,
      ),
      subtitle: Text(person.knownForDepartment ?? ""),
      onTap: () {
        Navigator.push(
            context,
            PageRouteBuilder(
                transitionDuration: const Duration(seconds: 1),
                pageBuilder: (_, __, ___) =>
                    PersonDetailScreen(person: person)));
      },
    );
  }
}

class _PersonImage extends StatelessWidget {
  const _PersonImage({
    Key? key,
    required this.imageUrl,
  }) : super(key: key);

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.horizontal(
          right: Radius.circular(4), left: Radius.circular(4)),
      child: Image.network(
        "${Strings.imageStorageUrl}$imageUrl",
        width: 60,
        height: 60,
        fit: BoxFit.fill,
      ),
    );
  }
}
