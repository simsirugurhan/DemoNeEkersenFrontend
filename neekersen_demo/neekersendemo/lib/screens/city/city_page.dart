import 'package:flutter/material.dart';
import 'package:neekersendemo/screens/city/city_pages/city_selector_page.dart';

const List<String> cities = <String>[
  "ADANA",
  "ADIYAMAN",
  "AFYONKARAHİSAR",
  "AĞRI",
  "AKSARAY",
  "AMASYA",
  "ANKARA",
  "ANTALYA",
  "ARDAHAN",
  "ARTVİN",
  "AYDIN",
  "BALIKESİR",
  "BARTIN",
  "BATMAN",
  "BAYBURT",
  "BİLECİKK",
  "BİNGÖL",
  "BİTLİS",
  "BOLU",
  "BURDUR",
  "BURSA",
  "ÇANAKKALE",
  "ÇANKIRI",
  "ÇORUM",
  "DENİZLİ",
  "DİYARBAKIR",
  "DÜZCE",
  "EDİRNE",
  "ELAZIĞ",
  "ERZİNCAN",
  "ERZURUM",
  "ESKİŞEHİR",
  "GAZİANTEP",
  "GİRESUN",
  "GÜMÜŞHANE",
  "HAKKARİ",
  "HATAY",
  "IĞDIR",
  "ISPARTA",
  "İSTANBUL",
  "İZMİR",
  "KAHRAMANMARAŞ",
  "KARABüK",
  "KARAMAN",
  "KARS",
  "KASTAMONU",
  "KAYSERİ",
  "KIRKLARELİ",
  "KIRIKKALE",
  "KIRŞEHİR",
  "KİLİS",
  "KOCAELİ",
  "KONYA",
  "KÜTAHYA",
  "MALATYA",
  "MANİSA",
  "MARDİN",
  "MERSİN",
  "MUĞLA",
  "MUŞ",
  "NEVŞEHİR",
  "NİĞDE",
  "ORDU",
  "OSMANİYE",
  "RİZE",
  "SAKARYA",
  "SAMSUN",
  "SİİRT",
  "SİNOP",
  "SİVAS",
  "ŞANLIURFA",
  "ŞIRNAK",
  "TEKİRDAĞ",
  "TOKAT",
  "TRABZON",
  "TUNCELİ",
  "UŞAK",
  "VAN",
  "YALOVA",
  "YOZGAT",
  "ZONGULDAK"
];

class CityPage extends StatelessWidget {
  const CityPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("City Chooser"),
        centerTitle: true,
      ),
      body: const Center(child: CitySelectorPage()),
    );
  }
}
