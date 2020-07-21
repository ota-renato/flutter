import 'dart:io';
import 'dart:async';
import 'package:agenda_contatos/helpers/contact_helper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ContactPage extends StatefulWidget {

  final Contact contact;

  ContactPage({this.contact});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  final _nameFocus = FocusNode();

  final ImagePicker _picker = ImagePicker();

  bool _userEdited = false;

  Contact _editedContact;

  @override
  void initState() {
    super.initState();

    if(widget.contact == null) {
      _editedContact = Contact();
    } else {
      _editedContact = Contact.fromMap(widget.contact.toMap());

      _nameController.text = _editedContact.name;
      _emailController.text = _editedContact.email;
      _phoneController.text = _editedContact.phone;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.red,
              title: Text(_editedContact.name ?? "Novo contato"),
              centerTitle: true,
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if(_editedContact.name != null && _editedContact.name.isNotEmpty) {
                  Navigator.pop(context, _editedContact);
                } else {
                  FocusScope.of(context).requestFocus(_nameFocus);
                }
              },
              child: Icon(Icons.save),
              backgroundColor: Colors.red,
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  GestureDetector(
                    child: Container(
                      width: 140.0,
                      height: 140.0,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: _editedContact.img != null ? FileImage(File(_editedContact.img)) : AssetImage("images/person.png"), fit: BoxFit.cover
                          )
                      ),
                    ),
                    onTap: () {
                      _showOptionsImage();
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: "Nome"),
                    onChanged: (text) {
                      _userEdited = true;
                      setState(() {
                        _editedContact.name = text;
                      });
                    },
                    controller: _nameController,
                    focusNode: _nameFocus,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: "E-mail"),
                    onChanged: (text) {
                      _userEdited = true;
                      _editedContact.email = text;
                    },
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: "Telefone"),
                    onChanged: (text) {
                      _userEdited = true;
                      _editedContact.phone = text;
                    },
                    keyboardType: TextInputType.phone,
                    controller: _phoneController,
                  )
                ],
              ),
            )
        ),
        onWillPop: _requestPop
    );
  }

  Future<bool> _requestPop() {
    if(_userEdited) {
      showDialog(context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Descartar alterações?"),
            content: Text("Se sair, as alterações serão perdidas."),
            actions: <Widget>[
              FlatButton(
                child: Text("Cancelar"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text("Sim"),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              )
            ],
          );
        }
      );
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

  void _showOptionsImage() {
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
                      Padding(
                          padding: EdgeInsets.all(10.0),
                          child: FlatButton(
                              onPressed: () async {
                                await _picker.getImage(source: ImageSource.camera).then((file){
                                  if(file == null) return;
                                  setState(() {
                                    _editedContact.img = file.path;
                                    Navigator.pop(context);
                                  });
                                });
                              },
                              child: Text("Câmera", style: TextStyle(color: Colors.red, fontSize: 20.0),)
                          )
                      ),
                      Padding(
                          padding: EdgeInsets.all(10.0),
                          child: FlatButton(
                              onPressed: () async {
                                await _picker.getImage(source: ImageSource.gallery).then((file){
                                  if(file == null) return;
                                  setState(() {
                                    _editedContact.img = file.path;
                                    Navigator.pop(context);
                                  });
                                });
                              },
                              child: Text("Galeria", style: TextStyle(color: Colors.red, fontSize: 20.0),)
                          )
                      ),
                    ],
                  ),
                );
              }
          );
        }
    );
  }
}
