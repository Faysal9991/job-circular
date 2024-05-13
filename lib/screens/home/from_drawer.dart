import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
    return Consumer<DashBoardProvider>(builder: (context, pro, child) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                  pro.filerValue("All");
                },
              );
            },
          ),
          centerTitle: true,
          title: Text(
            widget.categoryName,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          actions: [
            PopupMenuButton(
                itemBuilder: (ctx) => [
                      _buildPopupMenuItem(
                          pro.filter[0],
                          pro.lastThreeDays == false &&
                                  pro.lastTenDays == false &&
                                  pro.lastSevenDays == false
                              ? true
                              : false,
                          context),
                      _buildPopupMenuItem(pro.filter[1],
                          pro.lastThreeDays ? true : false, context),
                      _buildPopupMenuItem(pro.filter[2],
                          pro.lastSevenDays ? true : false, context),
                      _buildPopupMenuItem(pro.filter[3],
                          pro.lastTenDays ? true : false, context),
                      _buildPopupMenuItem("by deadline", false, context),
                    ],
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset(
                    "assets/svg/filter.svg",
                    color: Colors.black,
                  ),
                ))
          ],
        ),
        body: Consumer2<DashBoardProvider, AuthProvider>(
            builder: (context, pro, auth, child) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: StreamBuilder<List<JobModel>>(
                      stream: pro.getJobs(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          // Use the data from the stream
                          return StreamBuilder<List<String>>(
                              stream: pro.getCategoryListStream(),
                              builder: (context, calegoryList) {
                                if (calegoryList.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                } else if (calegoryList.hasError) {
                                  return Text('Error: ${calegoryList.error}');
                                } else {
                                  // Use the data from the stream
                                  List<JobModel> jobModels = snapshot.data!;
                                  jobModels
                                      .sort((a, b) => b.date.compareTo(a.date));
                                  List<JobModel> threedaysJobList =
                                      jobModels.where((job) {
                                    Duration difference = DateTime.now()
                                        .difference(job.date.toDate());

                                    return difference.inDays <= 3;
                                  }).toList();
                                  List<JobModel> tenfilteredJobs =
                                      jobModels.where((job) {
                                    Duration difference = DateTime.now()
                                        .difference(job.date.toDate());

                                    return difference.inDays <= 7;
                                  }).toList();
                                  List<JobModel> twofilteredJobs =
                                      jobModels.where((job) {
                                    Duration difference = DateTime.now()
                                        .difference(job.date.toDate());
                                    return difference.inDays <= 10;
                                  }).toList();
                                  return ListView.separated(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: pro.lastThreeDays
                                        ? threedaysJobList.length
                                        : pro.lastTenDays
                                            ? tenfilteredJobs.length
                                            : jobModels.length,
                                    separatorBuilder: (ctx, idx) {
                                      return const SizedBox(
                                        height: 10,
                                      );
                                    },
                                    itemBuilder: (cont, index) {
                                      var data = jobModels[index];
                                      return pro.lastThreeDays
                                          ? jobCard(
                                              context: context,
                                              data: threedaysJobList[index],
                                              provider: pro,
                                              index: index,
                                              auth: auth)
                                          : pro.lastTenDays
                                              ? jobCard(
                                                  context: context,
                                                  data: tenfilteredJobs[index],
                                                  provider: pro,
                                                  index: index,
                                                  auth: auth)
                                              : pro.lastSevenDays
                                                  ? jobCard(
                                                      context: context,
                                                      data: twofilteredJobs[
                                                          index],
                                                      provider: pro,
                                                      index: index,
                                                      auth: auth)
                                                  : pro.selectedIndex == 0
                                                      ? jobCard(
                                                          context: context,
                                                          data: data,
                                                          provider: pro,
                                                          index: index,
                                                          auth: auth)
                                                      : calegoryList.data![pro
                                                                  .selectedIndex] ==
                                                              snapshot
                                                                  .data![index]
                                                                  .subtype
                                                          ? jobCard(
                                                              context: context,
                                                              data: data,
                                                              provider: pro,
                                                              index: index,
                                                              auth: auth)
                                                          : const SizedBox
                                                              .shrink();
                                    },
                                  );
                                }
                              });
                        }
                      },
                    ))
              ],
            ),
          );
        }),
      );
    });
  }
}

PopupMenuItem _buildPopupMenuItem(
  String title,
  bool isSelected,
  BuildContext context,
) {
  return PopupMenuItem(
    onTap: () {
      // if (title == "by deadline") {
      //   Navigator.push(context,
      //       MaterialPageRoute(builder: (context) => const DeadlineScreen()));
      // }
      Provider.of<DashBoardProvider>(context, listen: false).filerValue(title);
    },
    child: Row(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: isSelected ? Colors.blue : Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );
}
