import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:popular_people/application/popular_people/providers/person_detail_provider.dart';
import 'package:popular_people/core/constants/strings.dart';
import 'package:popular_people/core/core.dart';
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
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      Provider.of<PersonDetailProvider>(context, listen: false)
          .getPersonImage(widget.person.id!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 250.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(widget.person.name ?? "", textScaleFactor: 1),
              background: CachedNetworkImage(
                imageUrl:
                    '${Strings.imageStorageUrl}${widget.person.profilePath}',
                fit: BoxFit.cover,
              ),
            ),
          ),
          _ImageGridWidget(personId: widget.person.id!),
        ],
      ),
    );
  }
}

class _ImageGridWidget extends StatelessWidget {
  const _ImageGridWidget({Key? key, required this.personId}) : super(key: key);
  final int personId;

  @override
  Widget build(BuildContext context) {
    return Consumer<PersonDetailProvider>(builder: (ctx, provider, child) {
      if (provider.personImageResult.status == Status.loading) {
        return SliverFillRemaining(
          child: Column(
            children: const [
              SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator.adaptive(),
              ),
              Text("Loading ......")
            ],
          ),
        );
      } else if (provider.personImageResult.status == Status.error) {
        return SliverFillRemaining(
          child: Column(
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.red,
              ),
              Text(provider.personImageResult.message),
              TextButton(
                child: const Text(
                  "Click to retry",
                  textAlign: TextAlign.center,
                ),
                onPressed: () {
                  provider.getPersonImage(personId);
                },
              )
            ],
          ),
        );
      }
      final imageList = provider.personImageResult.data?.images ?? [];
      return SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, childAspectRatio: 2 / 3),
        delegate: SliverChildBuilderDelegate(
          (_, int index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: CachedNetworkImage(
                  imageUrl:
                      "${Strings.imageStorageUrl}${imageList[index].filePath}",
                  fit: BoxFit.fill,
                ),
              ),
            );
          },
          childCount: imageList.length,
        ),
      );
    });
  }
}
