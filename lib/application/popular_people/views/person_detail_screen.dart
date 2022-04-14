import 'package:flutter/material.dart';
import 'package:popular_people/application/popular_people/providers/person_detail_provider.dart';
import 'package:popular_people/application/popular_people/views/image_screen.dart';
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
      appBar: AppBar(
        title: Text(widget.person.name!.split(" ").first),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              child: Stack(
                children: [
                  Hero(
                    tag: "person_${widget.person.id}",
                    child: Image.network(
                      '${Strings.imageStorageUrl}${widget.person.profilePath}',
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                          Colors.transparent,
                          Colors.brown.withOpacity(0.9)
                        ])),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "${widget.person.name}",
                          style: Theme.of(context)
                              .textTheme
                              .headline5!
                              .copyWith(color: Colors.white),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "${widget.person.gender == 2 ? "Male" : "Female"}  |  ${widget.person.knownForDepartment}",
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 18),
                        ),
                        TextButton.icon(
                          onPressed: null,
                          icon: const Icon(
                            Icons.star,
                            color: Colors.yellow,
                          ),
                          label: Text(
                            "${widget.person.popularity ?? 0.0}",
                            style: const TextStyle(
                                color: Colors.white, fontSize: 16),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            _ImageGridWidget(personId: widget.person.id!)
          ],
        ),
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
        return Column(
          children: const [
            SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 50,
              height: 50,
              child: CircularProgressIndicator.adaptive(),
            ),
            Text("Loading ......")
          ],
        );
      } else if (provider.personImageResult.status == Status.error) {
        return Column(
          children: [
            const SizedBox(
              height: 20,
            ),
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
        );
      }
      final imageList = provider.personImageResult.data?.images ?? [];
      return GridView.builder(
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, childAspectRatio: 2 / 3),
        itemBuilder: (_, int index) => ImageWidget(image: imageList[index]),
        itemCount: imageList.length,
      );
    });
  }
}

class ImageWidget extends StatelessWidget {
  const ImageWidget({
    Key? key,
    required this.image,
  }) : super(key: key);

  final ImageEntity image;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              PageRouteBuilder(
                  transitionDuration: const Duration(seconds: 1),
                  pageBuilder: (_, __, ___) => ImageScreen(image: image)));
        },
        child: Hero(
          tag: "image_${image.filePath}",
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.network(
              "${Strings.imageStorageUrl}${image.filePath}",
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }
}
