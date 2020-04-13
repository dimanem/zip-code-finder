import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zipcodefinder/model/place_data.dart';
import 'package:zipcodefinder/search/search_page.dart';
import 'package:zipcodefinder/utils/simple_snack_bar.dart';

enum MenuItemType { copy_to_clipboard, delete }

final homeScaffoldKey = GlobalKey<ScaffoldState>();

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<PlaceData> _data = [];

  String _apiKey;

  List<PopupMenuItem<MenuItemType>> _menuItems = [
    PopupMenuItem<MenuItemType>(
      child: Icon(Icons.content_copy),
      value: MenuItemType.copy_to_clipboard,
    ),
    PopupMenuItem<MenuItemType>(
      child: Icon(Icons.delete),
      value: MenuItemType.delete,
    )
  ];

  @override
  void initState() {
    super.initState();
    _loadApiKey(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: homeScaffoldKey,
      appBar: AppBar(
        title: Text("Zip Code Finder"),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            _navigateToSearch();
          },
          child: Icon(Icons.search)),
      body: _initBody(),
    );
  }

  Widget _initBody() {
    if (_data.isEmpty) {
      return Center(
        child: Container(
          child: Text(
            'No zip codes added yet',
            style: TextStyle(
                fontFamily: 'Quattrocento', fontSize: 22, letterSpacing: 0),
          ),
        ),
      );
    } else {
      return ListView.builder(
          itemCount: _data.length,
          itemBuilder: (context, index) {
            return _buildListItem(context, _data[index]);
          });
    }
  }

  Widget _buildListItem(BuildContext context, PlaceData data) {
    return GestureDetector(
      onLongPress: () {
        _copyToClipboard(data);
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
          title: Text(
            data.zipCode,
            style: TextStyle(
                fontFamily: 'Quattrocento', fontSize: 25, letterSpacing: 2),
          ),
          subtitle: Text(data.name,
              style: TextStyle(
                  fontFamily: 'Quattrocento', fontSize: 15, letterSpacing: 1)),
          leading: Icon(
            Icons.location_city,
          ),
          trailing: PopupMenuButton<MenuItemType>(
            itemBuilder: (BuildContext context) => _menuItems,
            onSelected: (MenuItemType itemType) {
              _handleMenuItemSelected(itemType, data);
            },
          ),
        ),
      ),
    );
  }

  _addPlaceData(PlaceData data) {
    if (!_data.contains(data)) {
      setState(() {
        _data.insert(0, data);
      });
    }
  }

  _removeZipCodeData(PlaceData data) {
    if (_data.contains(data)) {
      setState(() {
        _data.remove(data);
      });
    }
  }

  _copyToClipboard(PlaceData data) {
    Clipboard.setData(ClipboardData(text: data.zipCode));
    SimpleSnackBar.show(homeScaffoldKey.currentState, 'Copied to clipboard!');
  }

  _handleMenuItemSelected(MenuItemType itemType, PlaceData data) {
    switch (itemType) {
      case MenuItemType.copy_to_clipboard:
        _copyToClipboard(data);
        break;
      case MenuItemType.delete:
        _removeZipCodeData(data);
        break;
    }
  }

  _navigateToSearch() async {
    if (_apiKey == null) {
      SimpleSnackBar.show(
          homeScaffoldKey.currentState, 'Missing search API key');
      return;
    }

    final placeData = await Navigator.push(
      context,
      // Create the SelectionScreen in the next step.
      MaterialPageRoute(builder: (context) => SearchPage(_apiKey)),
    );

    if (placeData != null) {
      _addPlaceData(placeData);
    }
  }

  _loadApiKey(BuildContext context) async {
    String apiKey = await DefaultAssetBundle.of(context).loadString(
        'assets/api_key.txt');
    if (apiKey != null) {
      _apiKey = apiKey;
    } else {
      print('Missing API key');
      // display error message
    }
  }
}
