import 'package:flutter/material.dart';

class ConfirmationPage extends StatefulWidget {
  final String? serialNumber;

  ConfirmationPage({this.serialNumber});

  @override
  State<ConfirmationPage> createState() => _ConfirmationPageState();
}

class _ConfirmationPageState extends State<ConfirmationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.all(24),
          child: Column(
            children: [
              HeaderCloseButton(Icons.close),
              SizedBox(height: 48),
              Expanded(
                child: Container(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/check.png',
                        width: 104,
                      ),
                      SizedBox(height: 18),
                      DeskripsiPesanPopup("Peminjaman berhasil.",
                          "Selamat berkendara, Telyutizen! :D"),
                      SizedBox(height: 48),
                      Column(
                        children: [
                          Container(
                            width: 282,
                            height: 46.27,
                            decoration: ShapeDecoration(
                              color: Color(0xFFDBABAB),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Detail Peminjaman',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          Container(
                            width: 282,
                            padding: EdgeInsets.symmetric(
                                horizontal: 24, vertical: 16),
                            decoration: ShapeDecoration(
                              color: Color(0xFFEBD0D0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(0),
                                  topRight: Radius.circular(0),
                                  bottomLeft: Radius.circular(24),
                                  bottomRight: Radius.circular(24),
                                ),
                              ),
                              shadows: [
                                BoxShadow(
                                  color: Color(0x3F000000),
                                  blurRadius: 4,
                                  offset: Offset(0, 4),
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                ListTabelPeminjaman("Nama", "User 1"),
                                SizedBox(height: 16),
                                ListTabelPeminjaman("Kendaraan", "Sepeda"),
                                SizedBox(height: 16),
                                ListTabelPeminjaman(
                                    "Nomor Seri", widget.serialNumber ?? ''),
                                SizedBox(height: 16),
                                ListTabelPeminjaman("Shelther Awal", "GKU"),
                                SizedBox(height: 16),
                                ListTabelPeminjaman("Shelther Akhir", "TULT"),
                                SizedBox(height: 16),
                                ListTabelPeminjaman(
                                    "Batas Waktu Pinjam", "15:23 WIB"),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget HeaderCloseButton(IconData icon) {
    return Container(
      width: double.infinity,
      child: Row(
        children: [
          GestureDetector(
            onTap: () {},
            child: Icon(
              icon,
              size: 40,
            ),
          ),
        ],
      ),
    );
  }

  Widget DeskripsiPesanPopup(String title, String deskripsi) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            color: Color(0xFFA32828),
            fontSize: 20,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 8),
        Container(
          width: 200,
          child: Text(
            deskripsi,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  Widget ListTabelPeminjaman(String atribut, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            atribut,
            style: TextStyle(
              color: Color(0xFF414141),
              fontSize: 16,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Container(
          width: 100,
          child: Text(
            value,
            style: TextStyle(
              color: Color(0xFFA32828),
              fontSize: 16,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
