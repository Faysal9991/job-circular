import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_circuler/component/custom_imageview.dart';
import 'package:job_circuler/model/job_model.dart';
import 'package:job_circuler/provider/dashboard_provider.dart';
import 'package:job_circuler/screens/home/job_details.dart';
import 'package:provider/provider.dart';

class BookMarkPage extends StatelessWidget {
  const BookMarkPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text("Find your Bookmark",style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white,fontWeight: FontWeight.bold),),
      ),
          body: SingleChildScrollView(
        child: Consumer<DashBoardProvider>(
          builder: (context, pro,child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
             
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child:  StreamBuilder<List<JobModel>>(
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
                          return data.bookMark?
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context, MaterialPageRoute(builder: (context) =>  JobDetails(index:index)));
                            },
                            child: 
                            Container(
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
                                                borderRadius: BorderRadius.circular(5)),
                                                child:CustomImageView(imagePath: data.companyImage,),
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
                                                  data.name,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge!
                                                      .copyWith(fontSize: 18),
                                                ),
                                                Text(
                                                 data.jobDetails ,
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
                                              onTap: (){
                                              pro.updateBookmark(data.name, data.description, data.id, data.type, data.subtype, data.salary, data.jobDetails, data.companyImage, data.list, data.link,data.bookMark);
                                            },
                                            child: SvgPicture.asset(
                                              "assets/svg/bookmark.svg",
                                              height: 20,
                                              width: 20,
                                              color: data.bookMark?Colors.blue:Colors.black,
                                            ),
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
                                                child: Text(data.salary,
                                                    style: GoogleFonts.lato(
                                                        color: Colors.black, fontSize: 10)),
                                              ),
                                            ),
                                            
                                      
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                          ):pro.type[pro.selectedIndex]==data.type? InkWell(
                            onTap: () {
                              Navigator.push(
                                  context, MaterialPageRoute(builder: (context) =>  JobDetails(index:index)));
                            },
                            child: 
                            Container(
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
                                                borderRadius: BorderRadius.circular(5)),
                                                child:CustomImageView(imagePath: data.companyImage,),
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
                                                  data.name,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge!
                                                      .copyWith(fontSize: 18),
                                                ),
                                                Text(
                                                 data.jobDetails ,
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
                                              onTap: (){
                                              pro.updateBookmark(data.name, data.description, data.id, data.type, data.subtype, data.salary, data.jobDetails, data.companyImage, data.list, data.link,data.bookMark);
                                            },
                                            child: SvgPicture.asset(
                                              "assets/svg/bookmark.svg",
                                              height: 20,
                                              width: 20,
                                              color: data.bookMark?Colors.blue:Colors.black,
                                            ),
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
                                                child: Text(data.salary,
                                                    style: GoogleFonts.lato(
                                                        color: Colors.black, fontSize: 10)),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                          ):const SizedBox.shrink();
                        },
                      );
        }
      },
    )
                  
                  
                  
                  
                  
                 
                )
              ],
            );
          }
        ),
      ),
  
    );
  }
}