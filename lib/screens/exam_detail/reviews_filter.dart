import 'package:flutter/material.dart';
import 'package:polimi_reviews/models/review_model.dart';
import 'package:polimi_reviews/shared/constants.dart';

class ReviewsFilter extends StatefulWidget {

  final ReviewModel model;
  ReviewsFilter(this.model);

  @override
  _ReviewsFilterState createState() => _ReviewsFilterState();
}

class _ReviewsFilterState extends State<ReviewsFilter> {

  String currentFilter;

  @override
  void initState() {
    currentFilter = widget.model.currentFilter;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text('Sort by:', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),),
        DropdownButton<String>(
          style: TextStyle(fontSize: 14.0, color: Colors.black),
          underline: Divider(height: 2.0, thickness: 1.0, color: AppColors.lightblue,),
          icon: Icon(Icons.filter_list, color: AppColors.lightblue,),
          value: currentFilter,
          onChanged: (value) {
            this.setState(() => currentFilter=value);
            widget.model.sort(value);
            },
          items: ReviewModel.filterValues.map((filter) => DropdownMenuItem(
            value: filter,
            child: Text(filter),
          )).toList(),
        ),
      ],
    );
  }
}
