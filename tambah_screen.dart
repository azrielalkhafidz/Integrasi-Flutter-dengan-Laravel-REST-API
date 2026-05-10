import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/api_service.dart';

class TambahScreen extends StatefulWidget {
  const TambahScreen({super.key});

  @override
  State<TambahScreen> createState() => _TambahScreenState();
}

class _TambahScreenState extends State<TambahScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nimController = TextEditingController();
  final _namaController = TextEditingController();
  final _kelasController = TextEditingController();
  final _jurusanController = TextEditingController();
  final _tahunMasukController = TextEditingController();
  final _agamaController = TextEditingController();
  final _alamatController = TextEditingController();
  final _linkIgController = TextEditingController();
  final _linkLinkedinController = TextEditingController();

  String _jenisKelamin = 'L';
  File? _foto;
  bool _isLoading = false;

  @override
  void dispose() {
    _nimController.dispose();
    _namaController.dispose();
    _kelasController.dispose();
    _jurusanController.dispose();
    _tahunMasukController.dispose();
    _agamaController.dispose();
    _alamatController.dispose();
    _linkIgController.dispose();
    _linkLinkedinController.dispose();
    super.dispose();
  }

  Future<void> _pilihFoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 80,
    );
    if (pickedFile != null) {
      setState(() => _foto = File(pickedFile.path));
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      await ApiService.createMahasiswa(
        nim: _nimController.text.trim(),
        nama: _namaController.text.trim(),
        jenisKelamin: _jenisKelamin,
        kelas: _kelasController.text.trim(),
        jurusan: _jurusanController.text.trim(),
        tahunMasuk: _tahunMasukController.text.trim(),
        agama: _agamaController.text.trim(),
        alamat: _alamatController.text.trim(),
        linkIg: _linkIgController.text.trim(),
        linkLinkedin: _linkLinkedinController.text.trim(),
        foto: _foto,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('Mahasiswa berhasil ditambahkan!'),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Tambah Mahasiswa',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.indigo[800],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header foto
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24),
              decoration: BoxDecoration(
                color: Colors.indigo[800],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _pilihFoto,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        color: Colors.white24,
                      ),
                      child: ClipOval(
                        child: _foto != null
                            ? Image.file(_foto!, fit: BoxFit.cover)
                            : const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_a_photo,
                                      color: Colors.white, size: 30),
                                  SizedBox(height: 4),
                                  Text(
                                    'Pilih Foto',
                                    style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 11),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Form
            Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildCard([
                      _buildField(_nimController, 'NIM', Icons.badge,
                          validator: (v) => v!.isEmpty ? 'NIM wajib diisi' : null),
                      _buildField(_namaController, 'Nama Lengkap', Icons.person,
                          validator: (v) => v!.isEmpty ? 'Nama wajib diisi' : null),
                    ]),
                    const SizedBox(height: 12),

                    // Jenis Kelamin
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Jenis Kelamin',
                              style: TextStyle(
                                  color: Colors.indigo[800],
                                  fontWeight: FontWeight.bold)),
                          Row(
                            children: [
                              Expanded(
                                child: RadioListTile<String>(
                                  title: const Text('Laki-laki'),
                                  value: 'L',
                                  groupValue: _jenisKelamin,
                                  activeColor: Colors.indigo,
                                  onChanged: (v) =>
                                      setState(() => _jenisKelamin = v!),
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                              Expanded(
                                child: RadioListTile<String>(
                                  title: const Text('Perempuan'),
                                  value: 'P',
                                  groupValue: _jenisKelamin,
                                  activeColor: Colors.indigo,
                                  onChanged: (v) =>
                                      setState(() => _jenisKelamin = v!),
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    _buildCard([
                      _buildField(_kelasController, 'Kelas', Icons.class_,
                          validator: (v) => v!.isEmpty ? 'Kelas wajib diisi' : null),
                      _buildField(_jurusanController, 'Jurusan', Icons.school,
                          validator: (v) => v!.isEmpty ? 'Jurusan wajib diisi' : null),
                      _buildField(
                          _tahunMasukController, 'Tahun Masuk', Icons.calendar_today,
                          keyboardType: TextInputType.number,
                          validator: (v) {
                            if (v!.isEmpty) return 'Tahun masuk wajib diisi';
                            if (v.length != 4) return 'Masukkan 4 digit tahun';
                            return null;
                          }),
                      _buildField(_agamaController, 'Agama', Icons.mosque,
                          validator: (v) => v!.isEmpty ? 'Agama wajib diisi' : null),
                      _buildField(_alamatController, 'Alamat', Icons.location_on,
                          maxLines: 3,
                          validator: (v) => v!.isEmpty ? 'Alamat wajib diisi' : null),
                    ]),
                    const SizedBox(height: 12),

                    _buildCard([
                      _buildField(_linkIgController,
                          'Link Instagram (Opsional)', Icons.camera_alt),
                      _buildField(_linkLinkedinController,
                          'Link LinkedIn (Opsional)', Icons.work),
                    ]),
                    const SizedBox(height: 24),

                    // Tombol simpan
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo[800],
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 3,
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2)
                            : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.save),
                                  SizedBox(width: 8),
                                  Text('Simpan Mahasiswa',
                                      style: TextStyle(fontSize: 16)),
                                ],
                              ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(List<Widget> children) {
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
      padding: const EdgeInsets.all(16),
      child: Column(children: children),
    );
  }

  Widget _buildField(
    TextEditingController controller,
    String label,
    IconData icon, {
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.indigo[400]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.indigo[800]!, width: 2),
          ),
          filled: true,
          fillColor: Colors.grey[50],
        ),
      ),
    );
  }
}