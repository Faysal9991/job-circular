import 'package:flutter/material.dart';
import 'package:job_circuler/model/job_model.dart';
import 'package:job_circuler/provider/auth_provider.dart';
import 'package:job_circuler/provider/dashboard_provider.dart';
import 'package:job_circuler/screens/home/home_screen.dart';
import 'package:job_circuler/screens/home/job_details.dart';
import 'package:provider/provider.dart';

class BookMarkPage extends StatefulWidget {
  const BookMarkPage({super.key});

  @override
  State<BookMarkPage> createState() => _BookMarkPageState();
}

class _BookMarkPageState extends State<BookMarkPage> {
  @override
  void initState() {
    Provider.of<AuthProvider>(context, listen: false).getUserId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text(
          "Find your Bookmark",
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Consumer2<DashBoardProvider, AuthProvider>(
            builder: (context, pro, auth, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: StreamBuilder<List<JobModel>>(
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
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: jobModels.length,
                            separatorBuilder: (ctx, idx) {
                              return const SizedBox(
                                height: 10,
                              );
                            },
                            itemBuilder: (cont, index) {
                              return jobModels[index]
                                      .bookMark
                                      .contains(auth.userId)
                                  ? InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    JobDetails(
                                                      model:
                                                          snapshot.data![index],
                                                    )));
                                      },
                                      child: jobCard(
                                          context: context,
                                          data: jobModels[index],
                                          provider: pro,
                                          index: index,
                                          auth: auth))
                                  : SizedBox.shrink();
                            });
                      }
                    },
                  ))
            ],
          );
        }),
      ),
    );
  }
}
