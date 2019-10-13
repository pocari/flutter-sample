import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/rendering.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Startup Name Generator Hoge",
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      home: RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  RandomWordState createState() => RandomWordState();
}

class Item {
  final index;
  final wp;

  Item(this.index, this.wp);

  int get hashCode => index.hashCode + wp.hashCode;

  bool operator ==(other) {
    if (other is Item) {
      return other.index == index && other.wp == wp;
    }
    return false;
  }

  String get dispValue => "${index}: ${wp.asPascalCase}";
}

class RandomWordState extends State<RandomWords> {
  final List<Item> _suggestions = <Item>[];
  final Set<Item> _saved = Set<Item>();
  final TextStyle _biggerFont = const TextStyle(fontSize: 18);

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Startup Name Generator"),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  void _pushSaved() {
    print("_pushSsaved");
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (BuildContext context) {
        final Iterable<ListTile> tiles = _saved.map(
          (Item item) {
            return ListTile(
                title: Text(
              item.dispValue,
              style: _biggerFont,
            ));
          },
        );
        final List<Widget> divided = ListTile.divideTiles(
          context: context,
          tiles: tiles,
        ).toList();
        return Scaffold(
          appBar: AppBar(title: Text('Saved Suggestions')),
          body: ListView(children: divided),
        );
      },
    ));
  }

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemBuilder: (BuildContext _context, int i) {
          if (i.isOdd) {
            return Divider();
          }
          final int index = i ~/ 2;
          if (index >= _suggestions.length) {
            int i = index;
            _suggestions.addAll(
                generateWordPairs().take(10).map((wp) => Item(i++, wp)));
          }
          return _buildRow(_suggestions[index]);
        });
  }

  Widget _buildRow(Item item) {
    final bool alreadySaved = _saved.contains(item);
    return ListTile(
      title: Text(
        item.dispValue,
        style: _biggerFont,
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(item);
          } else {
            _saved.add(item);
          }
        });
      },
    );
  }
}
