import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_circuler/component/custom_imageview.dart';
import 'package:job_circuler/model/job_model.dart';
import 'package:job_circuler/provider/dashboard_provider.dart';
import 'package:job_circuler/screens/home/home_screen.dart';
import 'package:job_circuler/screens/home/job_details.dart';
import 'package:provider/provider.dart';

class BookMarkPage extends StatelessWidget {
  const BookMarkPage({super.key});

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
        child: Consumer<DashBoardProvider>(builder: (context, pro, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
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
                        List<JobModel> bookmark = jobModels.where((job) => job.bookMark).toList();
                        return ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: bookmark.length,
                            separatorBuilder: (ctx, idx) {
                              return const SizedBox(
                                height: 10,
                              );
                            },
                            itemBuilder: (cont, index) {
                              return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => JobDetails(index: index)));
                                  },
                                  child: jobCard(
                                      context: context,
                                      data: bookmark[index],
                                      provider: pro,
                                      index: index));
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
