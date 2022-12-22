import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
      routes: {
        '/new-contact': ((context) => NewContactView()),
      },
    );
  }
}

class Contact {
  String name;
  Contact({
    required this.name,
  });
}

class ContactBook {
  ContactBook._sharedInstance();
  static final ContactBook _shared = ContactBook._sharedInstance();
  factory ContactBook() => _shared;

  final List<Contact> _contact = [
    Contact(name: 'bara bara'),
  ];

  int get length => _contact.length;
  void add({required Contact contact}) {
    _contact.add(contact);
  }

  void remove({required Contact contact}) {
    _contact.remove(contact);
  }

  Contact? contact({required int atIndex}) =>
      _contact.length > atIndex ? _contact[atIndex] : null;
}

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key, required this.title});
  String title;

  @override
  Widget build(BuildContext context) {
    final ContactBook contactBook = ContactBook();

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ListView.builder(
        itemCount: contactBook.length,
        itemBuilder: (context, index) {
          final contact = contactBook.contact(atIndex: index)!;
          return ListTile(
            title: Text(contact.name),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (() async{
          await Navigator.of(context).pushNamed('/new-contact');
        }),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class NewContactView extends StatefulWidget {
  const NewContactView({super.key});

  @override
  State<NewContactView> createState() => _NewContactViewState();
}

class _NewContactViewState extends State<NewContactView> {
  late final TextEditingController _controller;
  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new contact'),
      ),
      body: Column(children: [
        TextField(
          controller: _controller,
          decoration: const InputDecoration(
            hintText: 'Enter the name of the contact here...',
          ),
        ),
        TextButton(
          onPressed: (() {
            final contact = Contact(name: _controller.text);
            ContactBook().add(contact: contact);
            Navigator.of(context).pop();
          }),
          child: Text('Add new contact'),
        ),
      ]),
    );
  }
}
