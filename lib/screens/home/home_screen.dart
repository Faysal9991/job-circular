import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_circuler/component/custom_textfield.dart';
import 'package:job_circuler/model/job_model.dart';
import 'package:job_circuler/model/notification_model.dart';
import 'package:job_circuler/provider/auth_provider.dart';
import 'package:job_circuler/provider/dashboard_provider.dart';
import 'package:job_circuler/screens/admin/provider/admin_provider.dart';
import 'package:badges/badges.dart' as badges;
import 'package:job_circuler/screens/home/job_details.dart';
import 'package:job_circuler/screens/home/notification/notification.dart';
import 'package:provider/provider.dart';

import '../../component/custom_imageview.dart';

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
    return Scaffold(
      backgroundColor: const Color(0xffFCFCFE),
      extendBody: true,
      body: SingleChildScrollView(
        child: Consumer2<DashBoardProvider,AuthProvider>(builder: (context, pro,auth, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 220,
                decoration: const BoxDecoration(color: Color(0xffC2DFDB)
                    // image: DecorationImage(image: AssetImage("assets/background/black.jpg"), fit: BoxFit.cover)
                    ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 40, left: 10, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                              width: 250,
                              child: Text(
                                "FIND YOURE  DREAM JOB HERE",
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineLarge!
                                    .copyWith(color: Colors.black),
                              )),
                          Spacer(),
                          StreamBuilder<List<NotificationModel>>(
                              stream: pro.getNotification(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {

                                  for(int i = 0; i < snapshot.data!.length; i++) {
                                   if(snapshot.data![i].user!.contains(auth.userId)){
                                 pro.showNotification(true);
                                   }
                                  }
                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => NotificationScreen()));
                                    },
                                    child: badges.Badge(
                                      badgeContent: pro.isShowNotification?null:
                                      Text(
                                        snapshot.data == null
                                            ? ""
                                            : snapshot.data!.length.toString(),
                                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                            color: Colors.white, fontWeight: FontWeight.bold),
                                      ),
                                      child: Container(
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(5)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: SvgPicture.asset(
                                            "assets/svg/notification.svg",
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              })
                        ],
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: EdgeInsets.only(left: 10, right: 10, bottom: 15),
                      child: CustomTextField(
                        controller: controller,
                        fillColor: Color(0xffF3F4F8),
                        isIcon: true,
                        isShowPrefixIcon: true,
                        prefixIconUrl: Icons.search,
                        hintText: "search",
                        borderRadius: 10,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Text(
                      "Job Feed",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 25),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    SvgPicture.asset(
                      "assets/svg/job.svg",
                      height: 20,
                      width: 20,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              pro.search == ""
                  ? Container(
                      height: 45,
                      child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: ListView.separated(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: pro.type.length,
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
                                        height: 40,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(30),
                                            color: pro.selectedIndex == index
                                                ? const Color(0xffC2DFDB)
                                                : const Color(0xffFAE3D8)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Text("${pro.type[index]}"),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              })),
                    )
                  : SizedBox.shrink(),
              pro.search == ""
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: StreamBuilder<List<JobModel>>(
                        stream: pro.getAllFood(),
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
                                var data = jobModels[index];
                                return pro.selectedIndex == 0
                                    ? InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => JobDetails(index: index)));
                                        },
                                        child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(20),
                                                color: index.isOdd
                                                    ? const Color(0xffE5FEFE)
                                                    : const Color(0xffF2F1FF)),
                                            child: Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        height: 40,
                                                        width: 40,
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(5)),
                                                        child: CustomImageView(
                                                          imagePath: data.companyImage,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      SizedBox(
                                                        width: MediaQuery.of(context).size.width *
                                                            0.64,
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment.start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              data.name,
                                                              style: Theme.of(context)
                                                                  .textTheme
                                                                  .bodyLarge!
                                                                  .copyWith(fontSize: 18),
                                                            ),
                                                            Text(
                                                              data.jobDetails,
                                                              style: Theme.of(context)
                                                                  .textTheme
                                                                  .bodySmall!
                                                                  .copyWith(fontSize: 14),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      const Spacer(),
                                                      InkWell(
                                                        onTap: () {
                                                          pro.updateBookmark(
                                                              data.name,
                                                              data.description,
                                                              data.id,
                                                              data.type,
                                                              data.subtype,
                                                              data.salary,
                                                              data.jobDetails,
                                                              data.companyImage,
                                                              data.list,
                                                              data.link,
                                                              data.bookMark);
                                                        },
                                                        child: SvgPicture.asset(
                                                          "assets/svg/bookmark.svg",
                                                          height: 20,
                                                          width: 20,
                                                          color: data.bookMark
                                                              ? Colors.blue
                                                              : Colors.black,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(left: 40, right: 10),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          decoration: BoxDecoration(
                                                              color: Colors.green.withOpacity(0.4),
                                                              borderRadius:
                                                                  BorderRadius.circular(8)),
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(5.0),
                                                            child: Text(data.salary,
                                                                style: GoogleFonts.lato(
                                                                    color: Colors.black,
                                                                    fontSize: 10)),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )),
                                      )
                                    : pro.type[pro.selectedIndex] == data.type
                                        ? InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          JobDetails(index: index)));
                                            },
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(20),
                                                    color: index.isOdd
                                                        ? const Color(0xffE5FEFE)
                                                        : const Color(0xffF2F1FF)),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(10),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment.start,
                                                        children: [
                                                          Container(
                                                            height: 40,
                                                            width: 40,
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius.circular(5)),
                                                            child: CustomImageView(
                                                              imagePath: data.companyImage,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          SizedBox(
                                                            width:
                                                                MediaQuery.of(context).size.width *
                                                                    0.64,
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment.start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment.start,
                                                              children: [
                                                                Text(
                                                                  data.name,
                                                                  style: Theme.of(context)
                                                                      .textTheme
                                                                      .bodyLarge!
                                                                      .copyWith(fontSize: 18),
                                                                ),
                                                                Text(
                                                                  data.jobDetails,
                                                                  style: Theme.of(context)
                                                                      .textTheme
                                                                      .bodySmall!
                                                                      .copyWith(fontSize: 14),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          const Spacer(),
                                                          InkWell(
                                                            onTap: () {
                                                              pro.updateBookmark(
                                                                  data.name,
                                                                  data.description,
                                                                  data.id,
                                                                  data.type,
                                                                  data.subtype,
                                                                  data.salary,
                                                                  data.jobDetails,
                                                                  data.companyImage,
                                                                  data.list,
                                                                  data.link,
                                                                  data.bookMark);
                                                            },
                                                            child: SvgPicture.asset(
                                                              "assets/svg/bookmark.svg",
                                                              height: 20,
                                                              width: 20,
                                                              color: data.bookMark
                                                                  ? Colors.blue
                                                                  : Colors.black,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 20,
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.only(
                                                            left: 40, right: 10),
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              decoration: BoxDecoration(
                                                                  color:
                                                                      Colors.green.withOpacity(0.4),
                                                                  borderRadius:
                                                                      BorderRadius.circular(8)),
                                                              child: Padding(
                                                                padding: const EdgeInsets.all(5.0),
                                                                child: Text(data.salary,
                                                                    style: GoogleFonts.lato(
                                                                        color: Colors.black,
                                                                        fontSize: 10)),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )),
                                          )
                                        : const SizedBox.shrink();
                              },
                            );
                          }
                        },
                      ))
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: StreamBuilder<List<JobModel>>(
                        stream: pro.getAllFood(),
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
                                var data = jobModels[index];
                                return data.name.contains(pro.search)
                                    ? InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => JobDetails(index: index)));
                                        },
                                        child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(20),
                                                color: index.isOdd
                                                    ? const Color(0xffE5FEFE)
                                                    : const Color(0xffF2F1FF)),
                                            child: Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        height: 40,
                                                        width: 40,
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(5)),
                                                        child: CustomImageView(
                                                          imagePath: data.companyImage,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      SizedBox(
                                                        width: MediaQuery.of(context).size.width *
                                                            0.64,
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment.start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              data.name,
                                                              style: Theme.of(context)
                                                                  .textTheme
                                                                  .bodyLarge!
                                                                  .copyWith(fontSize: 18),
                                                            ),
                                                            Text(
                                                              data.jobDetails,
                                                              style: Theme.of(context)
                                                                  .textTheme
                                                                  .bodySmall!
                                                                  .copyWith(fontSize: 14),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      const Spacer(),
                                                      InkWell(
                                                        onTap: () {
                                                          pro.updateBookmark(
                                                              data.name,
                                                              data.description,
                                                              data.id,
                                                              data.type,
                                                              data.subtype,
                                                              data.salary,
                                                              data.jobDetails,
                                                              data.companyImage,
                                                              data.list,
                                                              data.link,
                                                              data.bookMark);
                                                        },
                                                        child: SvgPicture.asset(
                                                          "assets/svg/bookmark.svg",
                                                          height: 20,
                                                          width: 20,
                                                          color: data.bookMark
                                                              ? Colors.blue
                                                              : Colors.black,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(left: 40, right: 10),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          decoration: BoxDecoration(
                                                              color: Colors.green.withOpacity(0.4),
                                                              borderRadius:
                                                                  BorderRadius.circular(8)),
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(5.0),
                                                            child: Text(data.salary,
                                                                style: GoogleFonts.lato(
                                                                    color: Colors.black,
                                                                    fontSize: 10)),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )),
                                      )
                                    : pro.type[pro.selectedIndex] == data.type
                                        ? InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          JobDetails(index: index)));
                                            },
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(20),
                                                    color: index.isOdd
                                                        ? const Color(0xffE5FEFE)
                                                        : const Color(0xffF2F1FF)),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(10),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment.start,
                                                        children: [
                                                          Container(
                                                            height: 40,
                                                            width: 40,
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius.circular(5)),
                                                            child: CustomImageView(
                                                              imagePath: data.companyImage,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          SizedBox(
                                                            width:
                                                                MediaQuery.of(context).size.width *
                                                                    0.64,
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment.start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment.start,
                                                              children: [
                                                                Text(
                                                                  data.name,
                                                                  style: Theme.of(context)
                                                                      .textTheme
                                                                      .bodyLarge!
                                                                      .copyWith(fontSize: 18),
                                                                ),
                                                                Text(
                                                                  data.jobDetails,
                                                                  style: Theme.of(context)
                                                                      .textTheme
                                                                      .bodySmall!
                                                                      .copyWith(fontSize: 14),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          const Spacer(),
                                                          InkWell(
                                                            onTap: () {
                                                              pro.updateBookmark(
                                                                  data.name,
                                                                  data.description,
                                                                  data.id,
                                                                  data.type,
                                                                  data.subtype,
                                                                  data.salary,
                                                                  data.jobDetails,
                                                                  data.companyImage,
                                                                  data.list,
                                                                  data.link,
                                                                  data.bookMark);
                                                            },
                                                            child: SvgPicture.asset(
                                                              "assets/svg/bookmark.svg",
                                                              height: 20,
                                                              width: 20,
                                                              color: data.bookMark
                                                                  ? Colors.blue
                                                                  : Colors.black,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 20,
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.only(
                                                            left: 40, right: 10),
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              decoration: BoxDecoration(
                                                                  color:
                                                                      Colors.green.withOpacity(0.4),
                                                                  borderRadius:
                                                                      BorderRadius.circular(8)),
                                                              child: Padding(
                                                                padding: const EdgeInsets.all(5.0),
                                                                child: Text(data.salary,
                                                                    style: GoogleFonts.lato(
                                                                        color: Colors.black,
                                                                        fontSize: 10)),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )),
                                          )
                                        : const SizedBox.shrink();
                              },
                            );
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

Widget myAppBarIcon() {
  return Container(
    width: 30,
    height: 30,
    child: Stack(
      children: [
        Icon(
          Icons.notifications,
          color: Colors.black,
          size: 30,
        ),
        Container(
          width: 30,
          height: 30,
          alignment: Alignment.topRight,
          margin: EdgeInsets.only(top: 5),
          child: Container(
            width: 15,
            height: 15,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xffc32c37),
                border: Border.all(color: Colors.white, width: 1)),
            child: Padding(
              padding: const EdgeInsets.all(0.0),
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
