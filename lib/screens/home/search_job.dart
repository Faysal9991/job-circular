import 'package:flutter/material.dart';
import 'package:job_circuler/component/custom_textfield.dart';
import 'package:job_circuler/model/job_model.dart';
import 'package:job_circuler/provider/auth_provider.dart';
import 'package:job_circuler/provider/dashboard_provider.dart';
import 'package:job_circuler/screens/home/home_screen.dart';
import 'package:provider/provider.dart';

class SearchJob extends StatefulWidget {
  const SearchJob({super.key});

  @override
  State<SearchJob> createState() => _SearchJobState();
}

class _SearchJobState extends State<SearchJob> {
  TextEditingController controller = TextEditingController();
  @override
  void initState() {
    var provider = Provider.of<DashBoardProvider>(context, listen: false);
    controller.addListener(() {
      provider.addtoSearch(controller.text);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Consumer2<DashBoardProvider, AuthProvider>(
            builder: (context, provider, auth, child) {
          return SingleChildScrollView(
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
                          "Lets find your preferable jobs",
                          style: Theme.of(context).textTheme.bodyLarge,
                        )),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomTextField(
                  controller: controller,
                  fillColor: const Color(0xffF3F4F8),
                  hintText: "Search for job",
                  //  textColor: auth.isdark ? Colors.white : Colors.black,
                  borderRadius: 10,
                ),
                const SizedBox(
                  height: 20,
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

                            return provider.search == ""
                                ? const SizedBox.shrink()
                                : ListView.separated(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemCount: jobModels.length,
                                    separatorBuilder: (ctx, idx) {
                                      return const SizedBox(
                                        height: 10,
                                      );
                                    },
                                    itemBuilder: (cont, index) =>
                                        jobModels[index]
                                                .name
                                                .contains(provider.search)
                                            ? jobCard(
                                                context: context,
                                                data: jobModels[index],
                                                provider: provider,
                                                index: index,
                                                auth: auth)
                                            : jobModels[index]
                                                    .description
                                                    .contains(provider.search)
                                                ? jobCard(
                                                    context: context,
                                                    data: jobModels[index],
                                                    provider: provider,
                                                    index: index,
                                                    auth: auth)
                                                : jobModels[index]
                                                        .date
                                                        .toString()
                                                        .contains(
                                                            provider.search)
                                                    ? jobCard(
                                                        context: context,
                                                        data: jobModels[index],
                                                        provider: provider,
                                                        index: index,
                                                        auth: auth)
                                                    : const SizedBox.shrink());
                          }
                        }))
              ],
            ),
          );
        }),
      ),
    );
  }
}
