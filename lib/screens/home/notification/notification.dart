import 'package:flutter/material.dart';
import 'package:job_circuler/model/notification_model.dart';
import 'package:job_circuler/provider/auth_provider.dart';
import 'package:job_circuler/provider/dashboard_provider.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<DashBoardProvider,AuthProvider>(builder: (context, provider,auth, child) {
      return Scaffold(
          appBar: AppBar(
            title: const Text("Notification"),
            centerTitle: true,
          ),
          body: StreamBuilder<List<NotificationModel>>(
              stream: provider.getNotification(auth.getUserId().toString()),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                        var data =   snapshot.data![index];
                          provider.updateNotification(data.id!,auth.userId!);
                          return Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: const Color(0xffC2DFDB), borderRadius: BorderRadius.circular(7)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${snapshot.data![index].title}",
                                    style: Theme.of(context).textTheme.bodyLarge,
                                  ),
                                  const Divider(
                                    color: Colors.white,
                                  ),
                                  Text(
                                    "${snapshot.data![index].description}",
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  );
                }
              }));
    });
  }
}
