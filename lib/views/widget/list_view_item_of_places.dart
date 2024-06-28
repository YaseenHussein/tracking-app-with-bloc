import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app_with_cubit/cubit/cubit/map_cubit.dart';
import 'package:tracking_app_with_cubit/cubit/cubit/map_state.dart';

class ListViewItemOfPlaces extends StatelessWidget {
  const ListViewItemOfPlaces({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    print("building ListViewItemOfPlaces");
    return BlocConsumer<MapCubit, MapState>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = MapCubit.get(context);
        print("building ListViewItemOfPlaces");
        return Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: cubit.allPlaces.length,
            separatorBuilder: (BuildContext context, int index) {
              return const Divider(
                height: 0,
              );
            },
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                onTap: () {
                  cubit.getPlacesDetails(
                      placesId: cubit.allPlaces[index].placeId!);
                  cubit.sessionToken = null;
                },
                title: Text(
                  cubit.allPlaces[index].description!,
                ),
                trailing: const Icon(Icons.arrow_forward_ios_outlined),
                leading: const Icon(Icons.location_on_rounded),
              );
            },
          ),
        );
      },
    );
  }
}
