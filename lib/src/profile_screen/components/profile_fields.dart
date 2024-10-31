import 'package:flutter/material.dart';

class ProfileFields extends StatefulWidget {
  final Map<String, dynamic> userInfo;
  final Function(bool) updateHasChanges;

  const ProfileFields({Key? key, required this.userInfo, required this.updateHasChanges}) : super(key: key);

  @override
  State<ProfileFields> createState() => _ProfileFieldsState();
}

class _ProfileFieldsState extends State<ProfileFields> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            initialValue: widget.userInfo['first_name'],
            decoration: const InputDecoration(labelText: 'First Name'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your first name';
              }
              return null;
            },
            onChanged: (value) {
              widget.updateHasChanges(true);
              setState(() {
                widget.userInfo['first_name'] = value;
              });
            },
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            initialValue: widget.userInfo['last_name'],
            decoration: const InputDecoration(labelText: 'Last Name'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your last name';
              }
              return null;
            },
            onChanged: (value) {
              widget.updateHasChanges(true);
              setState(() {
                widget.userInfo['last_name'] = value;
              });
            },
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            initialValue: widget.userInfo['birthday'],
            decoration: const InputDecoration(labelText: 'Birthday'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your birthday';
              }
              return null;
            },
            onChanged: (value) {
              widget.updateHasChanges(true);
              setState(() {
                widget.userInfo['birthday'] = value;
              });
            },
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            initialValue: widget.userInfo['address'],
            decoration: const InputDecoration(labelText: 'Address'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your address';
              }
              return null;
            },
            onChanged: (value) {
              widget.updateHasChanges(true);
              setState(() {
                widget.userInfo['address'] = value;
              });
            },
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            initialValue: widget.userInfo['postalCode'],
            decoration: const InputDecoration(labelText: 'Postal Code'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your postal code';
              }
              return null;
            },
            onChanged: (value) {
              widget.updateHasChanges(true);
              setState(() {
                widget.userInfo['postalCode'] = value;
              });
            },
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            initialValue: widget.userInfo['city'],
            decoration: const InputDecoration(labelText: 'City'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your city';
              }
              return null;
            },
            onChanged: (value) {
              widget.updateHasChanges(true);
              setState(() {
                widget.userInfo['city'] = value;
              });
            },
          ),
        ],
      ),
    );
  }
}