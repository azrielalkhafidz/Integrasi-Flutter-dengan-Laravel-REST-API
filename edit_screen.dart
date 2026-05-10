import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/mahasiswa.dart';
import '../services/api_service.dart';

class EditScreen extends StatefulWidget {
  final Mahasiswa mahasiswa;

  const EditScreen({super.key, required this.mahasiswa});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nimController;
  late TextEditingController _namaController;
  late TextEditingController _kelasController;
  late TextEditingController _jurusanController;
  late TextEditingController _tahunMasukController;
  late TextEditingController _agamaController;
  late TextEditingController _alamatController;
  late TextEditingController _linkIgController;
  late TextEditingController _linkLinkedinController;

  late String _jenisKelamin;
  File? _fotoFile;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final m = widget.mahasiswa;
    _nimController = TextEditingController(text: m.nim);
    _namaController = TextEditingController(text: m.nama);
    _kelasController = TextEditingController(text: m.kelas);
    _jurusanController = TextEditingController(text: m.jurusan);
    _tahunMasukController = TextEditingController(text: '${m.tahunMasuk}');
    _agamaController = TextEditingController(text: m.agama);
    _alamatController = TextEditingController(text: m.alamat);
    _linkIgController = TextEditingController(text: m.linkIg ?? '');
    _linkLinkedinController = TextEditingController(text: m.linkLinkedin ?? '');
    _jenisKelamin = m.jenisKelamin;
  }

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
      setState(() => _fotoFile = File(pickedFile.path));
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      await ApiService.updateMahasiswa(
        id: widget.mahasiswa.id,
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
        foto: _fotoFile,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('Data berhasil diupdate!'),
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
          'Edit Mahasiswa',
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
                        child: _fotoFile != null
                            ? Image.file(_fotoFile!, fit: BoxFit.cover)
                            : widget.mahasiswa.foto != null
                                ? Image.network(
                                    widget.mahasiswa.foto!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Center(
                                      child: Text(
                                        widget.mahasiswa.nama[0].toUpperCase(),
                                        style: const TextStyle(
                                          fontSize: 36,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  )
                                : Center(
                                    child: Text(
                                      widget.mahasiswa.nama[0].toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: 36,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: _pilihFoto,
                    icon: const Icon(Icons.camera_alt,
                        color: Colors.white70, size: 16),
                    label: const Text(
                      'Ganti Foto',
                      style: TextStyle(color: Colors.white70),
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
                      _buildField(_nimController, 'NIM', Icons.badge),
                      _buildField(_namaController, 'Nama Lengkap', Icons.person),
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
                      _buildField(_kelasController, 'Kelas', Icons.class_),
                      _buildField(_jurusanController, 'Jurusan', Icons.school),
                      _buildField(
                        _tahunMasukController, 'Tahun Masuk',
                        Icons.calendar_today,
                        keyboardType: TextInputType.number,
                      ),
                      _buildField(_agamaController, 'Agama', Icons.mosque),
                      _buildField(
                        _alamatController, 'Alamat', Icons.location_on,
                        maxLines: 3,
                      ),
                    ]),
                    const SizedBox(height: 12),

                    _buildCard([
                      _buildField(_linkIgController,
                          'Link Instagram (Opsional)', Icons.camera_alt),
                      _buildField(_linkLinkedinController,
                          'Link LinkedIn (Opsional)', Icons.work),
                    ]),
                    const SizedBox(height: 24),

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
                                  Text('Update Mahasiswa',
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
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        validator: (v) =>
            (v == null || v.isEmpty) ? '$label wajib diisi' : null,
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