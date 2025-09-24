import 'package:flutter/material.dart';

// Model class untuk Task = blueprint/template untuk objek Task
class Task {
  // Property untuk menyimpan judul task
  String title;
  // Property untuk menyimpan status selesai/belum
  bool isCompleted;

  // Constructor = function untuk membuat Task baru
  Task({
    // title wajib diisi (required)
    required this.title,
    // isCompleted opsional, default false (belum selesai)
    this.isCompleted = false,
  });

  // Method untuk toggle status completed (true ↔ false)
  void toggle() {
    // Flip boolean: true jadi false, false jadi true
    isCompleted = !isCompleted;
  }

  // Override toString untuk debug print yang readable
  @override
  String toString() {
    return 'Task{title: $title, isCompleted: $isCompleted}';
  }
}

// Function main tetap sama
void main() {
  runApp(MyApp());
}

// Deklarasi class MyApp yang extends (turunan dari) StatelessWidget
class MyApp extends StatelessWidget {
  // Constructor dengan key parameter untuk best practices
  const MyApp({super.key});

  // Override function build yang WAJIB ada di setiap widget
  @override
  Widget build(BuildContext context) {
    // Return MaterialApp sebagai root aplikasi
    return MaterialApp(
      // Nama aplikasi (muncul di task switcher)
      title: 'Todo List Alif Rifai',
      // Tema warna aplikasi yang lebih menarik
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C63FF), // Warna ungu modern
          primary: const Color(0xFF6C63FF),
          secondary: const Color(0xFFFF6584), // Warna pink coral
          background: const Color(0xFFF8F9FF), // Background soft
          surface: Colors.white,
          onPrimary: Colors.white,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Poppins', // Font modern (default Flutter font)
      ),
      // Halaman pertama yang ditampilkan saat app dibuka
      home: const TodoListScreen(),
    );
  }
}

// Deklarasi class TodoListScreen untuk halaman utama
class TodoListScreen extends StatefulWidget {
  // Constructor dengan key parameter untuk best practices
  const TodoListScreen({super.key});

  // Override method untuk membuat state object
  @override
  // Function yang return instance dari state class
  State<TodoListScreen> createState() => _TodoListScreenState();
}

// State class yang menyimpan data dan build UI
class _TodoListScreenState extends State<TodoListScreen> {
  // Helper function untuk statistic items dengan desain lebih menarik
  Widget _buildStatItem(String label, int count, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
              fontFamily: 'Poppins',
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color.withOpacity(0.8),
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }

  // State variables = data yang bisa berubah
  List<Task> tasks = [];
  TextEditingController taskController = TextEditingController();

  // Function addTask dengan validasi comprehensive dan feedback
  void addTask() {
    String newTaskTitle = taskController.text.trim();

    if (newTaskTitle.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.warning, color: Colors.white),
              const SizedBox(width: 8),
              const Text('Task tidak boleh kosong!'),
            ],
          ),
          backgroundColor: Colors.orange,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    bool isDuplicate = tasks.any(
      (task) => task.title.toLowerCase() == newTaskTitle.toLowerCase(),
    );

    if (isDuplicate) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.info, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(child: Text('Task "$newTaskTitle" sudah ada!')),
            ],
          ),
          backgroundColor: const Color(0xFF6C63FF),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    if (newTaskTitle.length > 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(
                child: const Text(
                  'Task terlalu panjang! Maksimal 100 karakter.',
                ),
              ),
            ],
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    setState(() {
      Task newTask = Task(title: newTaskTitle);
      tasks.add(newTask);
    });

    taskController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text('Task "$newTaskTitle" berhasil ditambahkan!')),
          ],
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    print('Task ditambahkan: $newTaskTitle');
  }

  // Function async untuk menghapus task dengan konfirmasi dialog
  void removeTask(int index) async {
    Task taskToDelete = tasks[index];

    bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF6584), Color(0xFFFF9580)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(Icons.warning, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  'Konfirmasi Hapus',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Apakah kamu yakin ingin menghapus task ini?',
                style: TextStyle(fontFamily: 'Poppins'),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.grey[100]!, Colors.grey[50]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Text(
                  '"${taskToDelete.title}"',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Poppins',
                    color: Colors.grey[800],
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey[600],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Batal',
                style: TextStyle(fontFamily: 'Poppins'),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6584),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: const Text(
                'Hapus',
                style: TextStyle(fontFamily: 'Poppins'),
              ),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true) {
      setState(() {
        tasks.removeAt(index);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.delete, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(child: Text('Task "${taskToDelete.title}" dihapus')),
            ],
          ),
          backgroundColor: const Color(0xFFFF6584),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );

      print('Task dihapus: ${taskToDelete.title}');
    }
  }

  // Function untuk toggle status completed
  void toggleTask(int index) {
    setState(() {
      tasks[index].toggle();
    });

    Task task = tasks[index];
    String message = task.isCompleted
        ? 'Selamat! Task "${task.title}" selesai! 🎉'
        : 'Task "${task.title}" ditandai belum selesai';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              task.isCompleted ? Icons.celebration : Icons.undo,
              color: Colors.white,
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: task.isCompleted
            ? const Color(0xFF4CAF50)
            : const Color(0xFF6C63FF),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    print(
      'Task ${task.isCompleted ? "completed" : "uncompleted"}: ${task.title}',
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        title: const Text(
          "Todo List Najwan Wi'am Asroshan",
          style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
        ),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Input Section dengan desain card modern
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white, colorScheme.surface],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.primary.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
                border: Border.all(color: colorScheme.primary.withOpacity(0.1)),
              ),
              child: Column(
                children: [
                  TextField(
                    controller: taskController,
                    textCapitalization: TextCapitalization.sentences,
                    maxLength: 100,
                    decoration: InputDecoration(
                      hintText: 'Apa yang ingin kamu lakukan hari ini?',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: colorScheme.background,
                      prefixIcon: Icon(Icons.edit, color: colorScheme.primary),
                      counterText: '',
                      helperText: 'Maksimal 100 karakter',
                      helperStyle: TextStyle(
                        color: colorScheme.primary.withOpacity(0.6),
                        fontFamily: 'Poppins',
                      ),
                    ),
                    onSubmitted: (value) => addTask(),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: addTask,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_circle_outline),
                          const SizedBox(width: 8),
                          Text(
                            'Tambah Task',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Statistics Section
            if (tasks.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colorScheme.primary.withOpacity(0.05),
                      colorScheme.primary.withOpacity(0.02),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.primary.withOpacity(0.05),
                      spreadRadius: 1,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  border: Border.all(
                    color: colorScheme.primary.withOpacity(0.1),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      "📊 Progress Najwan Wi'am Asroshan",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem(
                          'Total',
                          tasks.length,
                          Icons.list_alt,
                          colorScheme.primary,
                        ),
                        _buildStatItem(
                          'Selesai',
                          tasks.where((task) => task.isCompleted).length,
                          Icons.check_circle,
                          const Color(0xFF4CAF50),
                        ),
                        _buildStatItem(
                          'Belum',
                          tasks.where((task) => !task.isCompleted).length,
                          Icons.access_time,
                          const Color(0xFFFF9800),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

            // Task List Section
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  border: Border.all(color: Colors.grey.withOpacity(0.2)),
                ),
                child: tasks.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.task_alt,
                              size: 80,
                              color: colorScheme.primary.withOpacity(0.3),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Yuk mulai produktif!',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: colorScheme.primary,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Tambahkan task pertama Wi'am",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          Task task = tasks[index];

                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: task.isCompleted
                                    ? [
                                        const Color(0xFFE8F5E8),
                                        const Color(0xFFF0F9F0),
                                      ]
                                    : [Colors.white, colorScheme.background],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 3,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                              border: Border.all(
                                color: task.isCompleted
                                    ? const Color(0xFF4CAF50).withOpacity(0.3)
                                    : colorScheme.primary.withOpacity(0.2),
                                width: 1.5,
                              ),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: ListTile(
                                leading: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: task.isCompleted
                                          ? [
                                              const Color(0xFF4CAF50),
                                              const Color(0xFF45a049),
                                            ]
                                          : [
                                              colorScheme.primary,
                                              colorScheme.primary.withOpacity(
                                                0.7,
                                              ),
                                            ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            (task.isCompleted
                                                    ? const Color(0xFF4CAF50)
                                                    : colorScheme.primary)
                                                .withOpacity(0.3),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: task.isCompleted
                                        ? const Icon(
                                            Icons.check,
                                            color: Colors.white,
                                            size: 20,
                                          )
                                        : Text(
                                            '${index + 1}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                  ),
                                ),
                                title: Text(
                                  task.title,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: task.isCompleted
                                        ? Colors.grey[600]
                                        : Colors.black87,
                                    decoration: task.isCompleted
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                subtitle: Text(
                                  task.isCompleted
                                      ? '✅ Selesai'
                                      : '⏳ Dalam progres',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: task.isCompleted
                                        ? const Color(0xFF4CAF50)
                                        : const Color(0xFFFF9800),
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        task.isCompleted
                                            ? Icons.undo
                                            : Icons.check_circle,
                                        color: task.isCompleted
                                            ? const Color(0xFFFF9800)
                                            : const Color(0xFF4CAF50),
                                      ),
                                      onPressed: () => toggleTask(index),
                                      tooltip: task.isCompleted
                                          ? 'Tandai belum selesai'
                                          : 'Tandai selesai',
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.delete_outline,
                                        color: const Color(0xFFFF6584),
                                      ),
                                      onPressed: () => removeTask(index),
                                      tooltip: 'Hapus task',
                                    ),
                                  ],
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                onTap: () => toggleTask(index),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              tasks.isEmpty
                  ? '🌟 Ayo mulai produktif hari ini!'
                  : "✨ Wi'am punya ${tasks.length} task${tasks.length > 1 ? 's' : ''} untuk diselesaikan",
              style: TextStyle(
                fontSize: 14,
                color: tasks.isEmpty
                    ? colorScheme.primary.withOpacity(0.7)
                    : colorScheme.primary,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
