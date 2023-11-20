import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/authentication_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final nameController = TextEditingController();
  @override
  void initState() {
    super.initState();
    getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocConsumer<AuthenticationCubit, AuthenticationState>(
          listener: (context, state) {
            if (state is AuthenticationError) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message)));
            } else if (state is UserCreated) {
              getUsers();
            }
          },
          builder: (context, state) {
            if (state is GettingUsers || state is CreatingUser) {
              return const CircularProgressIndicator();
            } else if (state is UsersLoaded) {
              return ListView.builder(
                itemCount: state.users.length,
                itemBuilder: (context, index) {
                  final user = state.users[index];
                  return ListTile(
                    leading: Image.network(user.avatar),
                    title: Text(user.name),
                    subtitle: Text(user.createdAt),
                  );
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await showDialog(
            context: context,
            barrierDismissible: true,
            builder: (context) => AddUserDialog(controller: nameController),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add User'),
      ),
    );
  }

  void getUsers() {
    context.read<AuthenticationCubit>().getUsers();
  }
}

class AddUserDialog extends StatelessWidget {
  const AddUserDialog({super.key, required this.controller});

  final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: 'username',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final name = controller.text.trim();
                  const avatar =
                      'https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLH'
                      'GVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/633.jpg';
                  context.read<AuthenticationCubit>().createUser(
                        name: name,
                        avatar: avatar,
                        createdAt: DateTime.now().toIso8601String(),
                      );
                  Navigator.of(context).pop();
                },
                child: const Text('Create User'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
