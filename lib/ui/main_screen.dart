import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_db/bloc/bloc.dart';
import 'package:test_db/bloc/events.dart';
import 'package:test_db/bloc/states.dart';
import 'package:test_db/model/user.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<FormState> _addUserFormKey = GlobalKey<FormState>();
  String tempUserName = '';
  int tempUserAge = 0;
  List<User> listUsers = [];

  @override
  Widget build(BuildContext context) {
    // BlocBuilder, BlocConsumer
    return BlocConsumer<UsersBloc, UsersState>(
      listener: (BuildContext context, state) {
        if (state is UsersLoadedState) {
          //print(state.users);
          listUsers = state.users;
        }
      },
      builder: (BuildContext context, state) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(10.0,0,10.0,0),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height:10),
              Form(
                key: _addUserFormKey,
                child: Column(
                  children: [
                    TextFormField(
                        onSaved: (String? value) {
                          setState(() {
                            tempUserName = value!;
                          });
                        },
                        validator: (String? value) {
                          if(value!.isEmpty) {
                            return "Введіть ваше ім'я";
                          }
                          if(RegExp(r"[0-9]").hasMatch(value)) {
                            return "Введіть ваше справжнє ім'я";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.name,
                        decoration: const InputDecoration(hintText: "Ім'я")
                    ),
                    const SizedBox(height:10),
                    TextFormField(
                      onSaved: (String? value) {
                        setState(() {
                          tempUserAge = int.parse(value!);
                        });
                      },
                      validator: (String? value) {
                        if(value!.isEmpty) {
                          return "Введіть ваш вік";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(hintText: 'Вік'),
                    ),
                  ],

                ),),
              ElevatedButton(
                onPressed: () {
                  final isValid = _addUserFormKey.currentState?.validate();
                  if(isValid!) {
                    _addUserFormKey.currentState?.save();
                    _addTestValues();
                  }
                },//_addTestValues,
                child: const Text('Додати користувача'),
              ),
              ElevatedButton(
                onPressed: _printUsers,
                child: const Text('Показати користувачів'),
              ),
              Container(
                height:1,
                decoration: const BoxDecoration(color:Colors.black12),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: listUsers.length,
                  itemBuilder: (BuildContext context,int index) {
                    return Container(
                      margin: const EdgeInsets.only(top:3,bottom: 3),
                      decoration: BoxDecoration(color: index.isOdd ? Colors.blueAccent : Colors.lightGreenAccent),
                        child: Text("Ім'я: ${listUsers[index].name}\nВік: ${listUsers[index].age}"));
                  },
                ),
              ),
            ],
          ),
        );
      }
    );
  }

  void _addTestValues() {
    final bloc = BlocProvider.of<UsersBloc>(context);
    if(tempUserAge >= 0 && tempUserAge < 110) {
      bloc.add(
        AddUserEvent(
          User(
            name: tempUserName,
            age: tempUserAge,
          ),
        ),
      );
    }
    setState(() {
      tempUserName = '';
      tempUserAge = 0;
      _addUserFormKey.currentState?.reset();
    });
  }

  void _printUsers() {
    final bloc = BlocProvider.of<UsersBloc>(context);
    bloc.add(LoadUsersEvent());
  }
}
