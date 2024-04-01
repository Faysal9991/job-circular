import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:job_circuler/model/job_model.dart';
import 'package:job_circuler/model/menu.dart';
import 'package:job_circuler/model/notification_model.dart';
import 'package:job_circuler/provider/auth_provider.dart';
import 'package:job_circuler/provider/dashboard_provider.dart';
import 'package:job_circuler/screens/admin/provider/admin_provider.dart';
import 'package:badges/badges.dart' as badges;
import 'package:job_circuler/screens/home/deadlineFilter.dart';
import 'package:job_circuler/screens/home/job_details.dart';
import 'package:job_circuler/screens/home/notification/notification.dart';
import 'package:job_circuler/screens/home/search_job.dart';
import 'package:job_circuler/screens/menu_details.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController controller = TextEditingController();
  @override
  void initState() {
    var provider = Provider.of<DashBoardProvider>(context, listen: false);
    Provider.of<DashBoardProvider>(context, listen: false).getAllFood();
    Provider.of<AdminProvider>(context, listen: false).init();
    controller.addListener(() {
      provider.addtoSearch(controller.text);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<DashBoardProvider, AuthProvider>(
        builder: (context, pro, auth, child) {
      return Scaffold(
        extendBody: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white.withOpacity(0.3),
          actions: [
            const Spacer(),
            Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SearchJob()));
                  },
                  child: const Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                PopupMenuButton(
                    itemBuilder: (ctx) => [
                          _buildPopupMenuItem(
                              pro.filter[0],
                              pro.lastThreeDays == false &&
                                      pro.lastTenDays == false &&
                                      pro.lastTwineDays == false
                                  ? true
                                  : false,
                              context),
                          _buildPopupMenuItem(pro.filter[1],
                              pro.lastThreeDays ? true : false, context),
                          _buildPopupMenuItem(pro.filter[2],
                              pro.lastTenDays ? true : false, context),
                          _buildPopupMenuItem(pro.filter[3],
                              pro.lastTwineDays ? true : false, context),
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
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: StreamBuilder<List<NotificationModel>>(
                  stream: pro.getNotification(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      for (int i = 0; i < snapshot.data!.length; i++) {
                        if (snapshot.data![i].user!.contains(auth.userId)) {
                          pro.showNotification(true);
                        }
                      }
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const NotificationScreen()));
                        },
                        child: badges.Badge(
                          badgeContent: pro.isShowNotification
                              ? null
                              : Text(
                                  snapshot.data == null
                                      ? ""
                                      : snapshot.data!.length.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                ),
                          child: SvgPicture.asset(
                            "assets/svg/notification.svg",
                          ),
                        ),
                      );
                    }
                  }),
            ),
            const SizedBox(
              width: 10,
            )
          ],
        ),
        drawer: Drawer(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              StreamBuilder<List<Menu>>(
                  stream: pro.getMenu(),
                  builder: (context, snapshot) {
                    return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount:
                            snapshot.data == null ? 0 : snapshot.data!.length,
                        itemBuilder: (context, index) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MenuDetails(
                                              name:
                                                  snapshot.data![index].name ??
                                                      "",
                                              description: snapshot
                                                      .data![index].details ??
                                                  "",
                                            )));
                              },
                              child: SizedBox(
                                width: double.infinity,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 20),
                                      child: Text(
                                        overflow: TextOverflow.ellipsis,
                                        "${snapshot.data![index].name}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      ),
                                    ),
                                    Divider(
                                      color: auth.isdark
                                          ? Colors.white
                                          : Colors.black,
                                    )
                                  ],
                                ),
                              ),
                            );
                          }
                        });
                  })
            ],
          ),
        ),
        body: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Popular jobs",
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontSize: 20),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
                height: 170,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: StreamBuilder<List<JobModel>>(
                      stream: pro.getAllFood(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          // Use the data from the stream
                          List<JobModel> jobModels = snapshot.data!;
                          return ListView.separated(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: snapshot.data!.length,
                            separatorBuilder: ((context, index) =>
                                const SizedBox(
                                  width: 10,
                                )),
                            itemBuilder: ((context, index) {
                              return jobModels[index].popular
                                  ? SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      child: jobCard(
                                          context: context,
                                          data: jobModels[index],
                                          provider: pro,
                                          index: index),
                                    )
                                  : const SizedBox.shrink();
                            }),
                          );
                        }
                      }),
                )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Recent jobs",
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontSize: 20),
              ),
            ),
            const SizedBox(height: 10),
            StreamBuilder<List<String>>(
                stream: pro.getCategoryListStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return Container(
                      height: 60,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: ListView.separated(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data!.length,
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
                                      pro.chanageIndex(index);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: pro.selectedIndex == index
                                              ? Colors.blue
                                              : auth.isdark
                                                  ? Colors.white
                                                      .withOpacity(0.5)
                                                  : Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                                color: pro.selectedIndex ==
                                                        index
                                                    ? Colors.black
                                                        .withOpacity(0.5)
                                                    : Colors.grey.withOpacity(
                                                        0.2), // Shadow color
                                                blurRadius:
                                                    10, // Spread of the shadow
                                                offset: const Offset(0,
                                                    3) // Offset of the shadow
                                                )
                                          ],
                                          border: Border.all(
                                              color: pro.selectedIndex == index
                                                  ? Colors.white
                                                  : Colors.grey,
                                              width: 0.2)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Text(
                                          snapshot.data![index],
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                  color:
                                                      pro.selectedIndex == index
                                                          ? Colors.white
                                                          : auth.isdark
                                                              ? Colors.black
                                                              : Colors.grey),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }),
                      ),
                    );
                  }
                }),
            Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: StreamBuilder<List<JobModel>>(
                  stream: pro.getAllFood(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      // Use the data from the stream
                      return StreamBuilder<List<String>>(
                          stream: pro.getCategoryListStream(),
                          builder: (context, snap) {
                            if (snap.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (snap.hasError) {
                              return Text('Error: ${snap.error}');
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

                                return difference.inDays <= 10;
                              }).toList();
                              List<JobModel> twofilteredJobs =
                                  jobModels.where((job) {
                                Duration difference = DateTime.now()
                                    .difference(job.date.toDate());
                                return difference.inDays <= 20;
                              }).toList();
                              return ListView.separated(
                                physics: const NeverScrollableScrollPhysics(),
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
                                          index: index)
                                      : pro.lastTenDays
                                          ? jobCard(
                                              context: context,
                                              data: tenfilteredJobs[index],
                                              provider: pro,
                                              index: index)
                                          : pro.lastTwineDays
                                              ? jobCard(
                                                  context: context,
                                                  data: twofilteredJobs[index],
                                                  provider: pro,
                                                  index: index)
                                              : pro.selectedIndex == 0
                                                  ? jobCard(
                                                      context: context,
                                                      data: data,
                                                      provider: pro,
                                                      index: index)
                                                  : pro.type[pro
                                                              .selectedIndex] ==
                                                          snap.data![index]
                                                      ? jobCard(
                                                          context: context,
                                                          data: data,
                                                          provider: pro,
                                                          index: index)
                                                      : const SizedBox.shrink();
                                },
                              );
                            }
                          });
                    }
                  },
                ))
          ],
        )),
      );
    });
  }
}

Widget imageView(String url,) {
  return CachedNetworkImage(
    imageUrl: url,
    imageBuilder: (context, imageProvider) => Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        image: DecorationImage(
         
          image: imageProvider, fit: BoxFit.cover),
      ),
    ),
    placeholder: (context, url) => Image.asset(
      "assets/background/hirng.jpg",
      fit: BoxFit.cover,
    ),
    errorWidget: (context, url, error) => Image.asset(
      "assets/background/hirng.jpg",
      fit: BoxFit.cover,
    ),
  );
}

Widget jobCard(
    {required BuildContext context,
    required JobModel data,
    required DashBoardProvider provider,
    required int index}) {
  return InkWell(
    onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => JobDetails(
                    model: data,
                  )));
    },
    child: Consumer<AuthProvider>(builder: (context, auth, child) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 150,
              decoration: BoxDecoration(
                  color: auth.isdark
                      ? Colors.white.withOpacity(0.1)
                      : Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2), // Shadow color
                      blurRadius: 10, // Spread of the shadow
                      offset: const Offset(0, 3), // Offset of the shadow
                    ),
                  ],
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 15, right: 15, top: 10, bottom: 20),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(7),
                                boxShadow: [
                                  BoxShadow(
                                      color: auth.isdark
                                          ? Colors.white.withOpacity(0.2)
                                          : Colors.grey
                                              .withOpacity(0.2), // Shadow color
                                      blurRadius: 10, // Spread of the shadow
                                      offset: const Offset(
                                          0, 3) // Offset of the shadow
                                      )
                                ],
                                border:
                                    Border.all(color: Colors.blue, width: 0.2)),
                            child: imageView(data.companyImage),
                          ),
                          const SizedBox(width: 8),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(data.name,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style:
                                      Theme.of(context).textTheme.bodyMedium),
                              Text(data.type,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(color: Colors.grey)),
                            ],
                          ),
                          const Spacer(),
                          InkWell(
                            onTap: () {
                              provider.addToBookMark();
                            },
                            //   provider.updateBookmark(
                            //       data.name,
                            //       data.description,
                            //       data.id,
                            //       data.type,
                            //       data.subtype,
                            //       data.salary,
                            //       data.jobDetails,
                            //       data.companyImage,
                            //       data.list,
                            //       data.link,
                            //       data.bookMark);
                            // },
                            child: SizedBox(
                              height: 40,
                              width: 40,
                              child: Icon(
                                data.bookMark
                                    ? Icons.bookmark_added
                                    : Icons.bookmark_border,
                                color: data.bookMark
                                    ? Colors.blue
                                    : auth.isdark
                                        ? Colors.white
                                        : Colors.black,
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          data.description,
                          style: Theme.of(context).textTheme.bodySmall),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(7),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey
                                          .withOpacity(0.2), // Shadow color
                                      blurRadius: 10, // Spread of the shadow
                                      offset: const Offset(
                                          0, 3) // Offset of the shadow
                                      )
                                ],
                                border:
                                    Border.all(color: Colors.grey, width: 0.2)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(data.salary,
                                  style: Theme.of(context).textTheme.bodySmall),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(7),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey
                                          .withOpacity(0.2), // Shadow color
                                      blurRadius: 10, // Spread of the shadow
                                      offset: const Offset(
                                          0, 3) // Offset of the shadow
                                      )
                                ],
                                border:
                                    Border.all(color: Colors.grey, width: 0.2)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(data.subtype,
                                  style: Theme.of(context).textTheme.bodySmall),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(7),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey
                                          .withOpacity(0.2), // Shadow color
                                      blurRadius: 10, // Spread of the shadow
                                      offset: const Offset(
                                          0, 3) // Offset of the shadow
                                      )
                                ],
                                border:
                                    Border.all(color: Colors.grey, width: 0.2)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Apply",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(color: Colors.white)),
                            ),
                          ),
                        ],
                      )
                    ]),
              ),
            ),
          ),
        ],
      );
    }),
  );
}

Widget myAppBarIcon() {
  return SizedBox(
    width: 30,
    height: 30,
    child: Stack(
      children: [
        const Icon(
          Icons.notifications,
          color: Colors.black,
          size: 30,
        ),
        Container(
          width: 30,
          height: 30,
          alignment: Alignment.topRight,
          margin: const EdgeInsets.only(top: 5),
          child: Container(
            width: 15,
            height: 15,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xffc32c37),
                border: Border.all(color: Colors.white, width: 1)),
            child: const Padding(
              padding: EdgeInsets.all(0.0),
              child: Center(
                child: Text(
                  "10",
                  style: TextStyle(fontSize: 10),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

//  InkWell(
//                                       onTap: () {
//                                         Navigator.push(
//                                             context,
//                                             MaterialPageRoute(
//                                                 builder: (context) => JobDetails(index: index)));
//                                       },
//                                       child: Container(
//                                           decoration: BoxDecoration(
//                                               borderRadius: BorderRadius.circular(20),
//                                               color: index.isOdd
//                                                   ? const Color(0xffE5FEFE)
//                                                   : const Color(0xffF2F1FF)),
//                                           child: Padding(
//                                             padding: const EdgeInsets.all(10),
//                                             child: Column(
//                                               children: [
//                                                 Row(
//                                                   mainAxisAlignment: MainAxisAlignment.start,
//                                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                                   children: [
//                                                     Container(
//                                                       height: 40,
//                                                       width: 40,
//                                                       decoration: BoxDecoration(
//                                                           borderRadius: BorderRadius.circular(5)),
//                                                       child: CustomImageView(
//                                                         imagePath: data.companyImage,
//                                                       ),
//                                                     ),
//                                                     const SizedBox(
//                                                       width: 5,
//                                                     ),
//                                                     SizedBox(
//                                                       width: MediaQuery.of(context).size.width *
//                                                           0.64,
//                                                       child: Column(
//                                                         mainAxisAlignment:
//                                                             MainAxisAlignment.start,
//                                                         crossAxisAlignment:
//                                                             CrossAxisAlignment.start,
//                                                         children: [
//                                                           Text(
//                                                             data.name,
//                                                             style: Theme.of(context)
//                                                                 .textTheme
//                                                                 .bodyLarge!
//                                                                 .copyWith(fontSize: 18),
//                                                           ),
//                                                           Text(
//                                                             data.jobDetails,
//                                                             style: Theme.of(context)
//                                                                 .textTheme
//                                                                 .bodySmall!
//                                                                 .copyWith(fontSize: 14),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     ),
//                                                     const Spacer(),
//                                                     InkWell(
//                                                       onTap: () {
//                                                         pro.updateBookmark(
//                                                             data.name,
//                                                             data.description,
//                                                             data.id,
//                                                             data.type,
//                                                             data.subtype,
//                                                             data.salary,
//                                                             data.jobDetails,
//                                                             data.companyImage,
//                                                             data.list,
//                                                             data.link,
//                                                             data.bookMark);
//                                                       },
//                                                       child: SvgPicture.asset(
//                                                         "assets/svg/bookmark.svg",
//                                                         height: 20,
//                                                         width: 20,
//                                                         color: data.bookMark
//                                                             ? Colors.blue
//                                                             : Colors.black,
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                                 const SizedBox(
//                                                   height: 20,
//                                                 ),
//                                                 Padding(
//                                                   padding:
//                                                       const EdgeInsets.only(left: 40, right: 10),
//                                                   child: Row(
//                                                     children: [
//                                                       Container(
//                                                         decoration: BoxDecoration(
//                                                             color: Colors.green.withOpacity(0.4),
//                                                             borderRadius:
//                                                                 BorderRadius.circular(8)),
//                                                         child: Padding(
//                                                           padding: const EdgeInsets.all(5.0),
//                                                           child: Text(data.salary,
//                                                               style: GoogleFonts.lato(
//                                                                   color: Colors.black,
//                                                                   fontSize: 10)),
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           )),
//                                     )

PopupMenuItem _buildPopupMenuItem(
  String title,
  bool isSelected,
  BuildContext context,
) {
  return PopupMenuItem(
    onTap: () {
      if (title == "by deadline") {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const DeadlineScreen()));
      }
      Provider.of<DashBoardProvider>(context, listen: false).filerValue(title);
    },
    child: Row(
      children: [
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .bodySmall!
              .copyWith(color: isSelected ? Colors.green : null),
        ),
      ],
    ),
  );
}
