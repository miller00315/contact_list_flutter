import 'package:contacts/db/entities/contact.dart';
import 'package:contacts/db/repository/contact_repository.dart';
import 'package:contacts/widgets/contact_page_body.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ContactPage extends StatefulWidget {
  final Contact contact;

  ContactPage({this.contact});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  ContactRepository _contactRepository;

  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nameFocus = FocusNode();
  final _picker = ImagePicker();

  Contact _contact;

  bool _contactEdited = false;

  @override
  void initState() {
    super.initState();
    this._contactRepository = ContactRepository();

    if (widget.contact == null) {
      _contact = new Contact();
    } else {
      _contact = Contact.fromMap(widget.contact.toMap());

      _nameController.text = _contact.name;
      _emailController.text = _contact.email;
      _phoneController.text = _contact.phone;
    }
  }

  void _onChangedName(String text) {
    setState(() {
      _contact.name = text;
      _contactEdited = true;
    });
  }

  void _onChangedPhone(String text) {
    setState(() {
      _contact.phone = text;
      _contactEdited = true;
    });
  }

  void _onChangedEmail(String text) {
    setState(() {
      _contact.email = text;
      _contactEdited = true;
    });
  }

  void _saveContact() {
    if (_contact.name != null && _contact.name.isNotEmpty) {
      Navigator.pop(context, _contact);
    } else {
      FocusScope.of(context).requestFocus(_nameFocus);
    }
  }

  Future _changePhoto() async {
    final pickFile = await _picker.getImage(source: ImageSource.gallery);

    if (pickFile == null) return;

    setState(() {
      _contact.image = pickFile.path;
    });
  }

  Future<bool> _requestPop() {
    if (_contactEdited) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Descartar aletrações?'),
              content: Text('Se você sair as alterações serão perdidas'),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancelar')),
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Text('Sim'),
                ),
              ],
            );
          });
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.red,
          title: Text(
            _contact.name ?? 'Novo contato',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: contactPageBody(
          _contact,
          _onChangedName,
          _onChangedPhone,
          _onChangedEmail,
          _nameController,
          _phoneController,
          _emailController,
          _nameFocus,
          _changePhoto,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => this._saveContact(),
          child: Icon(
            Icons.save,
            color: Colors.white,
          ),
          backgroundColor: Colors.red,
        ),
      ),
      onWillPop: _requestPop,
    );
  }
}
