import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class SavedCharactersPage extends StatefulWidget {
  const SavedCharactersPage({super.key});

  @override
  State<SavedCharactersPage> createState() => _SavedCharactersPageState();
}

class _SavedCharactersPageState extends State<SavedCharactersPage> {
  List<File> _characterFiles = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadCharacterFiles();
  }

  Future<void> _loadCharacterFiles() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final files = directory.listSync();
      setState(() {
        _characterFiles = files
            .where((file) =>
                file is File && file.path.contains('saved_character_'))
            .map((file) => file as File)
            .toList();
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
      debugPrint('Error loading character files: $e');
    }
  }

  void _showCharacterDetails(BuildContext context, File file) async {
    try {
      final fileContent = await file.readAsString();
      if (fileContent.isEmpty) {
        _showErrorDialog(context, 'File is empty.');
        return;
      }
      final characterData = jsonDecode(fileContent) as Map<String, dynamic>;

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(file.path.split('/').last),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: characterData.entries.map((entry) {
                final value = entry.value is List ? entry.value.join(', ') : entry.value;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text('${entry.key}: $value'),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    } catch (e) {
      _showErrorDialog(context, 'Could not read character details: $e');
    }
  }

  Future<void> _deleteCharacterFile(File file) async {
    try {
      await file.delete();
      setState(() {
        _characterFiles.remove(file);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${file.path.split('/').last} deleted.')),
      );
    } catch (e) {
      _showErrorDialog(context, 'Error deleting file: $e');
    }
  }

  void _confirmDelete(BuildContext context, File file) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Character'),
        content: Text('Are you sure you want to delete ${file.path.split('/').last}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteCharacterFile(file);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Characters'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _characterFiles.isEmpty
              ? const Center(child: Text('персонажів не знайдено'))
              : ListView.builder(
                  itemCount: _characterFiles.length,
                  itemBuilder: (context, index) {
                    final file = _characterFiles[index];
                    return ListTile(
                      title: Text(file.path.split('/').last),
                      onTap: () => _showCharacterDetails(context, file),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _confirmDelete(context, file),
                      ),
                    );
                  },
                ),
    );
  }
}