<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\MahasiswaController;

Route::get('/mahasiswa',         [MahasiswaController::class, 'index']);
Route::post('/mahasiswa',        [MahasiswaController::class, 'store']);
Route::get('/mahasiswa/{id}',    [MahasiswaController::class, 'show']);
Route::put('/mahasiswa/{id}',    [MahasiswaController::class, 'update']);
Route::post('/mahasiswa/{id}',   [MahasiswaController::class, 'update']);
Route::delete('/mahasiswa/{id}', [MahasiswaController::class, 'destroy']);