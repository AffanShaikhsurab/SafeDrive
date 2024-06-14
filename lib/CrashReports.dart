import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './global.dart';
import 'NavBar.dart';

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
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              colors: [
                backgroundPrimary,
                Colors.blue.shade900,
                Colors.blue.shade800,
              ],
            ),
          ),
        ),
        Scaffold(
          bottomNavigationBar: const NavBar(
            initialIndex: 0,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
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
                  const SizedBox(height: 20),
                  const Text(
                    'Help\nCenter',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontFamily: 'Nisebuschgardens',
                    ),
                  ),
                  const SizedBox(height: 22),
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
                                        const SizedBox(height: 80),
                                        Text(
                                          userData['Full Name'] ?? 'N/A',
                                          style: const TextStyle(
                                            color: contrastAccentTwo,
                                            fontSize: 36,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        _buildUserInfoRow('Date of Birth: ', userData['Date of Birth'] ?? 'N/A'),
                                        _buildUserInfoRow('Phone Number: ', userData['Phone Number'] ?? 'N/A'),
                                        _buildUserInfoRow('DL: ', userData['Driver License'] ?? 'N/A'),
                                        _buildUserInfoRow('Insurance Company: ', userData['Insurance Company'] ?? 'N/A'),
                                        _buildUserInfoRow('Policy Holder: ', userData['Policy Holder'] ?? 'N/A'),
                                        _buildUserInfoRow('Policy Number: ', userData['Policy Number'] ?? 'N/A'),
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
                  const SizedBox(height: 30),
                  Container(
                    height: height * 0.5,
                    width: width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: bgWhite,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          const Text(
                            'My Accidents',
                            style: TextStyle(
                              color: backgroundPrimary,
                              fontSize: 27,
                            ),
                          ),
                          const Divider(thickness: 2.5),
                          const SizedBox(height: 10),
                          Container(
                            height: height * 0.15,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            height: height * 0.15,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserInfoRow(String label, String value) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: backgroundPrimary,
              fontSize: 18,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: backgroundPrimary,
              fontSize: 18,
            ),
          ),
        ),
      ],
    );
  }
}
