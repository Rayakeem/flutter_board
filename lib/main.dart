import 'package:flutter/material.dart';
import 'package:flutterboard/Post.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BoardScreen(),
    );
  }
}

class BoardScreen extends StatefulWidget {
  @override
  _BoardScreenState createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final List<Post> _posts = [];

  void _addPost() {
    final String title = _titleController.text;
    final String content = _contentController.text;

    if(title.isNotEmpty && content.isNotEmpty ) {
      setState(() {
        _posts.add(Post(title: title, content: content));
        _titleController.clear();
        _contentController.clear();
      });
    }
  }

  void _deletePost(int index) {
    setState(() {
      _posts.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("게시글 작성"),
      ),
      body: Column(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: "제목"),
              ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: _contentController,
              decoration: InputDecoration(labelText: "내용"),
            ),
          ),
          ElevatedButton(onPressed: _addPost, child: Text("게시글 추가")),
          Expanded(child: ListView.builder(
              itemCount: _posts.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(_posts[index].title),
                subtitle: Text(_posts[index].content),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _deletePost(index),
                ),
              );
            },
          ),
          ),
        ],
      ),
    );
  }
}





