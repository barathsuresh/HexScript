import 'package:HexScript/widgets/custom_list_tile_material_you.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ionicons/ionicons.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor:
          Color.lerp(Colors.white, Theme.of(context).colorScheme.primary, 0.2),
      child: Column(
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color.lerp(
                  Colors.white, Theme.of(context).colorScheme.primary, 0.4),
            ),
            padding: EdgeInsets.all(0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  MdiIcons.hexadecimal,
                  color: Colors.black,
                  size: 70,
                  weight: 1,
                ),
                Text('HexScript',
                    style: GoogleFonts.sourceCodePro(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
              ],
            ),
          ),
          CustomListTile(
            title: "New Note",
            subtitle: "Create a New Note",
            leadingIcon: MdiIcons.notebookPlus, onTap: (){},
          ),
          CustomListTile(
            title: "Locked Notes",
            subtitle: "Access notes with Biometrics",
            leadingIcon: MdiIcons.fingerprint, onTap: (){},
          ),
          CustomListTile(
            title: "Settings",
            subtitle: "Customization",
            leadingIcon: Icons.settings,
            onTap: (){
              // TODO
            },
          ),
          CustomListTile(
            title: "About",
            subtitle: "About HexScript",
            leadingIcon: CommunityMaterialIcons.information_outline,
            onTap: () {
              // TODO
            },
          ),
          Spacer(),
          CustomListTile(
            title: "Logout",
            subtitle: "Sorry to see you go...",
            leadingIcon: CommunityMaterialIcons.logout,
            onTap: (){
              // TODO
            },
          ),
        ],
      ),
    );
  }
}
