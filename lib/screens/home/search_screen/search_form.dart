import 'package:flutter/material.dart';
import 'package:polimi_reviews/models/filter.dart';
import 'package:polimi_reviews/models/school.dart';
import 'package:polimi_reviews/screens/search_result/search_result.dart';
import 'package:polimi_reviews/services/database.dart';
import 'package:polimi_reviews/shared/constants.dart';

class SearchForm extends StatefulWidget {
  @override
  _SearchFormState createState() => _SearchFormState();
}

class _SearchFormState extends State<SearchForm> {

  final _formKey = GlobalKey<FormState>();
  String _currentSchool;
  String _currentDegree;
  String _currentExam;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(child: Image.asset('assets/polimilogo.png', color: AppColors.grey,)),
        Form(
          key: _formKey,
          child: Column(
            children: [
              StreamBuilder<List<School>>(
                stream: DatabaseServices().schools,
                builder: (context, snapshot) => snapshot.hasData ? DropdownButtonFormField(
                  decoration: textInputDecoration.copyWith(hintText: "School",),
                  value: _currentSchool,
                  isExpanded: true,
                  validator: (val) => val==null ? 'Insert a school' : null,
                  onChanged: (value) => setState((){
                    _currentDegree = null;
                    _currentSchool = value;
                  }),
                  items: snapshot.data.map((school) => DropdownMenuItem(
                    child: Text(school.name, overflow: TextOverflow.visible, style: TextStyle(fontSize: 14),),
                    value: school.name,
                  )).toList(),
                ) : DropdownButtonFormField(items: [], onChanged: (val){}, decoration: textInputDecoration.copyWith(hintText: "School",),),
              ),
              SizedBox(height: 20.0,),
              StreamBuilder<List<Degree>>(
                stream: DatabaseServices().getDegrees(_currentSchool),
                builder: (context, snapshot) => snapshot.hasData ? DropdownButtonFormField(
                  value: _currentDegree,
                  validator: (val) => val==null ? 'Insert a degree' : null,
                  decoration: textInputDecoration.copyWith(hintText: "Degree",),
                  isExpanded: true,
                  onChanged: (value) => setState(() => _currentDegree=value),
                  items: snapshot.data.map((degree) => DropdownMenuItem(
                    child: Text(degree.name, overflow: TextOverflow.visible, style: TextStyle(fontSize: 14),),
                    value: degree.name,
                  )).toList(),
                ) : DropdownButtonFormField(items: [], onChanged: (val){}, decoration: textInputDecoration.copyWith(hintText: "Degree",),),
              ),
              SizedBox(height: 20.0,),
              TextFormField(
                onChanged: (value) => setState(() => _currentExam=value),
                decoration: textInputDecoration.copyWith(hintText: 'Exam'),
              ),
              SizedBox(height: 20,),
              RaisedButton(
                child: Text('Search', style: TextStyle(color: Colors.white),),
                onPressed: () {
                  if(_formKey.currentState.validate()){
                    Filter filter = Filter(school: _currentSchool, degree: _currentDegree, exam: _currentExam);
                    Navigator.push(context, PageRouteBuilder(
                      transitionDuration: Duration(milliseconds: 500),
                      transitionsBuilder: transitionsBuilder,
                      pageBuilder: (context, _, __) => SearchResult(filter: filter,)));
                  }
                },
              )
            ],
          ),
        ),
      ]
    );
  }
}
