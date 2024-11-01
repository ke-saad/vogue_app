import 'package:flutter/material.dart';

class ProfileFields extends StatefulWidget {
  final Map<String, dynamic> userInfo;
  final Function(bool) updateHasChanges;

  const ProfileFields({
    super.key,
    required this.userInfo,
    required this.updateHasChanges,
  });

  @override
  State<ProfileFields> createState() => _ProfileFieldsState();
}

class _ProfileFieldsState extends State<ProfileFields> {
  final _formKey = GlobalKey<FormState>();

  final Color focusedBorderColor = Colors.red;
  final Color unfocusedBorderColor = Colors.red.withOpacity(0.5);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final fieldHeight = screenHeight * 0.07;

    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Email Field
          _buildTextField(
            label: 'Login',
            initialValue: widget.userInfo['email'],
            onChanged: (value) {
              widget.updateHasChanges(true);
              setState(() {
                widget.userInfo['email'] = value;
              });
            },
            validatorMessage: 'Please enter your email',
            height: fieldHeight,
            enabled: false, // Email should be disabled as it comes from Firebase Auth
          ),
          const SizedBox(height: 12.0),

          const SizedBox(height: 12.0),

          // New Password Field
          _buildTextField(
            label: 'Password',
            initialValue: widget.userInfo['newPassword'] ?? 'votemotdepasse',
            onChanged: (value) {
              widget.updateHasChanges(true);
              setState(() {
                widget.userInfo['newPassword'] = value;
              });
            },
            validatorMessage: 'Please enter your new password',
            height: fieldHeight,
            obscureText: true,
          ),
          const SizedBox(height: 12.0),

          // Birthday Field
          _buildTextField(
            label: 'Anniversaire',
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
          const SizedBox(height: 12.0),

          // Address Field
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
          const SizedBox(height: 12.0),

          // Postal Code Field
          _buildTextField(
            label: 'Code Postal',
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
          const SizedBox(height: 12.0),

          // Address Field
          _buildTextField(
            label: 'Ville',
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
    required Function(String) onChanged,
    required String validatorMessage,
    double? height,
    bool obscureText = false,
    bool enabled = true,
  }) {
    return SizedBox(
      height: height,
      child: TextFormField(
        initialValue: initialValue,
        onChanged: onChanged,
        obscureText: obscureText,
        enabled: enabled,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: focusedBorderColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: unfocusedBorderColor),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return validatorMessage;
          }
          return null;
        },
      ),
    );
  }
}
