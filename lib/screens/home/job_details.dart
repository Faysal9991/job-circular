import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:job_circuler/component/custom_imageview.dart';
import 'package:job_circuler/model/job_model.dart';
import 'package:job_circuler/provider/dashboard_provider.dart';
import 'package:job_circuler/screens/home/home_screen.dart';
import 'package:job_circuler/screens/home/webview_page.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';

class JobDetails extends StatefulWidget {
  final JobModel model;
  const JobDetails({super.key, required this.model});
  @override
  State<JobDetails> createState() => _JobDetailsState();
}

class _JobDetailsState extends State<JobDetails> {
  @override
  Widget build(BuildContext context) {
    double hight = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Consumer<DashBoardProvider>(builder: (context, provider, child) {
      return Scaffold(
          backgroundColor: Colors.white.withOpacity(0.9),
          body: SingleChildScrollView(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: hight * 0.04, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(
                                    0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: SvgPicture.asset("assets/svg/back.svg"),
                          ),
                        ),
                      ),
                    ),
                    Text(
                      "Job Details",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(
                      height: 50,
                      width: 50,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: hight * 0.03,
              ),
              Center(
                child: Container(
                  height: hight * 0.15,
                  width: width * 0.3,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  child: imageView(widget.model.companyImage),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                child: Text(
                  widget.model.name,
                  style: Theme.of(context).textTheme.displayLarge,
                ),
              ),
              const SizedBox(
                height: 2,
              ),
              Center(
                child: Text(
                  "${widget.model.salary}",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    roundContainer(context, "Full time",
                        widget.model.subtype == "Full time" ? true : false),
                    roundContainer(context, "part Time",
                        widget.model.subtype == "part Time" ? true : false),
                    roundContainer(context, "any where",
                        widget.model.subtype == "any where" ? true : false)
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Text(
                  "About the job:",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: SizedBox(
                  width: width * 1,
                  child: Text(
                    "${widget.model.description}",
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Text(
                  "Qualification:",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              widget.model.jobDetails == ""
                  ? const SizedBox.shrink()
                  : Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: SizedBox(
                        width: width * 1,
                        child: Text(
                          "${widget.model.jobDetails}",
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      )),
              //** ---------------------------image */
              const SizedBox(
                height: 10,
              ),
              ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.model.list.length,
                  itemBuilder: (context, index) {
                    return Container(
                        color: Colors.white,
                        height: 200,
                        child: Center(
                            child: PhotoView(
                                imageProvider:
                                    NetworkImage(widget.model.list[index]))));
                  })
            ],
          )),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
            child: Row(children: [
              Expanded(
                flex: 2,
                child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.black.withOpacity(0.2),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SvgPicture.asset(
                        "assets/svg/bookmark.svg",
                        color: Colors.black,
                      ),
                    )),
              ),
              const Expanded(child: SizedBox()),
              Expanded(
                flex: 9,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      backgroundColor: Colors.blue,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WebPage(
                                    url: widget.model.link,
                                  )));
                    },
                    child: Text(
                      "Apply Now",
                      style: Theme.of(context).textTheme.labelLarge,
                    )),
              )
            ]),
          ));
    });
  }
}

Widget roundContainer(BuildContext context, String text, bool isSelected) {
  return Container(
    decoration: BoxDecoration(
        color: isSelected ? Colors.blue : Colors.white,
        border: Border.all(
          color: isSelected ? Colors.blueGrey : Colors.black12,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
        borderRadius: BorderRadius.circular(7)),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold),
      ),
    ),
  );
}
