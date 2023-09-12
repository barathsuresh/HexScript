import 'package:HexScript/api/encrypt_decrypt.dart';
import 'package:HexScript/api/local_auth_api.dart';
import 'package:HexScript/models/note.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomGridTile extends StatelessWidget {
  final Note note;
  final Function onTap;
  final Function onLockToggle;
  final Function onDelete;

  const CustomGridTile({
    required this.note,
    required this.onTap,
    required this.onLockToggle,
    required this.onDelete,
  });

  double calculateHeight(BuildContext context) {
    final maxLines = 10;
    final fontSize = 16.0;

    final textPainter = TextPainter(
      text: TextSpan(
        text: !note.isProtect
            ? note.txt.isEmpty
            ? ""
            : EncryptionDecryption.decryptMessage(note.txt)
            : "Authentication Required",
        style: GoogleFonts.sourceCodePro(
          fontSize: fontSize,
        ),
      ),
      maxLines: maxLines,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: MediaQuery.of(context).size.width - 24); // Adjust for padding and borders

    double height = textPainter.height;

    if (height > maxLines * fontSize) {
      height = maxLines * fontSize;
    }

    return height;
  }

  @override
  Widget build(BuildContext context) {
    final textHeight = calculateHeight(context);
    return Container(
      margin: EdgeInsets.all(5),
      height: textHeight + 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: GridTile(
        header: !note.title.isEmpty ? Padding(
          padding: EdgeInsets.all(7),
          child: Text(
            note.title.isEmpty ? "" : EncryptionDecryption.decryptMessage(note.title),
            maxLines: 1,
            style: GoogleFonts.sourceCodePro(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Theme.of(context)
                  .colorScheme
                  .primary
                  .computeLuminance() >
                  0.5
                  ? Colors.black
                  : Colors.white,),
          ),
        ):SizedBox.shrink(),
        footer: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (note.isProtect)
              Icon(
                Icons.fingerprint_outlined,
                color: Colors.blue,
                size: 24,
              ),
            IconButton(
              onPressed: () async {
                bool protectF = await LocalAuthApi.authenticate();
                if (protectF){
                  onLockToggle(!note.isProtect);
                }
              },
              icon: Icon(
                note.isProtect
                    ? Icons.lock_outline
                    : Icons.lock_open_outlined,
                color: note.isProtect
                    ? Colors.amberAccent
                    : Colors.red,
                size: 24,
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.delete_forever,
                color: Colors.red,
                size: 24,
              ),
              onPressed: () async {
                if (note.isProtect) {
                  if (await LocalAuthApi.authenticate()) {
                    onDelete();
                  }
                } else {
                  onDelete();
                }
              },
            ),
          ],
        ),
        child: InkWell(
          onTap: () async {
            if (note.isProtect == true) {
              if (await LocalAuthApi.authenticate()) {
                onTap();
              }
            } else {
              onTap();
            }
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Theme.of(context).colorScheme.secondary,
                width: 2.0,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                    padding: !note.title.isEmpty ? EdgeInsets.only(top: 26.0,left: 14) : EdgeInsets.only(top: 10.0,left: 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        note.title.isEmpty ? SizedBox() : SizedBox(height: 14,),
                          Expanded(
                            child: Text(
                              !note.isProtect
                                  ? note.txt.isEmpty ? "" : EncryptionDecryption.decryptMessage(note.txt)
                                  : "Authentication Required",
                              maxLines: 10,
                              overflow: TextOverflow.fade,
                              style: GoogleFonts.sourceCodePro(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondary
                                      .computeLuminance() >
                                      0.5
                                      ? Colors.black45
                                      : Colors.white70,),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
