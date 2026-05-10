import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/mahasiswa.dart';

class ApiService {
  // Ganti dengan IP kamu jika pakai HP fisik
  // Untuk emulator Android gunakan: 10.0.2.2
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  static const Map<String, String> headers = {'Accept': 'application/json'};

  // GET semua mahasiswa
  static Future<List<Mahasiswa>> getMahasiswas() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/mahasiswa'),
        headers: headers,
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 200 && body['status'] == true) {
        final List<dynamic> dataList = body['data'];
        return dataList.map((item) => Mahasiswa.fromJson(item)).toList();
      } else {
        throw Exception(body['message'] ?? 'Gagal memuat data');
      }
    } on SocketException {
      throw Exception('Tidak ada koneksi. Cek server Laravel kamu!');
    } catch (e) {
      throw Exception('$e');
    }
  }

  // GET detail mahasiswa
  static Future<Mahasiswa> getMahasiswaById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/mahasiswa/$id'),
        headers: headers,
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 200 && body['status'] == true) {
        return Mahasiswa.fromJson(body['data']);
      } else {
        throw Exception(body['message'] ?? 'Tidak ditemukan');
      }
    } catch (e) {
      throw Exception('$e');
    }
  }

  // POST tambah mahasiswa
  static Future<Mahasiswa> createMahasiswa({
    required String nim,
    required String nama,
    required String jenisKelamin,
    required String kelas,
    required String jurusan,
    required String tahunMasuk,
    required String agama,
    required String alamat,
    String? linkIg,
    String? linkLinkedin,
    File? foto,
  }) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/mahasiswa'),
      );

      request.headers['Accept'] = 'application/json';
      request.fields['nim'] = nim;
      request.fields['nama'] = nama;
      request.fields['jenis_kelamin'] = jenisKelamin;
      request.fields['kelas'] = kelas;
      request.fields['jurusan'] = jurusan;
      request.fields['tahun_masuk'] = tahunMasuk;
      request.fields['agama'] = agama;
      request.fields['alamat'] = alamat;
      if (linkIg != null && linkIg.isNotEmpty) {
        request.fields['link_ig'] = linkIg;
      }
      if (linkLinkedin != null && linkLinkedin.isNotEmpty) {
        request.fields['link_linkedin'] = linkLinkedin;
      }
      if (foto != null) {
        request.files.add(await http.MultipartFile.fromPath('foto', foto.path));
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      final body = jsonDecode(response.body);

      if (response.statusCode == 201 && body['status'] == true) {
        return Mahasiswa.fromJson(body['data']);
      } else {
        String errorMsg = body['message'] ?? 'Gagal menambah';
        if (body['errors'] != null) {
          final errors = body['errors'] as Map<String, dynamic>;
          errorMsg = errors.values.first[0];
        }
        throw Exception(errorMsg);
      }
    } catch (e) {
      throw Exception('$e');
    }
  }

  // PUT update mahasiswa
  static Future<Mahasiswa> updateMahasiswa({
    required int id,
    String? nim,
    String? nama,
    String? jenisKelamin,
    String? kelas,
    String? jurusan,
    String? tahunMasuk,
    String? agama,
    String? alamat,
    String? linkIg,
    String? linkLinkedin,
    File? foto,
  }) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/mahasiswa/$id'),
      );

      request.headers['Accept'] = 'application/json';
      request.fields['_method'] = 'PUT';

      if (nim != null) request.fields['nim'] = nim;
      if (nama != null) request.fields['nama'] = nama;
      if (jenisKelamin != null) request.fields['jenis_kelamin'] = jenisKelamin;
      if (kelas != null) request.fields['kelas'] = kelas;
      if (jurusan != null) request.fields['jurusan'] = jurusan;
      if (tahunMasuk != null) request.fields['tahun_masuk'] = tahunMasuk;
      if (agama != null) request.fields['agama'] = agama;
      if (alamat != null) request.fields['alamat'] = alamat;
      if (linkIg != null) request.fields['link_ig'] = linkIg;
      if (linkLinkedin != null) request.fields['link_linkedin'] = linkLinkedin;
      if (foto != null) {
        request.files.add(await http.MultipartFile.fromPath('foto', foto.path));
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      final body = jsonDecode(response.body);

      if (response.statusCode == 200 && body['status'] == true) {
        return Mahasiswa.fromJson(body['data']);
      } else {
        throw Exception(body['message'] ?? 'Gagal update');
      }
    } catch (e) {
      throw Exception('$e');
    }
  }

  // DELETE hapus mahasiswa
  static Future<bool> deleteMahasiswa(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/mahasiswa/$id'),
        headers: headers,
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 200 && body['status'] == true) {
        return true;
      } else {
        throw Exception(body['message'] ?? 'Gagal hapus');
      }
    } catch (e) {
      throw Exception('$e');
    }
  }
}
