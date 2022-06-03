import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Gestion_Absences_employees/FirestoreOperstions.dart';
import 'package:Gestion_Absences_employees/Supervisor/DashBoard.dart';

import 'verifyPage.dart';

class SignupPage extends StatefulWidget {
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _emailField = TextEditingController();
  TextEditingController _passwordField = TextEditingController();
  TextEditingController _fullName = TextEditingController();
  TextEditingController _phoneNumber = TextEditingController();
  TextEditingController _address = TextEditingController();
  // late String _phoneNumber="125845";

  late User cUser;
  late String currentUserID;

  Future<bool> register(String email, String password, String name,
      String phone, String address) async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        cUser = FirebaseAuth.instance.currentUser;
        currentUserID = cUser.uid;

        return true;
      } on FirebaseAuthException catch (e) {
        if (e.code == "weak-password") {
          // print("The password provided is too weak.");
          showError("Le mot de passe fourni est trop faible.");
        } else if (e.code == "email-already-in-use") {
          // print("The account already exists for that email.");
          showError("Le compte existe déjà pour cet e-mail.");
        }
        return false;
      } catch (e) {
        print(e.toString());
        showError(e.toString());
        return false;
      }
    }
    return false;
  }

  void showError(String errormessage) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('ERROR'),
            content: Text(errormessage),
            actions: <Widget>[
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40),
          height: MediaQuery.of(context).size.height - 50,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    "S'inscrire",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Créer un compte, c'est gratuit",
                    style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                  )
                ],
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _fullName,
                      validator: (name) {
                        if (name!.isEmpty) {
                          return "Entrez le nom";
                        }
                      },
                      decoration: InputDecoration(
                          labelText: "Nom d'utilisateur",
                          prefixIcon: Icon(Icons.email_outlined),
                          hintText: "Nom d'utilisateur",
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey))),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _emailField,
                      validator: (Email_input) {
                        if (Email_input!.isEmpty) {
                          return "Entrez correctement l'e-mail";
                        }
                      },
                      decoration: InputDecoration(
                          labelText: "Email",
                          prefixIcon: Icon(Icons.email_outlined),
                          hintText: "email@email.com",
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey))),
                      onSaved: (email) =>
                          _emailField = email as TextEditingController,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      //----------------------------> input field
                      controller: _passwordField,
                      validator: (password_input) {
                        if (password_input!.length < 6) {
                          return "Entrez au moins 6 caractères";
                        }
                      },
                      decoration: InputDecoration(
                          labelText: "Mot de passe",
                          prefixIcon: Icon(Icons.email_outlined),
                          hintText: "le mot de passe",
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey))),
                      onSaved: (password) =>
                          _emailField = password as TextEditingController,
                      obscureText: true,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      validator: (password) {
                        if (_passwordField.text != password) {
                          return "Le mot de passe ne correspond pas";
                        } else if (password!.isEmpty) {
                          return "Entrer le mot de passe";
                        }
                      },
                      decoration: InputDecoration(
                          labelText: "Mot de passe",
                          prefixIcon: Icon(Icons.lock_outline_rounded),
                          hintText: "le mot de passe",
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey))),
                      onSaved: (password) =>
                          _emailField = password as TextEditingController,
                      obscureText: true,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _phoneNumber,
                      validator: (phonenumber) {
                        if (phonenumber!.isEmpty) {
                          return "Entrez le numéro de téléphone";
                        }
                      },
                      decoration: InputDecoration(
                          labelText: "Numéro de téléphone",
                          prefixIcon: Icon(Icons.phone),
                          hintText: "01154785422",
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey))),
                      onSaved: (phonenumber) =>
                          _phoneNumber = phonenumber as TextEditingController,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _address,
                      validator: (address) {
                        if (address!.isEmpty) {
                          return "Entrer l'adresse";
                        }
                      },
                      decoration: InputDecoration(
                          labelText: "Adresse",
                          prefixIcon: Icon(Icons.location_on_sharp),
                          hintText: "Adresse",
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey))),
                      onSaved: (address) =>
                          _address = address as TextEditingController,
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 3, left: 3),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border(
                      bottom: BorderSide(color: Colors.black),
                      top: BorderSide(color: Colors.black),
                      left: BorderSide(color: Colors.black),
                      right: BorderSide(color: Colors.black),
                    )),
                child: MaterialButton(
                  minWidth: double.infinity,
                  height: 60,
                  onPressed: () async {
                    bool shouldNavigate = await register(
                        _emailField.text,
                        _passwordField.text,
                        _fullName.text,
                        _phoneNumber.text,
                        _address.text);
                    if (shouldNavigate) {
                      CreateSupervisorInFirestore(
                          //-------------------------> call supervisor func
                          _fullName.text,
                          _emailField.text,
                          currentUserID,
                          _phoneNumber.text,
                          _address.text); //create a new user

                      Navigator.pop(context);

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => verifyPage()));
                    }
                  },
                  color: Color.fromARGB(255, 215, 67, 67),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Text(
                    "S'inscrire",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Vous avez déjà un compte?"),
                  Text(
                    "Connexion",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
