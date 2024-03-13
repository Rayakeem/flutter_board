import 'package:flutter/material.dart';
import 'package:flutterboard/Post.dart';
import 'package:file_picker/file_picker.dart'


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

  String? _selectedFilePath;
  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _selectedFilePath = result.files.single.path;
      });
    }
  }
}

class _BoardScreenState extends State<BoardScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final List<Post> _posts = [];
  int? _editIndex;

  void _addPost() {
    final String title = _titleController.text;
    final String content = _contentController.text;

    if(title.isNotEmpty && content.isNotEmpty ) {
      setState(() {

        if(_editIndex == null) {
          _posts.add(Post(title: title, content: content));
        }else {
          _posts[_editIndex!] = Post(title: title, content: content);
          _editIndex = null;
        }
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

  void _editPost(int index) {
    setState(() {
      _titleController.text = _posts[index].title;
      _contentController.text = _posts[index].content;
      _editIndex = index;

    });
  }

  void _showReadDialog(String title, String content) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(content),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('닫기'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
    );
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
          ElevatedButton(
              onPressed: _addPost,
              child: Text(_editIndex == null ? "게시글 추가" : "수정 완료"),
          ),
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
                onTap: () => _editPost(index),
                onLongPress: () => _showReadDialog(_posts[index].title, _posts[index].content),
              );
            },
          ),
          ),
        ],
      ),
    );
  }
}





