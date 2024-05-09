import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:job_circuler/provider/auth_provider.dart';
import 'package:job_circuler/screens/auth/login.dart';
import 'package:job_circuler/screens/auth/sign_up.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  String _errorMessage = '';
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Consumer<AuthProvider>(builder: (context, provider, child) {
        return ListView(
          children: [
            // User card
            BigUserCard(
              backgroundColor: Colors.white,
              userName: "${provider.userModel.userName}",
              userProfilePic: const AssetImage(
                "assets/background/profile.jpg",
              ),
              cardActionWidget: SettingsItem(
                icons: Icons.check_circle,
                title: provider.userModel.userName == null ||
                        provider.userModel.userName == ""
                    ? "Please login First"
                    : "${provider.userModel.userName}",
                onTap: () {
                  if (provider.userModel.userName == null ||
                      provider.userModel.userName == "") {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const LoginScreen()));
                  } else {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Update Name'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  controller: _nameController,
                                  decoration: const InputDecoration(
                                      labelText: 'New Name'),
                                ),
                                if (_errorMessage.isNotEmpty)
                                  Text(
                                    _errorMessage,
                                    style: const TextStyle(color: Colors.red),
                                  ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  if (_nameController.text.isEmpty) {
                                    EasyLoading.showError("Name is empty");
                                  }else{
                                    provider.updateUserName(_nameController.text);
                                  }
                                },
                                child: const Text('Update'),
                              ),
                            ],
                          );
                        });
                  }
                },
              ),
            ),
            SettingsGroup(
              items: [
                SettingsItem(
                  onTap: () {
                    final snackBar = SnackBar(
                      /// need to set following properties for best effect of awesome_snackbar_content
                      elevation: 0,
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.transparent,
                      content: AwesomeSnackbarContent(
                        title: 'On Sorry !',
                        message: 'This feature will come in soon ',

                        /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                        contentType: ContentType.failure,
                      ),
                    );

                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(snackBar);
                  },
                  icons: Icons.dark_mode_rounded,
                  iconStyle: IconStyle(
                    iconsColor: Colors.white,
                    withBackground: true,
                    backgroundColor: Colors.red,
                  ),
                  title: 'Dark mode',
                  subtitle: "Automatic",
                  trailing: Switch.adaptive(
                    value: provider.isdark,
                    onChanged: (value) {
                      provider.changeTheme(value);
                    },
                  ),
                ),
              ],
            ),
            SettingsGroup(
              items: [
                SettingsItem(
                  onTap: () {
                    final snackBar = SnackBar(
                      /// need to set following properties for best effect of awesome_snackbar_content
                      elevation: 0,
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.transparent,
                      content: AwesomeSnackbarContent(
                        title: 'On Sorry !',
                        message: 'This feature will come in soon ',

                        /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                        contentType: ContentType.failure,
                      ),
                    );

                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(snackBar);
                  },
                  icons: Icons.info_rounded,
                  iconStyle: IconStyle(
                    backgroundColor: Colors.purple,
                  ),
                  title: 'About',
                  subtitle: "Learn more about our app",
                ),
              ],
            ),
            // You can add a settings title
            Consumer<AuthProvider>(builder: (context, provider, child) {
              return SettingsGroup(
                settingsGroupTitle: "Account",
                items: [
                  provider.userModel.email != null
                      ? SettingsItem(
                          onTap: () {
                            provider.logout();
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()));
                          },
                          icons: Icons.exit_to_app_rounded,
                          title: "Sign Out",
                        )
                      : SettingsItem(
                          onTap: () {
                            provider.logout();
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SignUpScreen()));
                          },
                          icons: Icons.exit_to_app_rounded,
                          title: "Create account",
                        ),
                  SettingsItem(
                    onTap: () {
                      final snackBar = SnackBar(
                        /// need to set following properties for best effect of awesome_snackbar_content
                        elevation: 0,
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.transparent,
                        content: AwesomeSnackbarContent(
                          title: 'On Sorry !',
                          message: 'This feature will come in soon ',

                          /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                          contentType: ContentType.failure,
                        ),
                      );

                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(snackBar);
                    },
                    icons: CupertinoIcons.delete_solid,
                    title: "Delete account",
                    titleStyle: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              );
            }),
          ],
        );
      }),
    );
  }
}

class UpdateNameDialog extends StatefulWidget {
  @override
  _UpdateNameDialogState createState() => _UpdateNameDialogState();
}

class _UpdateNameDialogState extends State<UpdateNameDialog> {
  final TextEditingController _nameController = TextEditingController();
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Update Name'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'New Name'),
          ),
          if (_errorMessage.isNotEmpty)
            Text(
              _errorMessage,
              style: const TextStyle(color: Colors.red),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {},
          child: const Text('Update'),
        ),
      ],
    );
  }
}
