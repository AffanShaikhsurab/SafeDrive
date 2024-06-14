import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sdfinal/AccidentAssistance/AccidentChecklistOverview.dart';
import 'package:sdfinal/global.dart';
import 'package:sdfinal/NavBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CrashReports extends StatelessWidget {
  const CrashReports({super.key});

  Future<Map<String, dynamic>?> _fetchUserData() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    String? uid = auth.currentUser?.uid;

    if (uid != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('Users').doc(uid).get();
      if (userDoc.exists) {
        return userDoc.data() as Map<String, dynamic>;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/SDBackground.png'),
                fit: BoxFit.cover,
              )
          ),
        ),
        Scaffold(
          bottomNavigationBar: const NavBar(initialIndex: 2,),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const AccidentChecklist()));
            },
            backgroundColor: contrastAccentOne,
            splashColor: contrastAccentTwo,
            child: const Icon(Icons.warning),
          ),
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Driver\nAssistance',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          color: bgWhite,
                        )
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: height * 0.5,
                    child: FutureBuilder<Map<String, dynamic>?>(
                      future: _fetchUserData(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return const Center(child: Text('Error fetching data'));
                        }
                        if (!snapshot.hasData || snapshot.data == null) {
                          return const Center(child: Text('No data available'));
                        }

                        var userData = snapshot.data!;

                        return LayoutBuilder(
                          builder: (context, constraints) {
                            double innerHeight = constraints.maxHeight;
                            double innerWidth = constraints.maxWidth;

                            return Stack(
                              fit: StackFit.expand,
                              children: [
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    height: innerHeight * 0.75,
                                    width: innerWidth,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: backgroundAccentTwo,
                                    ),
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 60,
                                        ),
                                        Text(
                                          userData['Full Name'] ?? 'N/A',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.poppins(
                                              textStyle: const TextStyle(
                                                fontSize: 36,
                                                fontWeight: FontWeight.bold,
                                                color: contrastAccentTwo,
                                              )
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        _buildUserInfoRow("Date of Birth: ", userData['Date of Birth'] ?? 'N/A'),
                                        _buildUserInfoRow("Phone Number: ", userData['Phone Number'] ?? 'N/A'),
                                        _buildUserInfoRow("Driver's License: ", userData['Driver License'] ?? 'N/A'),
                                        _buildUserInfoRow("Insurance Co: ", userData['Insurance Company'] ?? 'N/A'),
                                        _buildUserInfoRow("Policy Holder: ", userData['Policy Holder'] ?? 'N/A'),
                                        _buildUserInfoRow("Policy Number: ", userData['Policy Number'] ?? 'N/A'),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  left: 0,
                                  right: 0,
                                  child: Center(
                                    child: Image.asset(
                                      userProfile,
                                      width: innerWidth * 0.45,
                                      fit: BoxFit.fitWidth,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    height: height * 0.90,
                    width: width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: bgWhite,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            'My Accidents',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: backgroundPrimary,
                                )
                            ),
                          ),
                          const Divider(
                            thickness: 2.5,
                            color: backgroundPrimary,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          _buildAccidentCard(height, width, "Driver Name #1"),
                          const SizedBox(
                            height: 30,
                          ),
                          _buildAccidentCard(height, width, "Driver Name #2"),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildUserInfoRow(String label, String value) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
              label,
              textAlign: TextAlign.right,
              style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: backgroundPrimary,
                  )
              )
          ),
        ),
        Expanded(
          child: Text(
              value,
              textAlign: TextAlign.left,
              style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    fontSize: 20,
                    color: backgroundPrimary,
                  )
              )
          ),
        ),
      ],
    );
  }

  Widget _buildAccidentCard(double height, double width, String driverName) {
    return Container(
      height: height * 0.35,
      width: width * 0.80,
      decoration: BoxDecoration(
        color: backgroundAccentOne,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            driverName,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: contrastAccentOne,
                )
            ),
          ),
          Text(
            'Phone Number: ',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  fontSize: 18,
                  color: backgroundPrimary,
                )
            ),
          ),
          Text(
            'Vehicle Make/Model: ',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  fontSize: 18,
                  color: backgroundPrimary,
                )
            ),
          ),
          Text(
            'Color: ',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  fontSize: 18,
                  color: backgroundPrimary,
                )
            ),
          ),
          Text(
            'License Plate #: ',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  fontSize: 18,
                  color: backgroundPrimary,
                )
            ),
          ),
          Text(
            'Location: ',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  fontSize: 18,
                  color: backgroundPrimary,
                )
            ),
          ),
          Text(
            'Vehicle Make/Model: ',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  fontSize: 18,
                  color: backgroundPrimary,
                )
            ),
          ),
          Text(
            'Insurance Co.: ',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  fontSize: 18,
                  color: backgroundPrimary,
                )
            ),
          ),
          Text(
            'Policy Number: ',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  fontSize: 18,
                  color: backgroundPrimary,
                )
            ),
          ),
        ],
      ),
    );
  }
}
