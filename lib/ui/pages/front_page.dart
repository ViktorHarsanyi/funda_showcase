import 'package:flutter/material.dart';

import '../../data/house_model.dart';

class FrontPage extends StatefulWidget {
  final HouseModel house;

  const FrontPage(this.house, {super.key});

  @override
  State<FrontPage> createState() => _FrontPageState();
}

class _FrontPageState extends State<FrontPage> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          toolbarHeight: 32,
          floating: true,
          snap: true,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft:Radius.circular(32),)),
          centerTitle: true,
          title: Text('${widget.house.plaats} ${widget.house.adres}'),
          automaticallyImplyLeading: false,
        ),
        SliverToBoxAdapter(
          child: Wrap(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Asking price:',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              Container(
                margin: const EdgeInsets.all(32.0),
                padding: const EdgeInsets.all(8.0),
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(24)),
                ),
                child: Text(
                  '€ ${widget.house.koopprijs}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ],
          ),
        ),
        SliverToBoxAdapter(
          child: Wrap(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Available from:',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              Container(
                margin: const EdgeInsets.all(32.0),
                padding: const EdgeInsets.all(8.0),
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(24)),
                ),
                child: Text(
                  widget.house.aangebodenSindsTekst,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ],
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(

                  padding: const EdgeInsets.all(8.0),
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(24)),
                  ),
                  child: Text(
                    '\u{1F6CC} ${widget.house.aantalKamers}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                Container(

                  padding: const EdgeInsets.all(8.0),
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(24)),
                  ),
                  child: Text(
                    '\u{1F3E1} ${widget.house.tuin}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                Container(

                  padding: const EdgeInsets.all(8.0),
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(24)),
                  ),
                  child: Text(
                    '\u{1F6C0} ${widget.house.aantalBadkamers}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 24,
            mainAxisSpacing: 24,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, i) {
              return Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(widget.house.mediaFoto[i]),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(24)),
                ),
              );
            },
            childCount: widget.house.mediaFoto.length,
          ),
        ),
      ],
      controller: ScrollController(),
    );
  }
}
