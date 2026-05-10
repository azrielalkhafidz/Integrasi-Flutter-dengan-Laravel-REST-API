class Mahasiswa {
  final int id;
  final String nim;
  final String nama;
  final String jenisKelamin;
  final String kelas;
  final String jurusan;
  final int tahunMasuk;
  final String agama;
  final String alamat;
  final String? foto;
  final String? linkIg;
  final String? linkLinkedin;

  const Mahasiswa({
    required this.id,
    required this.nim,
    required this.nama,
    required this.jenisKelamin,
    required this.kelas,
    required this.jurusan,
    required this.tahunMasuk,
    required this.agama,
    required this.alamat,
    this.foto,
    this.linkIg,
    this.linkLinkedin,
  });

  factory Mahasiswa.fromJson(Map<String, dynamic> json) {
    return Mahasiswa(
      id: json['id'] as int,
      nim: json['nim'] as String,
      nama: json['nama'] as String,
      jenisKelamin: json['jenis_kelamin'] as String,
      kelas: json['kelas'] as String,
      jurusan: json['jurusan'] as String,
      tahunMasuk: int.parse(json['tahun_masuk'].toString()),
      agama: json['agama'] as String,
      alamat: json['alamat'] as String,
      foto: json['foto'] as String?,
      linkIg: json['link_ig'] as String?,
      linkLinkedin: json['link_linkedin'] as String?,
    );
  }

  String get jenisKelaminText => jenisKelamin == 'L' ? 'Laki-laki' : 'Perempuan';
}