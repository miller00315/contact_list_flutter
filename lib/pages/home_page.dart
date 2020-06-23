import 'package:contacts/db/entities/contact.dart';
import 'package:contacts/db/repository/contact_repository.dart';
import 'package:contacts/pages/contact_page.dart';
import 'package:contacts/widgets/home_page_body.dart';
import 'package:contacts/widgets/home_page_options_modal.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

enum OrderOptions {
  orderAZ,
  orderZA,
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ContactRepository _contactRepository;

  List<Contact> _contacts = [];

  @override
  void initState() {
    super.initState();
    this._contactRepository = ContactRepository();

    this._listContacts();
  }

  void _listContacts() async {
    final contacts = await _contactRepository.list();

    setState(() {
      _contacts = contacts;
    });
  }

  void _showContactPage({Contact contact}) async {
    final recContact = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContactPage(
          contact: contact,
        ),
      ),
    );

    if (recContact != null) {
      if (contact != null) {
        await _contactRepository.update(recContact);
      } else {
        await _contactRepository.save(recContact);
      }
      this._listContacts();
    }
  }

  void _editContact(int index) {
    Navigator.pop(context);
    _showContactPage(contact: _contacts[index]);
  }

  void _delete(int index) {
    Navigator.pop(context);
    _contactRepository.delete(_contacts[index].id);

    setState(() {
      _contacts.removeAt(index);
    });
  }

  void _call(int index) {
    Navigator.pop(context);
    launch('tel: ${_contacts[index].phone}');
  }

  void _showOptions(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return BottomSheet(
          onClosing: () {},
          builder: (context) {
            return Container(
              padding: EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  buildModalButton('Ligar', _call, index),
                  buildModalButton('Editar', _editContact, index),
                  buildModalButton('Excluir', _delete, index),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _orderContacts(OrderOptions order) {
    switch (order) {
      case OrderOptions.orderAZ:
        _contacts.sort((first, second) {
          return first.name.toLowerCase().compareTo(second.name.toLowerCase());
        });
        break;
      case OrderOptions.orderZA:
        _contacts.sort((first, second) {
          return second.name.toLowerCase().compareTo(first.name.toLowerCase());
        });
        break;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.red,
        title: Text(
          'Contatos',
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          PopupMenuButton<OrderOptions>(
            itemBuilder: (BuildContext context) =>
                <PopupMenuEntry<OrderOptions>>[
              const PopupMenuItem<OrderOptions>(
                child: Text('Ordernar A a Z'),
                value: OrderOptions.orderAZ,
              ),
              const PopupMenuItem<OrderOptions>(
                child: Text('Ordernar Z a A'),
                value: OrderOptions.orderZA,
              ),
            ],
            onSelected: (OrderOptions order) => _orderContacts(order),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: homeBody(this._contacts, this._showOptions),
      floatingActionButton: FloatingActionButton(
        onPressed: () => this._showContactPage(),
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.red,
      ),
    );
  }
}
