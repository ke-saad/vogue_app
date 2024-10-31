import 'package:flutter/material.dart';

class ProfileFields extends StatefulWidget {
  final Map<String, dynamic> userInfo;
  final Function(bool) updateHasChanges;

  const ProfileFields({super.key, required this.userInfo, required this.updateHasChanges});

  @override
  State<ProfileFields> createState() => _ProfileFieldsState();
}

class _ProfileFieldsState extends State<ProfileFields> {
  final _formKey = GlobalKey<FormState>();

  final Color focusedBorderColor = Colors.red;
  final Color unfocusedBorderColor = Colors.red.withOpacity(0.5);

  @override
  Widget build(BuildContext context) {
    // Use MediaQuery to get the screen height
    final screenHeight = MediaQuery.of(context).size.height;
    // Adjust field height based on screen height (10% of screen height here, for example)
    final fieldHeight = screenHeight * 0.1;

    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildTextField(
            label: 'First Name',
            initialValue: widget.userInfo['first_name'],
            onChanged: (value) {
              widget.updateHasChanges(true);
              setState(() {
                widget.userInfo['first_name'] = value;
              });
            },
            validatorMessage: 'Please enter your first name',
            height: fieldHeight,
          ),
          const SizedBox(height: 16.0),
          _buildTextField(
            label: 'Last Name',
            initialValue: widget.userInfo['last_name'],
            onChanged: (value) {
              widget.updateHasChanges(true);
              setState(() {
                widget.userInfo['last_name'] = value;
              });
            },
            validatorMessage: 'Please enter your last name',
            height: fieldHeight,
          ),
          const SizedBox(height: 16.0),
          _buildTextField(
            label: 'Birthday',
            initialValue: widget.userInfo['birthday'],
            onChanged: (value) {
              widget.updateHasChanges(true);
              setState(() {
                widget.userInfo['birthday'] = value;
              });
            },
            validatorMessage: 'Please enter your birthday',
            height: fieldHeight,
          ),
          const SizedBox(height: 16.0),
          _buildTextField(
            label: 'Address',
            initialValue: widget.userInfo['address'],
            onChanged: (value) {
              widget.updateHasChanges(true);
              setState(() {
                widget.userInfo['address'] = value;
              });
            },
            validatorMessage: 'Please enter your address',
            height: fieldHeight,
          ),
          const SizedBox(height: 16.0),
          _buildTextField(
            label: 'Postal Code',
            initialValue: widget.userInfo['postalCode'],
            onChanged: (value) {
              widget.updateHasChanges(true);
              setState(() {
                widget.userInfo['postalCode'] = value;
              });
            },
            validatorMessage: 'Please enter your postal code',
            height: fieldHeight,
          ),
          const SizedBox(height: 16.0),
          _buildTextField(
            label: 'City',
            initialValue: widget.userInfo['city'],
            onChanged: (value) {
              widget.updateHasChanges(true);
              setState(() {
                widget.userInfo['city'] = value;
              });
            },
            validatorMessage: 'Please enter your city',
            height: fieldHeight,
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String? initialValue,
    required ValueChanged<String> onChanged,
    required String validatorMessage,
    required double height,
  }) {
    return SizedBox(
      height: height,
      child: TextFormField(
        initialValue: initialValue,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: focusedBorderColor, width: 2.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: unfocusedBorderColor, width: 1.0),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return validatorMessage;
          }
          return null;
        },
        onChanged: onChanged,
      ),
    );
  }
}
