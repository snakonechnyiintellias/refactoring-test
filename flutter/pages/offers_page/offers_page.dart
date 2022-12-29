import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'tabs_bloc.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    BuildFromJsonBloc bloc =
        BlocProvider.of<BuildFromJsonBloc>(context, listen: false);
    bloc.getSuggestionsFromApi("suggestions");
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: buildAppBarContent(),
          backgroundColor: const Color(0xFF02AD58),
          bottom: buildTapBarInAppBar(bloc),
        ),
        body: TabBarView(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: buildFirstTab(),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: buildSecondTab(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSecondTab() {
    return BlocBuilder<BuildFromJsonBloc, List>(builder: (context, state) {
      return GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8),
        scrollDirection: Axis.vertical,
        itemCount: state.length,
        itemBuilder: (context, index) {
          String? s =
              (state[index] is PartnersModel ? state[index].logo : null);
          return Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                decoration: state[index] is PartnersModel
                    ? BoxDecoration(
                        color: Color(int.parse("${state[index].color}")),
                        borderRadius: BorderRadius.circular(8))
                    : null,
              ),
              Container(
                child: s == null
                    ? null
                    : Image.asset(
                        "${s.substring(0, s.length - 3)}png",
                      ),
              ),
            ],
          );
        },
      );
    });
  }

  Widget buildFirstTab() {
    return BlocBuilder<BuildFromJsonBloc, List>(builder: (
      context,
      state,
    ) {
      return StaggeredGridView.countBuilder(
        staggeredTileBuilder: (int index) => index % 2 == 0 && index != 0
            ? const StaggeredTile.count(2, 1)
            : const StaggeredTile.count(1, 1.5),
        crossAxisCount: 2,
        itemCount: state.length,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            height: 500,
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: [
                Container(
                  decoration: state[index] is CharacterModel
                      ? BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.transparent,
                          image: DecorationImage(
                            image: AssetImage(state[index].image),
                            fit: BoxFit.fill,
                          ))
                      : null,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                    gradient: const LinearGradient(
                      stops: [0.0, 1.0],
                      colors: [
                        Color.fromRGBO(0, 0, 0, 0),
                        Color.fromRGBO(0, 0, 0, 0.8)
                      ],
                      begin: FractionalOffset.topCenter,
                      end: FractionalOffset.bottomCenter,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      state[index] is CharacterModel
                          ? SizedBox(
                              width: 140,
                              child: Text(
                                "${state[index].text}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ))
                          : const SizedBox.shrink(),
                      state[index] is CharacterModel
                          ? Text(
                              "${state[index].endData}",
                              style: const TextStyle(
                                color: Color.fromRGBO(255, 255, 255, 0.4),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ],
                  ),
                )
              ],
            ),
          );
        },
        scrollDirection: Axis.vertical,
      );
    });
  }

  PreferredSizeWidget buildTapBarInAppBar(bloc) {
    return TabBar(
      onTap: (index) {
        if (index == 1) {
          bloc.getSuggestionsFromApi('partners');
        } else if (index == 0) {
          bloc.getSuggestionsFromApi('suggestions');
        }
      },
      indicatorColor: Colors.white,
      tabs: const <Widget>[
        Tab(
          text: "Предложения",
        ),
        Tab(
          text: "Компании",
        )
      ],
    );
  }

  Widget buildAppBarContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.table_rows_rounded),
            ),
            const SizedBox(
              width: 35,
            ),
            const Text("Корпоратив"),
          ],
        ),
        Row(
          children: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.info_outline)),
          ],
        ),
      ],
    );
  }
}
