import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:trufi_core/blocs/preferences_bloc.dart';
import 'package:trufi_core/trufi_localizations.dart';
import 'package:trufi_core/trufi_models.dart';

import '../widgets/trufi_map.dart';
import '../widgets/trufi_online_map.dart';

class PlanEmptyPage extends StatefulWidget {
  PlanEmptyPage({this.initialPosition, this.onLongPress});

  final LatLng initialPosition;
  final LongPressCallback onLongPress;

  @override
  PlanEmptyPageState createState() => PlanEmptyPageState();
}

class PlanEmptyPageState extends State<PlanEmptyPage>
    with TickerProviderStateMixin {
  final _trufiMapController = TrufiMapController();

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      TrufiOnlineMap(
        key: ValueKey("PlanEmptyMap"),
        controller: _trufiMapController,
        onLongPress: widget.onLongPress,
        layerOptionsBuilder: (context) {
          return <LayerOptions>[
            _trufiMapController.yourLocationLayer,
          ];
        },
      ),
      Positioned(
        top: 16.0,
        right: 16.0,
        child: SafeArea(
          child: _buildMapTypeButton(context),
        ),
      ),
      Positioned(
        bottom: 16.0,
        right: 16.0,
        child: SafeArea(
          child: _buildMyLocationButton(context),
        ),
      ),
    ]);
  }

  Widget _buildMapTypeButton(BuildContext context) {
    return FloatingActionButton(
      mini: true,
      backgroundColor: Theme.of(context).backgroundColor,
      child: Icon(Icons.layers, color: Colors.black),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (context) => _buildMapTypeBottomSheet(context),
          backgroundColor: Theme.of(context).backgroundColor,
        );
      },
      heroTag: null,
    );
  }

  Widget _buildMapTypeBottomSheet(BuildContext context) {
    final theme = Theme.of(context);
    final preferencesBloc = PreferencesBloc.of(context);
    final localization = TrufiLocalizations.of(context).localization;
    return SafeArea(
      child: Container(
        height: 140,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(16.0),
              child: Text(localization.mapTypeTitle(), style: theme.textTheme.body2),
            ),
            StreamBuilder(
              stream: preferencesBloc.outChangeMapType,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    _buildMapTypeOptionButton(
                      context: context,
                      assetPath: "assets/images/maptype-streets.png",
                      label: localization.mapTypeStreetsCaption(),
                      onPressed: () {
                        preferencesBloc.inChangeMapType.add(MapStyle.streets);
                      },
                      active: snapshot.data == MapStyle.streets || snapshot.data == "",
                    ),
                    _buildMapTypeOptionButton(
                      context: context,
                      assetPath: "assets/images/maptype-satellite.png",
                      label: localization.mapTypeSatelliteCaption(),
                      onPressed: () {
                        preferencesBloc.inChangeMapType.add(MapStyle.satellite);
                      },
                      active: snapshot.data == MapStyle.satellite,
                    ),
                    _buildMapTypeOptionButton(
                      context: context,
                      assetPath: "assets/images/maptype-terrain.png",
                      label: localization.mapTypeTerrainCaption(),
                      onPressed: () {
                        preferencesBloc.inChangeMapType.add(MapStyle.terrain);
                      },
                      active: snapshot.data == MapStyle.terrain,
                    ),
                  ],
                );
              },
            ),
          ]
        ),
      ),
    );
  }

  Widget _buildMapTypeOptionButton({
    @required BuildContext context,
    @required String assetPath,
    @required String label,
    VoidCallback onPressed,
    bool active = false,
  }) {
    final theme = Theme.of(context);
    return FlatButton(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onPressed: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 64,
            height: 64,
            child: ClipRRect(
              clipBehavior: Clip.antiAlias,
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(assetPath, width: 64, height: 64),
            ),
            decoration: BoxDecoration(
              border: Border.all(
                width: 2.0, 
                color: active
                  ? theme.accentColor
                  : Colors.transparent,
              ),
              borderRadius: BorderRadius.circular(8.0)
            ),
          ),
          Container(
            padding: EdgeInsets.all(4.0),
            child: Text(
              label,
              style: TextStyle(
                fontSize: theme.textTheme.caption.fontSize,
                color: active
                  ? theme.accentColor
                  : theme.textTheme.body1.color
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMyLocationButton(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Theme.of(context).backgroundColor,
      child: Icon(Icons.my_location, color: Colors.black),
      onPressed: () {
        _trufiMapController.moveToYourLocation(
          context: context,
          tickerProvider: this,
        );
      },
      heroTag: null,
    );
  }
}
