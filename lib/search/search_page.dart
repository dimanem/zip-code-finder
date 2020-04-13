import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:zipcodefinder/model/place_data.dart';
import 'package:zipcodefinder/utils/simple_snack_bar.dart';
import 'package:zipcodefinder/utils/uuid.dart';

final searchScaffoldKey = GlobalKey<ScaffoldState>();

class SearchPage extends PlacesAutocompleteWidget {
  final String _apiKey;

  SearchPage(this._apiKey) :super(
    apiKey: _apiKey,
    sessionToken: Uuid().generateV4(),
//    language: "en",
    components: [Component(Component.country, 'us')],
//    types: [ 'postal_code' ]
  );

  @override
  _SearchPageState createState() =>
      _SearchPageState(GoogleMapsPlaces(apiKey: _apiKey));
}

class _SearchPageState extends PlacesAutocompleteState {

  final GoogleMapsPlaces _places;

  _SearchPageState(this._places);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: searchScaffoldKey,
        appBar: AppBar(
          title: AppBarPlacesAutoCompleteTextField(),
        ),
        body: PlacesAutocompleteResult(
          onTap: (prediction) {
            _handlePredictionClick(context, prediction);
          },
        ));
  }

  @override
  void onResponseError(PlacesAutocompleteResponse response) {
    super.onResponseError(response);
    searchScaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text(response.errorMessage)),
    );
  }

  @override
  void onResponse(PlacesAutocompleteResponse response) {
    super.onResponse(response);
    if (response != null && response.predictions.isNotEmpty) {
//      searchScaffoldKey.currentState.showSnackBar(
//        SnackBar(content: Text("Got answer")),
//      );
    }
  }

  _handlePredictionClick(BuildContext context, Prediction prediction) async {
    if (prediction != null) {
      PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(
          prediction.placeId);
      if (detail != null) {
        Navigator.pop(context, PlaceData(detail.result.name, '123456'));
      } else {
        SimpleSnackBar.show(searchScaffoldKey.currentState,
            'Failed to get place details: ${prediction.placeId}');
      }
    } else {
      SimpleSnackBar.show(searchScaffoldKey.currentState,
          'Failed to get place details: ${prediction.placeId}');
    }
  }
}