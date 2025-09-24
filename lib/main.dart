import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To Do List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Arial',
      ),
      home: StudentTodoScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TodoItem {
  String title;
  bool isCompleted;

  TodoItem({required this.title, this.isCompleted = false});
}

class StudentTodoScreen extends StatefulWidget {
  @override
  _StudentTodoScreenState createState() => _StudentTodoScreenState();
}

class _StudentTodoScreenState extends State<StudentTodoScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<TodoItem> _todos = [
    TodoItem(title: "Kumpulkan Tugas Mobile"),
    TodoItem(title: "Belajar untuk UTS Database"),
    TodoItem(title: "Mencari Database untuk Praktikum"),
    TodoItem(title: "Rapat Kelompok - Kecerdasan Buatan"),
    TodoItem(title: "Belajar Membuat Jurnal"),
  ];

  void _addTodo() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _todos.add(TodoItem(title: _controller.text));
        _controller.clear();
      });
    }
  }

  void _toggleTodo(int index) {
    setState(() {
      _todos[index].isCompleted = !_todos[index].isCompleted;
    });
  }

  void _deleteTodo(int index) {
    setState(() {
      _todos.removeAt(index);
    });
  }

  Color _getCategoryColor(String category) {
    return Colors.grey.shade300;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1E3A8A), // Dark blue
              Color(0xFF3B82F6), // Medium blue
              Color(0xFF60A5FA), // Light blue
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header with university elements
              Container(
                height: 200,
                child: Stack(
                  children: [
                    // University building silhouettes
                    Positioned(
                      left: -30,
                      top: 40,
                      child: _buildUniversityBuilding(),
                    ),
                    Positioned(
                      right: -30,
                      top: 40,
                      child: _buildUniversityBuilding(),
                    ),
                    // Academic icons decoration
                    Positioned(
                      left: 60,
                      top: 30,
                      child: Icon(Icons.school, color: Colors.white54, size: 24),
                    ),
                    Positioned(
                      right: 80,
                      top: 50,
                      child: Icon(Icons.book, color: Colors.white54, size: 20),
                    ),
                    Positioned(
                      left: 30,
                      top: 120,
                      child: Icon(Icons.lightbulb_outline, color: Colors.white54, size: 18),
                    ),
                    Positioned(
                      right: 50,
                      top: 140,
                      child: Icon(Icons.science, color: Colors.white54, size: 22),
                    ),
                    // Title
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Najwan Wi'am Assroshan",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 2,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Rencana Belajar',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                              letterSpacing: 1,
                            ),
                          ),
                          SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.calendar_today, color: Colors.white60, size: 14),
                              SizedBox(width: 4),
                              Text(
                                'Tahun Akademik 2024/2025',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white60,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Todo List
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      // Add new todo
                      Container(
                        margin: EdgeInsets.only(bottom: 20),
                        child: Row(
                          children: [
                            Expanded(
                              child:                               TextField(
                                controller: _controller,
                                decoration: InputDecoration(
                                  hintText: 'Tambah tugas akademik baru...',
                                  hintStyle: TextStyle(color: Colors.white60),
                                  filled: true,
                                  fillColor: Colors.white24,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                                  prefixIcon: Icon(Icons.assignment, color: Colors.white60),
                                ),
                                style: TextStyle(color: Colors.white),
                                onSubmitted: (_) => _addTodo(),
                              ),
                            ),
                            SizedBox(width: 10),
                            FloatingActionButton(
                              mini: true,
                              backgroundColor: Colors.white24,
                              onPressed: _addTodo,
                              child: Icon(Icons.add, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      
                      // Progress indicator
                      Container(
                        margin: EdgeInsets.only(bottom: 20),
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.trending_up, color: Colors.white, size: 20),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Academic Progress',
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    '${_todos.where((todo) => todo.isCompleted).length}/${_todos.length} tasks completed',
                                    style: TextStyle(color: Colors.white70, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '${((_todos.where((todo) => todo.isCompleted).length / _todos.length) * 100).round()}%',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Todo items
                      Expanded(
                        child: ListView.builder(
                          itemCount: _todos.length,
                          itemBuilder: (context, index) {
                            final todo = _todos[index];
                            return Container(
                              margin: EdgeInsets.only(bottom: 12),
                              child: Card(
                                color: Colors.white24,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: ListTile(
                                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                  leading: GestureDetector(
                                    onTap: () => _toggleTodo(index),
                                    child: Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.white, width: 2),
                                        color: todo.isCompleted ? Colors.white : Colors.transparent,
                                      ),
                                      child: todo.isCompleted
                                          ? Icon(Icons.check, size: 16, color: Color(0xFF1E3A8A))
                                          : null,
                                    ),
                                  ),
                                  title: Text(
                                    todo.title,
                                    style: TextStyle(
                                      color: todo.isCompleted ? Colors.white60 : Colors.white,
                                      fontSize: 16,
                                      decoration: todo.isCompleted 
                                          ? TextDecoration.lineThrough 
                                          : TextDecoration.none,
                                    ),
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(Icons.delete_outline, color: Colors.white54),
                                    onPressed: () => _deleteTodo(index),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      
                      // Bottom decoration with student info
                      Container(
                        padding: EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.school, color: Colors.white54, size: 16),
                            SizedBox(width: 8),
                            Text(
                              'Mahasiswa Ilmu Komputer',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.laptop_mac, color: Colors.white54, size: 16),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUniversityBuilding() {
    return Container(
      width: 100,
      height: 120,
      child: CustomPaint(
        painter: UniversityBuildingPainter(),
      ),
    );
  }
}

class UniversityBuildingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.white24
      ..style = PaintingStyle.fill;

    final Path path = Path();
    
    // Main building
    path.addRect(Rect.fromLTWH(
      size.width * 0.2, 
      size.height * 0.3, 
      size.width * 0.6, 
      size.height * 0.7
    ));
    
    // Building columns
    for (int i = 0; i < 4; i++) {
      path.addRect(Rect.fromLTWH(
        size.width * (0.25 + i * 0.125), 
        size.height * 0.3, 
        size.width * 0.05, 
        size.height * 0.7
      ));
    }
    
    // Roof triangle
    path.moveTo(size.width * 0.1, size.height * 0.3);
    path.lineTo(size.width * 0.5, size.height * 0.1);
    path.lineTo(size.width * 0.9, size.height * 0.3);
    path.close();
    
    // Clock tower
    path.addRect(Rect.fromLTWH(
      size.width * 0.45, 
      size.height * 0.1, 
      size.width * 0.1, 
      size.height * 0.2
    ));

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}