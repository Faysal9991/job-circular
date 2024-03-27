import 'package:flutter/material.dart';
import 'package:job_circuler/model/job_model.dart';
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
    return Consumer<DashBoardProvider>(builder: (context, provider, child) {
      return Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Text(
                        "Lets Filter job",
                        style: Theme.of(context).textTheme.bodyLarge,
                      )),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                height: 60,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
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
                                    color: provider.selectedDeadlineFilterName == index
                                        ? Colors.blue
                                        : Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                          color: provider.selectedDeadlineFilterName == index
                                              ? Colors.black.withOpacity(0.5)
                                              : Colors.grey.withOpacity(0.2), // Shadow color
                                          blurRadius: 10, // Spread of the shadow
                                          offset: const Offset(0, 3) // Offset of the shadow
                                          )
                                    ],
                                    border: Border.all(
                                        color: provider.selectedDeadlineFilterName == index
                                            ? Colors.white
                                            : Colors.grey,
                                        width: 0.2)),
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                    provider.deadlineFilter[index],
                                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                        color: provider.selectedDeadlineFilterName == index
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
                      stream: provider.getAllFood(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          // Use the data from the stream
                          List<JobModel> jobModels = snapshot.data!;
                          List<JobModel> today = jobModels.where((job) {
                            Duration difference = job.deadline.toDate().difference(DateTime.now());
                            return difference.inDays <= 0;
                          }).toList();

                          List<JobModel> tomorrow = jobModels.where((job) {
                            Duration difference = job.deadline.toDate().difference(DateTime.now());
                            return difference.inDays <= 1;
                          }).toList();

                          List<JobModel> threeDays = jobModels.where((job) {
                            Duration difference = job.deadline.toDate().difference(DateTime.now());
                            return difference.inDays <= 3;
                          }).toList();

                          List<JobModel> tenDays = jobModels.where((job) {
                            Duration difference = job.deadline.toDate().difference(DateTime.now());
                            return difference.inDays <= 10;
                          }).toList();

                          return ListView.separated(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: provider.selectedDeadlineFilterName == 0
                                  ? today.length
                                  : provider.selectedDeadlineFilterName == 1
                                      ? tomorrow.length
                                      : provider.selectedDeadlineFilterName == 2
                                          ? threeDays.length
                                          : tenDays.length,
                              separatorBuilder: (ctx, idx) {
                                return const SizedBox(
                                  height: 10,
                                );
                              },
                              itemBuilder: (cont, index) => provider.selectedDeadlineFilterName == 0
                                  ? jobCard(
                                      context: context,
                                      data: today[index],
                                      provider: provider,
                                      index: index)
                                  : provider.selectedDeadlineFilterName == 1
                                      ? jobCard(
                                          context: context,
                                          data: tomorrow[index],
                                          provider: provider,
                                          index: index)
                                      : provider.selectedDeadlineFilterName == 2
                                          ? jobCard(
                                              context: context,
                                              data: threeDays[index],
                                              provider: provider,
                                              index: index)
                                          : jobCard(
                                              context: context,
                                              data: tenDays[index],
                                              provider: provider,
                                              index: index));
                        }
                      }))
            ],
          ),
        ),
      );
    });
  }
}
