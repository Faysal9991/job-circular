import 'package:flutter/material.dart';
import 'package:job_circuler/model/job_model.dart';
import 'package:job_circuler/provider/auth_provider.dart';
import 'package:job_circuler/provider/dashboard_provider.dart';
import 'package:job_circuler/screens/home/home_screen.dart';
import 'package:provider/provider.dart';

class FromDrawerScreen extends StatefulWidget {
  final String categoryName;
  const FromDrawerScreen({super.key, required this.categoryName});

  @override
  State<FromDrawerScreen> createState() => _FromDrawerScreenState();
}

class _FromDrawerScreenState extends State<FromDrawerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.categoryName,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
      body: Consumer2<DashBoardProvider, AuthProvider>(
          builder: (context, pro, auth, child) {
        return SingleChildScrollView(
          child: Column(
            children: [
              StreamBuilder<List<JobModel>>(
                  stream: pro.getJobs(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      // Use the data from the stream
                      List<JobModel> jobModels = snapshot.data!;
                      return ListView.separated(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        separatorBuilder: ((context, index) => const SizedBox(
                              height: 10,
                            )),
                        itemBuilder: ((context, index) {
                          return pro.type[pro.selectedIndex] ==
                                  snapshot.data![index].type
                              ? SizedBox(
                                  child: jobCard(
                                      context: context,
                                      data: jobModels[index],
                                      provider: pro,
                                      index: index,
                                      auth: auth),
                                )
                              : const SizedBox.shrink();
                        }),
                      );
                    }
                  }),
            ],
          ),
        );
      }),
    );
  }
}
