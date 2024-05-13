import 'package:flutter/material.dart';
import 'package:job_circuler/model/job_model.dart';
import 'package:job_circuler/provider/auth_provider.dart';
import 'package:job_circuler/provider/dashboard_provider.dart';
import 'package:job_circuler/screens/home/home_screen.dart';
import 'package:provider/provider.dart';

class DeadlineScreen extends StatefulWidget {
  const DeadlineScreen({super.key});

  @override
  State<DeadlineScreen> createState() => _DeadlineScreenState();
}

class _DeadlineScreenState extends State<DeadlineScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<DashBoardProvider, AuthProvider>(
        builder: (context, provider, auth, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            "Filter Jobs By Deadline",
            style: Theme.of(context).appBarTheme.titleTextStyle,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              Container(
                height: 60,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: ListView.separated(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: provider.deadlineFilter.length,
                      separatorBuilder: (ctx, idx) {
                        return const SizedBox(
                          width: 10,
                        );
                      },
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            InkWell(
                              onTap: () {
                                provider.channgeDeadlineFilterName(index);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color:
                                        provider.selectedDeadlineFilterName ==
                                                index
                                            ? Colors.blue
                                            : Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                          color: provider
                                                      .selectedDeadlineFilterName ==
                                                  index
                                              ? Colors.black.withOpacity(0.5)
                                              : Colors.grey.withOpacity(
                                                  0.2), // Shadow color
                                          blurRadius:
                                              10, // Spread of the shadow
                                          offset: const Offset(
                                              0, 3) // Offset of the shadow
                                          )
                                    ],
                                    border: Border.all(
                                        color:
                                            provider.selectedDeadlineFilterName ==
                                                    index
                                                ? Colors.white
                                                : Colors.grey,
                                        width: 0.2)),
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                    provider.deadlineFilter[index],
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                            color:
                                                provider.selectedDeadlineFilterName ==
                                                        index
                                                    ? Colors.white
                                                    : Colors.grey),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                ),
              ),
              const Divider(),
              Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: StreamBuilder<List<JobModel>>(
                      stream: provider.getJobs(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          // Use the data from the stream
                          List<JobModel> jobModels = snapshot.data!;

                          // Filter jobs based on selected filter name
                          List<JobModel> filteredJobs = [];

                          if (provider.selectedDeadlineFilterName == 0) {
                            // Show jobs with today's deadline or earlier
                            filteredJobs = jobModels.where((job) {
                              Duration difference = job.deadline
                                  .toDate()
                                  .difference(DateTime.now());
                              return difference.inDays == 0;
                            }).toList();
                          } else if (provider.selectedDeadlineFilterName == 1) {
                            // Show jobs with tomorrow's deadline or earlier
                            filteredJobs = jobModels.where((job) {
                              Duration difference = job.deadline
                                  .toDate()
                                  .difference(DateTime.now());
                              return difference.inDays >= -1;
                            }).toList();
                          } else if (provider.selectedDeadlineFilterName == 2) {
                            // Show jobs with deadline within the next 3 days or earlier
                            filteredJobs = jobModels.where((job) {
                              Duration difference = job.deadline
                                  .toDate()
                                  .difference(DateTime.now());
                              return difference.inDays >= -3;
                            }).toList();
                          } else if (provider.selectedDeadlineFilterName == 3) {
                            // Show jobs with deadline within the next 10 days or earlier
                            filteredJobs = jobModels.where((job) {
                              Duration difference = job.deadline
                                  .toDate()
                                  .difference(DateTime.now());
                              return difference.inDays >= -5;
                            }).toList();
                          }

                          return ListView.separated(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: filteredJobs.length,
                              separatorBuilder: (ctx, idx) {
                                return const SizedBox(height: 10);
                              },
                              itemBuilder: (cont, index) => jobCard(
                                  context: context,
                                  data: filteredJobs[index],
                                  provider: provider,
                                  index: index,
                                  auth: auth));
                        }
                      }))
            ],
          ),
        ),
      );
    });
  }
}
