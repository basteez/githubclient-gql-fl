import 'package:flutter/material.dart';
import 'package:github_graphql_client/src/github_summary.dart';
import 'package:gql_exec/gql_exec.dart';
import 'package:gql_link/gql_link.dart';
import 'package:gql_http_link/gql_http_link.dart';
import 'package:window_to_front/window_to_front.dart';
import 'github_oauth_credentials.dart';
import 'src/github_gql/github_queries.data.gql.dart';
import 'src/github_gql/github_queries.req.gql.dart';
import 'src/github_login.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GitHub GraphQL API Client',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'GitHub GraphQL API Client'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return GithubLoginWidget(
        builder: (context, httpClient) {
          WindowToFront.activate();
          return Scaffold(
            appBar: AppBar(
              title: Text(title),
            ),
            body: GitHubSummary(client: httpClient),
          );
        },
        githubClientId: githubClientId,
        githubClientSecret: githubClientSecret,
        githubScopes: githubScopes
    );
  }
}
Future<$ViewerDetail$viewer> viewerDetail(Link link) async{
  var result = await link.request(ViewerDetail((b) => b)).first;
  if(result.errors != null && result.errors.isNotEmpty){
    throw QueryException(result.errors);
  }
  return $ViewerDetail(result.data).viewer;
}

class QueryException implements Exception{
  List<GraphQLError> errors;
  QueryException(this.errors);
  @override
  String toString(){
    return 'Query Exception: ${errors.map((err) => '$err').join(',')}';
  }

}

