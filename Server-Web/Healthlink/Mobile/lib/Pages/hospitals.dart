import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
class Hospitals extends StatefulWidget {
  const Hospitals({super.key});

  @override
  State<Hospitals> createState() => _HospitalsState();
}

class _HospitalsState extends State<Hospitals> {
  String? district;
  List<dynamic> fetchedData = [];
  getHospitals() async {
    final url = Uri.parse('http://192.168.1.4:8000/api/hospitals/');
    final body = jsonEncode({"district": district});
    final headers = {'Content-Type': 'application/json'};
    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200){
      final responseData = json.decode(response.body);
      setState(() {
        fetchedData = responseData;
      });
      print(fetchedData);
    }else {
      throw Exception('Failed to load profile data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        title: const Text(
          'Hospital',
          style: TextStyle(color: Colors.blueAccent),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Column(
          children: [
            const SizedBox(
              height: 17,
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 10),
                    child: TextFormField(
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                          filled: true,
                          prefixIcon: const Icon(Icons.local_hospital_outlined),
                          prefixIconColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 7.0,
                            horizontal: 10,
                          ),
                          fillColor: Colors.grey.shade800,
                          labelText: "Enter District",
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade800),
                            borderRadius: BorderRadius.circular(
                                20.0), // Set the same border radius here
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide:
                                const BorderSide(color: Colors.blueAccent),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: const BorderSide(color: Colors.orange),
                          ),
                          labelStyle: const TextStyle(
                              color: Colors.white70,
                              fontFamily: 'Quicksand',
                              fontSize: 15,
                              fontWeight: FontWeight.bold)),
                      onChanged: (val) {
                        setState(() {
                          district = val;
                        });
                      },
                    ),
                  ),
                ),
                ElevatedButton(onPressed: (){
                  if (district == null){

                  }else{
                    getHospitals();
                  }
                },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: const CircleBorder(),
                    ),
                    child: const Icon(Icons.search , color: Colors.white,)
                )
              ],
            ),
            SizedBox(height: 15,),
            fetchedData.isEmpty ?
            ElasticIn(
              child: Column(
                children: [
                  SizedBox(height: 150,),
                  SvgPicture.asset(
                    'Assets/search.svg',
                    semanticsLabel: 'My SVG Image',
                    width: 200,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(child: Text('Enter your district name to search \nfor hospitals', textAlign: TextAlign.center, style: TextStyle(color: Colors.white70),)),
                  )
                ],
              ),
            ):
            Expanded(
              child: ListView.builder(
                itemCount: fetchedData.length,
                itemBuilder: (context, index) {
                  final appointment = fetchedData[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.grey.shade900,
                      ),
                      child: ListTile(
                          title: Text(
                            appointment['Hospital_Name'] ?? '', // Replace 'title' with the actual field name
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text( appointment['Address'] ?? '',style: TextStyle(color: Colors.white70),),
                              SizedBox(height: 10,),
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(left: 5, right: 5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.green.shade300,
                                    ),
                                    child: Text(
                                      appointment['District'] ?? '', // Replace 'description' with the actual field name
                                      style: TextStyle(color: Colors.black, fontSize: 10),
                                    ),
                                  ),
                                  SizedBox(width: 10,),
                                  Container(
                                    padding: EdgeInsets.only(left: 5, right: 5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.yellow.shade400,
                                    ),
                                    child: Text(
                                      appointment['CityTown'] ?? '', // Replace 'description' with the actual field name
                                      style: TextStyle(color: Colors.black, fontSize: 10),
                                    ),
                                  ),

                                ],
                              ),
                            ],
                          ),
                          onTap: () {
                            // Handle tap on the appointment tile
                          },
                          
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
