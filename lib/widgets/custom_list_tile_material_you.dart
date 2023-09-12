import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class CustomListTile extends StatelessWidget {
  final IconData leadingIcon;
  final String title;
  final String subtitle;
  final Widget? trailing; // Make trailing optional
  final Function onTap;

  CustomListTile({
    required this.leadingIcon,
    required this.title,
    required this.subtitle,
    this.trailing, // Make trailing optional
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color.lerp(
          Colors.white, Theme.of(context).colorScheme.primary, 0.4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 2.0,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
        leading: CircleAvatar(
          child: Icon(leadingIcon),
        ),
        title: Text(
          title,
          style: GoogleFonts.sourceCodePro(
              fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.sourceCodePro(color: Colors.black),
        ),
        trailing: trailing, // Use the provided trailing widget
        onTap: () {
          // Handle tap action here
          onTap();
        },
      ),
    );
  }
}