import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:job_circuler/component/custom_textfield.dart';
import 'package:job_circuler/screens/home/job_details.dart';
import 'package:line_icons/line_icons.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFCFCFE),
      extendBody: true,
      body: SingleChildScrollView(
        child: Column(
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
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Text(
                              "FIND YOURE  DREAM JOB HERE",
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineLarge!
                                  .copyWith(color: Colors.black),
                            )),
                        const Spacer(),
                        // SvgPicture.asset(
                        //   "assets/svg/search.svg",
                        //   height: 25,
                        //   width: 25,
                        // ),

                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              color: Colors.white, borderRadius: BorderRadius.circular(5)),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: SvgPicture.asset(
                              "assets/svg/notification.svg",
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const Spacer(),
                  const Padding(
                    padding: EdgeInsets.only(left: 10, right: 10, bottom: 15),
                    child: CustomTextField(
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
            Container(
              height: 35,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ListView.separated(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: 7,
                    separatorBuilder: (ctx, idx) {
                      return const SizedBox(
                        width: 10,
                      );
                    },
                    itemBuilder: (context, index) {
                      return Container(
                        height: 100,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: const Color(0xffFAE3D8)),
                        child: const Padding(
                          padding: EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                          child: Center(child: Text("Govet Job")),
                        ),
                      );
                    }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: 7,
                separatorBuilder: (ctx, idx) {
                  return const SizedBox(
                    height: 10,
                  );
                },
                itemBuilder: (cont, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) => const JobDetails()));
                    },
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: index.isOdd ? const Color(0xffE5FEFE) : const Color(0xffF2F1FF)),
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
                                        color: Colors.amber,
                                        borderRadius: BorderRadius.circular(5)),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.64,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Senior UI/UX Developer",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .copyWith(fontSize: 18),
                                        ),
                                        Text(
                                          "stack technologies, salesforce  inc, mission st, USA",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Spacer(),
                                  SvgPicture.asset(
                                    "assets/svg/bookmark.svg",
                                    height: 20,
                                    width: 20,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 40, right: 10),
                                child: Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.green.withOpacity(0.4),
                                          borderRadius: BorderRadius.circular(8)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text("10k BDT - 20k BDT",
                                            style: GoogleFonts.lato(
                                                color: Colors.black, fontSize: 10)),
                                      ),
                                    ),
                                    const Spacer(),
                                    Text("3 hours ago",
                                        style: GoogleFonts.lato(
                                            color: const Color(0xff7C4EF6), fontSize: 10)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )),
                  );
                },
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: GNav(
          backgroundColor: Colors.white,
          // tab button hover color
          haptic: true, // haptic feedback
          tabBorderRadius: 10, // tab button border

          // curve: Curves.easeOutExpo, // tab animation curves
          duration: const Duration(milliseconds: 900), // tab animation duration
          gap: 8, // the tab button gap between icon and text
          color: Colors.grey[800], // unselected icon color
          activeColor: Colors.blue, // selected icon and text color
          iconSize: 24, // tab button icon size
          tabBackgroundColor: Colors.blue.withOpacity(0.1), // selected tab background color
          padding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 15), // navigation bar padding
          tabs: const [
            GButton(
              icon: LineIcons.home,
              text: 'Home',
            ),
            GButton(
              icon: LineIcons.bookmark,
              text: 'Likes',
            ),
            GButton(
              icon: LineIcons.user,
              text: 'Profile',
            )
          ]),
    );
  }
}
