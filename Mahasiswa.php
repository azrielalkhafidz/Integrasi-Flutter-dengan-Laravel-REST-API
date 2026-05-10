<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Mahasiswa extends Model
{
    use HasFactory;

    protected $table = 'mahasiswas';

    protected $fillable = [
        'nim',
        'nama',
        'jenis_kelamin',
        'kelas',
        'jurusan',
        'tahun_masuk',
        'agama',
        'alamat',
        'foto',
        'link_ig',
        'link_linkedin',
    ];

    // Otomatis ubah path foto jadi URL lengkap
    public function getFotoAttribute($value): ?string
    {
        if ($value) {
            return asset('storage/' . $value);
        }
        return null;
    }
}