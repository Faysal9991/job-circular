import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:job_circuler/component/custom_textfield.dart';
import 'package:job_circuler/model/job_model.dart';
import 'package:job_circuler/screens/admin/provider/admin_provider.dart';
import 'package:job_circuler/screens/pick_image/widget/provider/pick_image_provider.dart';
import 'package:provider/provider.dart';

class AdminFirstScreen extends StatefulWidget {
  const AdminFirstScreen({super.key});

  @override
  State<AdminFirstScreen> createState() => _AdminFirstScreenState();
}

class _AdminFirstScreenState extends State<AdminFirstScreen> {
  String? selectedType;
  String? selectedSubType;
  TextEditingController jobName = TextEditingController();
  TextEditingController companyImage = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController jobDetails = TextEditingController();
  TextEditingController salary = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController notificationDescription = TextEditingController();
  TextEditingController applying = TextEditingController();
  @override
  void initState() {
    Provider.of<AdminProvider>(context, listen: false).cloudinary;
    Provider.of<AdminProvider>(context, listen: false).getAllFood();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Consumer<AdminProvider>(builder: (context, provider, child) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff1E77CF),
                  shadowColor: Colors.grey.withOpacity(0.5)),
              onPressed: () {
                provider.addNewJob(
                    jobName: jobName.text,
                    description: description.text,
                    type: selectedType ?? "",
                    jobDetails: jobDetails.text,
                    salary: salary.text,
                    subtype: selectedSubType ?? "",
                    companyImage: provider.companyPicture,
                    image: provider.imageList,
                    link: applying.text);
              },
              child: const Text(
                "Save Job",
                style: TextStyle(color: Colors.white),
              )),
        );
      }),
      appBar: AppBar(
        leading: Consumer<AdminProvider>(
        
          builder: (context, provider,child) {
            return IconButton(
                onPressed: () {
                  AwesomeDialog(
                    context: context,
                    animType: AnimType.scale,
                    dialogType: DialogType.infoReverse,
                    body: Column(children: [
                      CustomTextField(
                        controller: title,
                        hintText: "title",
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                        controller: notificationDescription,
                        hintText: "description",
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ]),
                    
                    btnOkOnPress: () {
                      if(title.text.isEmpty && notificationDescription.text.isEmpty){
                               var snackBar = SnackBar(content: Text( "sorry Fild is empty"));
                       
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }else{
                                              provider.sendNotificationLocal(title:title.text,description:notificationDescription.text  );

                      }
                    },
                  )..show();
                },
                icon: Icon(Icons.notification_add));
          }
        ),
        title: const Text("Admin panel"),
      ),
      body: Consumer2<AdminProvider, ImagePickProvider>(
          builder: (context, provider, imagePro, child) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                CustomTextField(
                  controller: jobName,
                  hintText: "jobName",
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  controller: description,
                  hintText: "description",
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  controller: jobDetails,
                  hintText: "jobDetails",
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  controller: salary,
                  hintText: "salary",
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  controller: applying,
                  hintText: "Applying Url",
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2<String>(
                      isExpanded: true,
                      hint: const Text(
                        'Select Job type',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      items: provider.type
                          .map((String item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ))
                          .toList(),
                      value: selectedType,
                      onChanged: (String? value) {
                        setState(() {
                          selectedType = value;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2<String>(
                      isExpanded: true,
                      hint: const Text(
                        'Select Job subtype',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      items: provider.subType
                          .map((String item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ))
                          .toList(),
                      value: selectedSubType,
                      onChanged: (String? value) {
                        setState(() {
                          selectedSubType = value;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                imagePro.isloading && provider.isLoading
                    ? const CircularProgressIndicator()
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff1E77CF),
                                shadowColor: Colors.grey.withOpacity(0.5)),
                            onPressed: () {
                              imagePro.pickImage().then((value) {
                                provider.uploadImages(imagePro.image!, (int value) {
                                  if (value == 200) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Successfully add')));
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(content: Text('Flailed add')));
                                  }
                                }, isSingle: false);
                              });
                            },
                            child: const Text(
                              "Single Image",
                              style: TextStyle(color: Colors.white),
                            )),
                      ),
                imagePro.isloading && provider.isLoading
                    ? const CircularProgressIndicator()
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff1E77CF),
                                shadowColor: Colors.grey.withOpacity(0.5)),
                            onPressed: () {
                              imagePro.pickImage().then((value) {
                                provider.uploadImages(imagePro.image!, (int value) {
                                  if (value == 200) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Successfully add')));
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(content: Text('Flailed add')));
                                  }
                                }, isSingle: true);
                              });
                            },
                            child: Text(
                              "pick job Image, image = ${provider.imageList.length}",
                              style: const TextStyle(color: Colors.white),
                            )),
                      ),
                const Text(
                  "Name of all job",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                const SizedBox(height: 10),
                StreamBuilder<List<JobModel>>(
                    stream: provider.getAllFood(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return Container(
                                decoration: BoxDecoration(
                                    color: Colors.blue, borderRadius: BorderRadius.circular(5)),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "${snapshot.data![index].name}",
                                          style: const TextStyle(color: Colors.white),
                                        ),
                                        ElevatedButton(
                                            onPressed: () {
                                              provider.removeJob(snapshot.data![index].id);
                                            },
                                            child: const Text("Delete"))
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            });
                      }
                    })
              ],
            ),
          ),
        );
      }),
    );
  }
}
