import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:task_manager/ui/controllers/auth_controller.dart';
import 'package:task_manager/ui/screens/edit_profile_screen.dart';
import 'package:task_manager/ui/screens/login_screen.dart';

class ProfileSummaryCard extends StatelessWidget {
  ProfileSummaryCard({
    super.key,
    this.enableOnTap = true,
  });

  final bool enableOnTap;

  String base64String=
      AuthController.user?.photo ?? '';


  @override
  Widget build(BuildContext context) {
    if (base64String.startsWith('data:image')) {
      // Remove data URI prefix if present
      base64String =
          base64String.replaceFirst(RegExp(r'data:image/[^;]+;base64,'), '');
    }
    Uint8List? imageBytes;


    try {
      imageBytes = Base64Decoder().convert(base64String);
    } catch (e) {
      // Handle the exception (e.g., log the error, show a default image, etc.)
      print('Error decoding base64 image: $e');
      // You can set a default image or leave imageBytes as null
    }

    return ListTile(
      onTap: () {
        if (enableOnTap) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const EditProfileScreen(),
            ),
          );
        }
      },
      leading: CircleAvatar(
        child: AuthController.user?.photo == null
            ? const Icon(Icons.person)
            : ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Image.memory(
            imageBytes ?? Uint8List(0), // Use a default image or an empty Uint8List
            fit: BoxFit.cover,
          ),
        ),
      ),
      title: Text(
        fullName,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
      ),
      subtitle: Text(
        AuthController.user?.email ?? '',
        style: const TextStyle(color: Colors.white),
      ),
      trailing: IconButton(
        onPressed: () async {
          await AuthController.clearAuthData();
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false);
        },
        icon: const Icon(Icons.logout),
      ),
      tileColor: Colors.green,
    );
  }

  String get fullName {
    return '${AuthController.user?.firstName ?? ''} ${AuthController.user?.lastName ?? ''}';
  }
}
