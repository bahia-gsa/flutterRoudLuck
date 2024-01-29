import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher_string.dart';





class ReadMe extends StatelessWidget {
  static const String routeName = "/read-me";

  const ReadMe({Key? key}) : super(key: key);

  final String introduction = '''
    I developed this app to enhance my programming skills. Its goal is to allow users to effortlessly create and manage multiple participant lists.
    Users can easily add, remove, and edit names to keep lists up-to-date.
    The app ensures equal chances for each participant to be randomly selected with a single tap, making it ideal for picking winners or assigning tasks. Its structure is divided into 4 components:
  ''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Read me',
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            Text(
              introduction,
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.white60,
                fontFamily: 'Unbounded',
              ),
            ),
            _buildCard('assets/icons/flutter.svg', 'for Android development.'),
            _buildCard('assets/icons/Angular.svg', 'for Web development.'),
            _buildCard('assets/icons/spring.svg', 'for user authentication logic.'),
            _buildCard('assets/icons/quarkus.svg', 'with Kotlin to handle the business server-side logic.'),
            _buildCard('assets/icons/postgresql.svg', 'as DBMS.'),
            _buildLinks(),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String svgPath, String cardText) {
    return Card(
      margin: EdgeInsets.all(10.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
             Container(
              width: 50.0,
              height: 50.0,
              child: SvgPicture.asset(svgPath),
            ),
            SizedBox(width: 10.0),
            Expanded(
              child: Text(
                cardText,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.white60,
                  fontFamily: 'Unbounded',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLinks() {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "As for its deployment, I used the following Google Cloud Platform (GCP) services",
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 16.0,
                fontFamily: "Unbounded",
                color: Colors.white60,
              ),
            ),
            const SizedBox(height: 8.0),
            _buildBulletPoint("Google Run: for the dockerized apps Spring and Quarkus."),
            _buildBulletPoint("Instance SQL: with Postgres."),
            _buildBulletPoint("Cloud Storage Buckets: for the Angular static files."),
            const SizedBox(height: 8.0),
            const Text(
              "The web application can be accessed in this:",
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 16.0,
                fontFamily: "Unbounded",
                color: Colors.white60
                ),
            ),
            _buildLink("link", "https://draw.schaedler-almeida.space/"),
            const SizedBox(height: 10.0),
            const Text(
              "The source code can be accessed:",
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 16.0,
                fontFamily: "Unbounded",
                color: Colors.white60
                ),
            ),
            _buildLink("here", "https://github.com/bahia-gsa/roundLuck"),
            const SizedBox(height: 10.0),
            _buildLink("My LinkedIn", "https://www.linkedin.com/in/schaedler-almeida"),
            const SizedBox(height: 10.0),
            const Text(
              "I've recently begun exploring Flutter's capabilities for developing Android apps. A very first version of the code source can be accessed:",
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 16.0,
                fontFamily: "Unbounded",
                color: Colors.white60
                ),
            ),
            _buildLink("here", "https://github.com/bahia-gsa/flutterRoudLuck"),
            const SizedBox(height: 10.0),
            const Text(
              "If you wish to try it on your Android device, you can download the APK file:",
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 16.0,
                fontFamily: "Unbounded",
                color: Colors.white60
                ),
            ),
            _buildLink("APK file", "https://drive.google.com/drive/folders/1uDZ0spaIoUzOIn9aHAlkp9OZ4DYTi9V2?usp=drive_link"),
          ],
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("•", style: TextStyle(fontSize: 16.0, fontFamily: "Unbounded", color: Colors.white60)),
        const SizedBox(width: 8.0),
        Expanded(child: Text(text, style: TextStyle(fontFamily: "Unbounded", color: Colors.white60))),
      ],
    );
  }

  Widget _buildLink(String text, String url) {

    Future<void> launchUrl(String urlString) async {
      if (await canLaunchUrlString(url)) {
          await launchUrlString(url);
          return;
        }
      // If the URL cannot be opened using the plugin, open it in the default browser
      launchUrlString(url);
    }

    return GestureDetector(
      onTap: ()  {
         launchUrl(url);
      },
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16.0,
          color: Colors.pink,
          //decoration: TextDecoration.underline,
          fontFamily: "Unbounded",
        ),
      ),
    );
  }
}
