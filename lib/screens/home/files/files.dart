import 'package:advance_player_academy_players/screens/home/files/widgets/file_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../models/user_model.dart';
import '../../../widgets/custom_text_input.dart';

enum FilterOptions {
  All,
  WordFiles,
  ExcelFiles,
  PdfFiles,
}

class FilesScreen extends StatefulWidget {
  const FilesScreen({super.key});

  @override
  State<FilesScreen> createState() => _FilesScreenState();
}

class _FilesScreenState extends State<FilesScreen> {
  TextEditingController controller = TextEditingController();
  TextEditingController searchController = TextEditingController();

  FilterOptions selectedFilter = FilterOptions.All;

  void _handleFilterChange(FilterOptions selectedOption) {
    setState(() {
      selectedFilter = selectedOption;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: CustomTextInput(
                    controller: searchController,
                    onChanged: (v) {
                      setState(() {});
                    },
                    hintText: "Search",
                  ),
                ),
                SizedBox(width: 20),
                PopupMenuButton<FilterOptions>(
                  onSelected: _handleFilterChange,
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<FilterOptions>>[
                    const PopupMenuItem<FilterOptions>(
                      value: FilterOptions.All,
                      child: Text('All'),
                    ),
                    const PopupMenuItem<FilterOptions>(
                      value: FilterOptions.WordFiles,
                      child: Text('Word Files'),
                    ),
                    const PopupMenuItem<FilterOptions>(
                      value: FilterOptions.ExcelFiles,
                      child: Text('Excel Files'),
                    ),
                    const PopupMenuItem<FilterOptions>(
                      value: FilterOptions.PdfFiles,
                      child: Text('PDF Files'),
                    ),
                  ],
                  child: Icon(Icons.filter_alt),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .snapshots(),
              builder: (context, userSnap) {
                if (!userSnap.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                UserModel userModel = UserModel.fromDoc(userSnap.data!);
                var trainers = List.from(userModel.trainers!);
                if (trainers.isEmpty) {
                  return Center(
                    child: Text("No File Found"),
                  );
                } else {
                  return StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('files')
                        .where('trainerId', whereIn: trainers)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.data!.docs.isEmpty) {
                        return Center(
                          child: Text("No Document Founds"),
                        );
                      }
                      List<DocumentSnapshot> filteredDocuments = snapshot.data!.docs.where((data) {
                        if (searchController.text.isNotEmpty &&
                            !data['description']
                                .toString()
                                .toLowerCase()
                                .contains(searchController.text.toLowerCase())) {
                          return false;
                        }

                        switch (selectedFilter) {
                          case FilterOptions.All:
                            return true;
                          case FilterOptions.WordFiles:
                            return data['isDoc'];
                          case FilterOptions.ExcelFiles:
                            return data['isExcel'];
                          case FilterOptions.PdfFiles:
                            return data['isPdf'];
                          default:
                            return true;
                        }
                      }).toList();

                      return GridView.builder(
                        itemCount: filteredDocuments.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemBuilder: (context, index) {
                          var data = filteredDocuments[index];
                          return companyFileWidget(
                            data: data,
                            context: context,
                          );
                        },
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
    ;
  }
}
