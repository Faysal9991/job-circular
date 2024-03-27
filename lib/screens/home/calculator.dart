import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:job_circuler/provider/auth_provider.dart';
import 'package:job_circuler/provider/dashboard_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Consumer2<DashBoardProvider, AuthProvider>(
            builder: (context, provider, authPro, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Calculate your age", style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(
                height: 40,
              ),
              Text("Lets do it",
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 18)),
              SizedBox(height: 20),
                  
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.white.withOpacity(0.4)),
                    onPressed: () {
                      provider.datePicker(context);
                    },
                    child: Text(
                      provider.selectedDate == null
                          ? "date of barth"
                          : "${DateFormat('dd MMMM yyyy').format(provider.selectedDate!)}",
                      style: Theme.of(context).textTheme.displayMedium!.copyWith(),
                    )),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.white.withOpacity(0.4)),
                    onPressed: () {
                      provider.SecondDatePicker(context);
                    },
                    child: Text(
                      provider.selectedDate == null
                          ? "present date"
                          : DateFormat('dd MMMM yyyy').format(provider.secondDate),
                      style: Theme.of(context).textTheme.displayMedium!.copyWith(),
                    )),
              ),
             SizedBox(height: 20),
           
               SizedBox(height: 20),
             provider.calculateDuration().isEmpty
                  ? const SizedBox.shrink()
                  : Container(
                      width: double.infinity,
                      decoration:  BoxDecoration(color: Colors.black,borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            "${provider.calculateDuration()}",
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.amber),
                          ),
                        ),
                      ),
                    )
            ],
          );
        }),
      ),
    );
  }
}
