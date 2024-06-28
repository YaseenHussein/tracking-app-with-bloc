import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tracking_app_with_cubit/cubit/cubit/map_cubit.dart';
import 'package:tracking_app_with_cubit/cubit/cubit/map_state.dart';
import 'package:tracking_app_with_cubit/views/widget/list_view_item_of_places.dart';
import 'package:tracking_app_with_cubit/views/widget/text_field.dart';

class MapView extends StatelessWidget {
  const MapView({super.key});

  @override
  Widget build(BuildContext context) {
    print("building");
    return BlocConsumer<MapCubit, MapState>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = MapCubit.get(context);
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              GoogleMap(
                polylines: cubit.polylines,
                markers: cubit.markers,
                //  zoomControlsEnabled: false,
                initialCameraPosition: cubit.initialCameraPosition,
                onMapCreated: (controller) {
                  cubit.googleMapController = controller;
                  cubit.updateCameraLocation();
                },
              ),
              SafeArea(
                child: Padding(
                  padding:
                      const EdgeInsetsDirectional.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      CustomTextField(
                        controller: cubit.inputTextController,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const ListViewItemOfPlaces(),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
