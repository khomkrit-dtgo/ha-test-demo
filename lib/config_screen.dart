import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigScreen extends StatefulWidget {
  const ConfigScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ConfigScreen();
}

class _ConfigScreen extends State<ConfigScreen> {
  final urlTextEditingController = TextEditingController();
  final tokenTextEditingController = TextEditingController();

  @override
  void initState() {
    _loadConfigure();
    super.initState();
  }

  void _loadConfigure() async {
    final prefs = await SharedPreferences.getInstance();
    urlTextEditingController.text = prefs.getString('url') ?? '';
    tokenTextEditingController.text = prefs.getString('token') ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Config', style: TextStyle(color: Colors.white)),
        backgroundColor: theme.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Column(
          children: [
            ..._buildForm(),
            const SizedBox(height: 40),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildForm() {
    return [
      TextField(
        controller: urlTextEditingController,
        decoration: const InputDecoration(
          label: Text('URL'),
        ),
      ),
      TextField(
        controller: tokenTextEditingController,
        decoration: const InputDecoration(
          label: Text('Long Live Access Token'),
        ),
      ),
    ];
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: () async {
        bool? confirm = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => _buildAlertDialog(),
        );

        if (confirm == true) _updateConfig();
      },
      child: const Text('Save'),
    );
  }

  Widget _buildAlertDialog() {
    return AlertDialog(
      title: const Text('Confirm Update'),
      content: const SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text('This is a demo alert dialog.'),
            Text('Would you like to approve of this message?'),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        TextButton(
          child: const Text('Save'),
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    );
  }

  void _updateConfig() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('url', urlTextEditingController.text.trim());
    await prefs.setString('token', tokenTextEditingController.text.trim());
  }
}
