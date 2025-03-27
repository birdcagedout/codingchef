import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/add_task.dart';
import 'package:url_launcher/url_launcher.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // String todoText = "to do test";
  List<String> todoList = [];

  // SharedPreferencesAsync 인스턴스 생성
  final SharedPreferencesAsync asyncPrefs = SharedPreferencesAsync();   // 앞으로 꼭 async 사용 권장


  // BottomSheet에서 입력받아서 메인화면 리스트뷰에 출력
  void addTodo({required String todoText}) {
    // print(todoList.contains(todoText));

    // 만약 List에 이미 존재하는 "할일"인 경우 경고
    if(todoList.contains(todoText)) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Already exists'),
            content: Text('This task already exists. Try again.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
              ),
            ],
          );
        },
      );
      return;   // showDialog() 뒤에 반드시 return이 필요하다. 없다면 대화상자가 표시되지 않는다.
    }

    // textfield에 아무 입력이 없이 add가 눌린 경우는 todoList.insert하지 않고 setState도 안 하고, 저장하지도 않는다
    if(todoText.length > 0) {
      setState(() {
        // todoText = todoText;
        // todoList.add(todoText);      // 리스트의 맨 뒤에 추가
        todoList.insert(0, todoText);   // 리스트의 맨 앞에 추가
      });

      // Shared Preferences에 저장
      writeLocalData();
    }

    Navigator.of(context).pop();
  }

  // Shared Preferences WRITE 메소드
  void writeLocalData() async {
    // Save an list of strings to 'todoList' key.
    await asyncPrefs.setStringList('todoList', todoList);
  }

  // 앱 실행 시 Shared Preferences에 저장된 데이터를 읽어오는 메소드
  void readLocalData() async {
    // 저장된 'todoList' 데이터를 가져오기
    final List<String>? storedList = await asyncPrefs.getStringList('todoList');
    if (storedList != null) {
      setState(() {
        todoList = storedList;
      });
    }
  }

  // 좌측 서랍 리턴하는 함수
  Widget getDrawer() {
    return Drawer(
      // width: 200,
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text('Coding Chef'),
            accountEmail: Text('codingchef@google.com'),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.asset('assets/images/codingchef2.png'),
              ),
            ),
          ),

          ListTile(
            onTap: () async {
              await launchUrl(Uri.parse("https://www.youtube.com/@codingchef"));
            },
            leading: const Icon(Icons.youtube_searched_for_rounded),
            title: const Text("About me"),
          ),
          ListTile(
            onTap: () async {
              await launchUrl(Uri.parse("https://www.gmail.com"));
            },
            leading: const Icon(Icons.mail_outline_rounded),
            title: const Text("Email me"),
          ),
          ListTile(
            onTap: () async {
              await launchUrl(Uri.parse("https://www."));
            },
            leading: const Icon(Icons.shape_line_outlined),
            title: const Text("Share"),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    readLocalData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: getDrawer(),
      appBar: AppBar(
        title: Text('Todo App'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Padding(
                    padding: MediaQuery.of(context).viewInsets,   // keyboard가 올라와서 bottomsheet를 가리므로, 그만큼을 padding으로 추가해야 됨
                    child: Container(
                      height: 250,
                      child: AddTask(addTodo: addTodo,),
                    ),
                  );
                },
              );
            }, 
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: (todoList.isEmpty) ? Center(child: Text('No items on the list', style: TextStyle(fontSize: 20),)) : ListView.builder(
        itemCount: todoList.length,
        itemBuilder: (context, index) {
          return Dismissible(   // 스와이프로 삭제
            key: UniqueKey(),   // 필수 입력
            // direction: DismissDirection.endToStart,    // 스와이프 방향
            background: Container(
              color: Colors.red,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Icon(Icons.delete_forever, size: 30,),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text('삭제하기', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),
                  ),
                ],
              ),
            ),
            onDismissed: (direction) {
              setState(() {
                todoList.removeAt(index);
              });
              writeLocalData();
            },
            child: ListTile(
              title: Text(todoList[index]),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      height: 100,
                      padding: EdgeInsets.all(20),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            todoList.removeAt(index);
                          });
            
                          // Shared Preferences 저장
                          writeLocalData();
                          Navigator.of(context).pop();
                        },
                        child: Text('Task Done!'),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return Padding(
                padding: MediaQuery.of(context).viewInsets,   // keyboard가 올라와서 bottomsheet를 가리므로, 그만큼을 padding으로 추가해야 됨
                child: Container(
                  height: 250,
                  child: AddTask(addTodo: addTodo,),
                ),
              );
            },
          );
        },
        child: Icon(Icons.add, color: Colors.white,),
      ),
    );
  }
}
