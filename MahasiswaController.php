<?php

namespace App\Http\Controllers;

use App\Models\Mahasiswa;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Validator;
use OpenApi\Attributes as OA;

#[OA\Info(
    title: "Mahasiswa API",
    version: "1.0.0",
    description: "Dokumentasi API Mahasiswa"
)]
#[OA\Server(
    url: "http://localhost:8000/api",
    description: "Local API Server"
)]
class MahasiswaController extends Controller
{
    /**
     * @OA\Get(
     *     path="/api/mahasiswa",
     *     tags={"Mahasiswa"},
     *     summary="Ambil semua data mahasiswa",
     *     @OA\Response(
     *         response=200,
     *         description="Berhasil"
     *     )
     * )
     */
    #[OA\Get(
        path: "/mahasiswa",
        summary: "Ambil semua data mahasiswa",
        tags: ["Mahasiswa"],
        responses: [
            new OA\Response(
                response: 200,
                description: "Berhasil"
            )
        ]
    )]
    public function index(): JsonResponse
    {
        $mahasiswas = Mahasiswa::latest()->get();

        return response()->json([
            'status'  => true,
            'message' => 'Data Mahasiswa',
            'data'    => $mahasiswas,
        ], 200);
    }

    /**
     * @OA\Post(
     *     path="/api/mahasiswa",
     *     tags={"Mahasiswa"},
     *     summary="Tambah mahasiswa baru",
     *     @OA\RequestBody(
     *         required=true,
     *         @OA\MediaType(
     *             mediaType="multipart/form-data",
     *             @OA\Schema(
     *                 required={"nim","nama","jenis_kelamin","kelas","jurusan","tahun_masuk","agama","alamat"},
     *                 @OA\Property(property="nim", type="string"),
     *                 @OA\Property(property="nama", type="string"),
     *                 @OA\Property(property="jenis_kelamin", type="string", enum={"L","P"}),
     *                 @OA\Property(property="kelas", type="string"),
     *                 @OA\Property(property="jurusan", type="string"),
     *                 @OA\Property(property="tahun_masuk", type="integer"),
     *                 @OA\Property(property="agama", type="string"),
     *                 @OA\Property(property="alamat", type="string"),
     *                 @OA\Property(property="foto", type="string", format="binary"),
     *                 @OA\Property(property="link_ig", type="string"),
     *                 @OA\Property(property="link_linkedin", type="string")
     *             )
     *         )
     *     ),
     *     @OA\Response(response=201, description="Berhasil ditambahkan"),
     *     @OA\Response(response=422, description="Validasi gagal")
     * )
     */
    #[OA\Post(
        path: "/mahasiswa",
        summary: "Tambah mahasiswa baru",
        tags: ["Mahasiswa"],
        requestBody: new OA\RequestBody(
            required: true,
            content: new OA\MediaType(
                mediaType: "multipart/form-data",
                schema: new OA\Schema(
                    required: ["nim", "nama", "jenis_kelamin", "kelas", "jurusan", "tahun_masuk", "agama", "alamat"],
                    properties: [
                        new OA\Property(property: "nim", type: "string"),
                        new OA\Property(property: "nama", type: "string"),
                        new OA\Property(property: "jenis_kelamin", type: "string", enum: ["L", "P"]),
                        new OA\Property(property: "kelas", type: "string"),
                        new OA\Property(property: "jurusan", type: "string"),
                        new OA\Property(property: "tahun_masuk", type: "integer"),
                        new OA\Property(property: "agama", type: "string"),
                        new OA\Property(property: "alamat", type: "string"),
                        new OA\Property(property: "foto", type: "string", format: "binary"),
                        new OA\Property(property: "link_ig", type: "string"),
                        new OA\Property(property: "link_linkedin", type: "string")
                    ]
                )
            )
        ),
        responses: [
            new OA\Response(response: 201, description: "Berhasil ditambahkan"),
            new OA\Response(response: 422, description: "Validasi gagal")
        ]
    )]
    public function store(Request $request): JsonResponse
    {
        $validator = Validator::make($request->all(), [
            'nim'           => 'required|string|max:20|unique:mahasiswas,nim',
            'nama'          => 'required|string|max:100',
            'jenis_kelamin' => 'required|in:L,P',
            'kelas'         => 'required|string|max:10',
            'jurusan'       => 'required|string|max:100',
            'tahun_masuk'   => 'required|digits:4',
            'agama'         => 'required|string|max:20',
            'alamat'        => 'required|string',
            'foto'          => 'nullable|image|mimes:jpg,jpeg,png|max:2048',
            'link_ig'       => 'nullable|url',
            'link_linkedin' => 'nullable|url',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status'  => false,
                'message' => 'Validasi gagal',
                'errors'  => $validator->errors(),
            ], 422);
        }

        $data = $request->except('foto');

        if ($request->hasFile('foto')) {
            $data['foto'] = $request->file('foto')->store('fotos', 'public');
        }

        $mahasiswa = Mahasiswa::create($data);

        return response()->json([
            'status'  => true,
            'message' => 'Mahasiswa berhasil ditambahkan',
            'data'    => $mahasiswa,
        ], 201);
    }

    /**
     * @OA\Get(
     *     path="/api/mahasiswa/{id}",
     *     tags={"Mahasiswa"},
     *     summary="Ambil detail mahasiswa",
     *     @OA\Parameter(
     *         name="id",
     *         in="path",
     *         required=true,
     *         @OA\Schema(type="integer")
     *     ),
     *     @OA\Response(response=200, description="Berhasil"),
     *     @OA\Response(response=404, description="Tidak ditemukan")
     * )
     */
    #[OA\Get(
        path: "/mahasiswa/{id}",
        summary: "Ambil detail mahasiswa",
        tags: ["Mahasiswa"],
        parameters: [
            new OA\Parameter(name: "id", description: "ID Mahasiswa", in: "path", required: true, schema: new OA\Schema(type: "integer"))
        ],
        responses: [
            new OA\Response(response: 200, description: "Berhasil"),
            new OA\Response(response: 404, description: "Tidak ditemukan")
        ]
    )]
    public function show(string $id): JsonResponse
    {
        $mahasiswa = Mahasiswa::find($id);

        if (!$mahasiswa) {
            return response()->json([
                'status'  => false,
                'message' => 'Mahasiswa tidak ditemukan',
                'data'    => null,
            ], 404);
        }

        return response()->json([
            'status'  => true,
            'message' => 'Detail Mahasiswa',
            'data'    => $mahasiswa,
        ], 200);
    }

    /**
     * @OA\Post(
     *     path="/api/mahasiswa/{id}",
     *     tags={"Mahasiswa"},
     *     summary="Update mahasiswa",
     *     @OA\Parameter(
     *         name="id",
     *         in="path",
     *         required=true,
     *         @OA\Schema(type="integer")
     *     ),
     *     @OA\RequestBody(
     *         @OA\MediaType(
     *             mediaType="multipart/form-data",
     *             @OA\Schema(
     *                 @OA\Property(property="_method", type="string", example="PUT"),
     *                 @OA\Property(property="nama", type="string"),
     *                 @OA\Property(property="kelas", type="string")
     *             )
     *         )
     *     ),
     *     @OA\Response(response=200, description="Berhasil diupdate"),
     *     @OA\Response(response=404, description="Tidak ditemukan")
     * )
     */
    #[OA\Put(
        path: "/mahasiswa/{id}",
        summary: "Update mahasiswa",
        tags: ["Mahasiswa"],
        parameters: [
            new OA\Parameter(name: "id", description: "ID Mahasiswa", in: "path", required: true, schema: new OA\Schema(type: "integer"))
        ],
        requestBody: new OA\RequestBody(
            content: new OA\MediaType(
                mediaType: "multipart/form-data",
                schema: new OA\Schema(
                    properties: [
                        new OA\Property(property: "nama", type: "string"),
                        new OA\Property(property: "kelas", type: "string")
                    ]
                )
            )
        ),
        responses: [
            new OA\Response(response: 200, description: "Berhasil diupdate"),
            new OA\Response(response: 404, description: "Tidak ditemukan")
        ]
    )]
    #[OA\Post(
        path: "/mahasiswa/{id}",
        summary: "Update mahasiswa (alternate)",
        tags: ["Mahasiswa"],
        parameters: [
            new OA\Parameter(name: "id", description: "ID Mahasiswa", in: "path", required: true, schema: new OA\Schema(type: "integer"))
        ],
        responses: [
            new OA\Response(response: 200, description: "Berhasil diupdate"),
            new OA\Response(response: 404, description: "Tidak ditemukan")
        ]
    )]
    public function update(Request $request, string $id): JsonResponse
    {
        $mahasiswa = Mahasiswa::find($id);

        if (!$mahasiswa) {
            return response()->json([
                'status'  => false,
                'message' => 'Mahasiswa tidak ditemukan',
                'data'    => null,
            ], 404);
        }

        $validator = Validator::make($request->all(), [
            'nim'           => 'sometimes|required|string|max:20|unique:mahasiswas,nim,' . $id,
            'nama'          => 'sometimes|required|string|max:100',
            'jenis_kelamin' => 'sometimes|required|in:L,P',
            'kelas'         => 'sometimes|required|string|max:10',
            'jurusan'       => 'sometimes|required|string|max:100',
            'tahun_masuk'   => 'sometimes|required|digits:4',
            'agama'         => 'sometimes|required|string|max:20',
            'alamat'        => 'sometimes|required|string',
            'foto'          => 'nullable|image|mimes:jpg,jpeg,png|max:2048',
            'link_ig'       => 'nullable|url',
            'link_linkedin' => 'nullable|url',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status'  => false,
                'message' => 'Validasi gagal',
                'errors'  => $validator->errors(),
            ], 422);
        }

        $data = $request->except('foto');

        if ($request->hasFile('foto')) {
            $fotoLama = $mahasiswa->getRawOriginal('foto');
            if ($fotoLama) {
                Storage::disk('public')->delete($fotoLama);
            }
            $data['foto'] = $request->file('foto')->store('fotos', 'public');
        }

        $mahasiswa->update($data);

        return response()->json([
            'status'  => true,
            'message' => 'Mahasiswa berhasil diupdate',
            'data'    => $mahasiswa->fresh(),
        ], 200);
    }

    /**
     * @OA\Delete(
     *     path="/api/mahasiswa/{id}",
     *     tags={"Mahasiswa"},
     *     summary="Hapus mahasiswa",
     *     @OA\Parameter(
     *         name="id",
     *         in="path",
     *         required=true,
     *         @OA\Schema(type="integer")
     *     ),
     *     @OA\Response(response=200, description="Berhasil dihapus"),
     *     @OA\Response(response=404, description="Tidak ditemukan")
     * )
     */
    #[OA\Delete(
        path: "/mahasiswa/{id}",
        summary: "Hapus mahasiswa",
        tags: ["Mahasiswa"],
        parameters: [
            new OA\Parameter(name: "id", description: "ID Mahasiswa", in: "path", required: true, schema: new OA\Schema(type: "integer"))
        ],
        responses: [
            new OA\Response(response: 200, description: "Berhasil dihapus"),
            new OA\Response(response: 404, description: "Tidak ditemukan")
        ]
    )]
    public function destroy(string $id): JsonResponse
    {
        $mahasiswa = Mahasiswa::find($id);

        if (!$mahasiswa) {
            return response()->json([
                'status'  => false,
                'message' => 'Mahasiswa tidak ditemukan',
                'data'    => null,
            ], 404);
        }

        $fotoLama = $mahasiswa->getRawOriginal('foto');
        if ($fotoLama) {
            Storage::disk('public')->delete($fotoLama);
        }

        $mahasiswa->delete();

        return response()->json([
            'status'  => true,
            'message' => 'Mahasiswa berhasil dihapus',
            'data'    => null,
        ], 200);
    }
}