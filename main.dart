import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer' as developer;
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DaftarUMKM {
  final int id;
  String nama;
  String jenis;
  DaftarUMKM({required this.id, required this.nama, required this.jenis});
}

class UMKM {
  List<DaftarUMKM> listPop = <DaftarUMKM>[];

  UMKM(Map<String, dynamic> json) {
    // isi listPop disini
    var data = json["data"];
    for (var val in data) {
      var id = int.parse(val["id"].toString());
      var nama = val["nama"].toString();
      var jenis = val["jenis"].toString();
      listPop.add(DaftarUMKM(id: id, nama: nama, jenis: jenis));
    }
  }
  //map dari json ke atribut
  factory UMKM.fromJson(Map<String, dynamic> json) {
    return UMKM(json);
  }
}

class UMKMCubit extends Cubit<List<DaftarUMKM>> {
  UMKMCubit() : super([]);

  Future<void> fetchDaftarUMKMs() async {
    try {
      emit(state);
      final url = "http://178.128.17.76:8000/daftar_umkm";
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jenis = UMKM.fromJson(jsonDecode(response.body)).listPop;
        emit(jenis);
      } else {
        throw Exception('Gagal load');
      }
    } catch (e) {
      throw Exception('Gagal load');
    }
  }
}

class DetailUMKM {
  final int id;
  String nama;
  String jenis;
  String omzet_bulan;
  String lama_usaha;
  String member_sejak;
  String jumlah_pinjaman_sukses;
  DetailUMKM(
      {required this.id,
      required this.nama,
      required this.jenis,
      required this.omzet_bulan,
      required this.lama_usaha,
      required this.member_sejak,
      required this.jumlah_pinjaman_sukses});
}

class detail_UMKM {
  List<DetailUMKM> listPop = <DetailUMKM>[];

  detail_UMKM(Map<String, dynamic> json) {
    // isi listPop disini
    var data = json["data"];
    for (var val in data) {
      var idUMKM = int.parse(val["id"].toString());
      var nama = val["nama"].toString();
      var jenisUMKM = val["jenis"].toString();
      var omzet_bulan = val["omzet_bulan"].toString();
      var lama_usaha = val["lama_usaha"].toString();
      var member_sejak = val["member_sejak"].toString();
      var jumlah_pinjaman_sukses = val["jumlah_pinjaman_sukses"].toString();
      listPop.add(DetailUMKM(
          id: idUMKM,
          nama: nama,
          jenis: jenisUMKM,
          omzet_bulan: omzet_bulan,
          lama_usaha: lama_usaha,
          member_sejak: member_sejak,
          jumlah_pinjaman_sukses: jumlah_pinjaman_sukses));
    }
  }
  //map dari json ke atribut
  factory detail_UMKM.fromJson(Map<String, dynamic> json) {
    return detail_UMKM(json);
  }
}

class DetailUMKMCubit extends Cubit<List<DetailUMKM>> {
  DetailUMKMCubit() : super([]);

  Future<void> fetchDetailUMKMs() async {
    try {
      emit(state);
      final url = "http://178.128.17.76:8000/detil_umkm/";
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jenis = detail_UMKM.fromJson(jsonDecode(response.body)).listPop;
        emit(jenis);
      } else {
        throw Exception('Gagal load');
      }
    } catch (e) {
      throw Exception('Gagal load');
    }
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UMKMCubit>(
            create: (context) => UMKMCubit()..fetchDaftarUMKMs()),
        BlocProvider<DetailUMKMCubit>(
            create: (context) => DetailUMKMCubit()..fetchDetailUMKMs()),
        //BlocProvider<OrderCubit>(create: (context) => OrderCubit()..fetchOrders()),
      ],
      child: MaterialApp(
        title: 'My App',
        home: HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz 3'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '2108077, Hestina Dwi Hartiwi, 2105673, Alghaniyu Naufal Hamid; Saya berjanji tidak akan berbuat curang data atau membantu orang lain berbuat curang',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              UMKMCubit();
            },
            child: Text('Muat Ulang'),
          ),
          Expanded(
            child: BlocBuilder<UMKMCubit, List<DaftarUMKM>>(
              builder: (context, userList) {
                return ListView.builder(
                  itemCount: userList.length,
                  itemBuilder: (context, index) {
                    DaftarUMKM umkm = userList[index];
                    DetailUMKM detail;
                    return ListTile(
                      title: Text(umkm.nama),
                      subtitle: Text("Jenis: ${umkm.jenis}"),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailUMKMPage(umkm: umkm),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
          // Expanded(
          //   child: BlocBuilder<DetailUMKMCubit, List<DetailUMKM>>(
          //     builder: (context, detailUMKMList) {
          //       return ListView.builder(
          //         itemCount: detailUMKMList.length,
          //         itemBuilder: (context, index) {
          //           DetailUMKM product = detailUMKMList[index];
          //           return ListTile(
          //             title: Text(product.nama),
          //             subtitle: Text("Jenis: ${product.omzet_bulan}"),
          //           );
          //         },
          //       );
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}

class DetailUMKMPage extends StatelessWidget {
  final DaftarUMKM umkm;

  DetailUMKMPage({required this.umkm});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail UMKM'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Name: ${umkm.nama}'),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Jenis: ${umkm.jenis}'),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Omzet Bulan: ${key}'),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Lama Usaha: ${key}'),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Member Sejak: ${key}'),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Jumlah Pinjaman Sukses: ${key}'),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}
