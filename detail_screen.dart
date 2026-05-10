import 'package:flutter/material.dart';
import '../models/mahasiswa.dart';

class DetailScreen extends StatelessWidget {
  final Mahasiswa mahasiswa;

  const DetailScreen({super.key, required this.mahasiswa});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: CustomScrollView(
        slivers: [
          // Header dengan foto
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: Colors.indigo[800],
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.indigo.shade900,
                      Colors.indigo.shade500,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    // Foto
                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: mahasiswa.foto != null
                            ? Image.network(
                                mahasiswa.foto!,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  color: Colors.indigo[300],
                                  child: Center(
                                    child: Text(
                                      mahasiswa.nama[0].toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: 40,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Container(
                                color: Colors.indigo[300],
                                child: Center(
                                  child: Text(
                                    mahasiswa.nama[0].toUpperCase(),
                                    style: const TextStyle(
                                      fontSize: 40,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      mahasiswa.nama,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        mahasiswa.nim,
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Konten detail
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildSection('📚 Informasi Akademik', [
                    _buildRow(Icons.badge, 'NIM', mahasiswa.nim),
                    _buildRow(Icons.class_, 'Kelas', mahasiswa.kelas),
                    _buildRow(Icons.school, 'Jurusan', mahasiswa.jurusan),
                    _buildRow(Icons.calendar_today, 'Tahun Masuk',
                        '${mahasiswa.tahunMasuk}'),
                  ]),
                  const SizedBox(height: 12),
                  _buildSection('👤 Informasi Pribadi', [
                    _buildRow(Icons.person, 'Nama', mahasiswa.nama),
                    _buildRow(Icons.wc, 'Jenis Kelamin',
                        mahasiswa.jenisKelaminText),
                    _buildRow(Icons.mosque, 'Agama', mahasiswa.agama),
                    _buildRow(
                        Icons.location_on, 'Alamat', mahasiswa.alamat),
                  ]),
                  if (mahasiswa.linkIg != null ||
                      mahasiswa.linkLinkedin != null) ...[
                    const SizedBox(height: 12),
                    _buildSection('🌐 Media Sosial', [
                      if (mahasiswa.linkIg != null)
                        _buildRow(Icons.camera_alt, 'Instagram',
                            mahasiswa.linkIg!),
                      if (mahasiswa.linkLinkedin != null)
                        _buildRow(Icons.work, 'LinkedIn',
                            mahasiswa.linkLinkedin!),
                    ]),
                  ],
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> items) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.indigo[800],
              ),
            ),
            const Divider(height: 20),
            ...items,
          ],
        ),
      ),
    );
  }

  Widget _buildRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.indigo[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: Colors.indigo[700]),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                      fontSize: 11, color: Colors.grey[500]),
                ),
                Text(
                  value,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}