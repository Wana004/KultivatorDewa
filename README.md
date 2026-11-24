# Kultivator Dewa — Pedang, Pil Restu Sekte, Pil Naik Ranah & Cermin Feng Shui

Mod (sebelumnya bernama NusaOP; ID item dan skrip internal sengaja tidak diubah agar tidak merusak save/kode) untuk Amazing Cultivation Simulator Mobile (target uji: game v1.2.0).
Status: **perlu diuji** di Android. Runtime test belum dilakukan.

## Isi
- **Pedang Pencabut Nyawa** (`Item_NusaOP_Sword`): turunan pedang bawaan, damage 99999, serangan diarahkan ke organ, jantung, dan otak (jenis luka `Destroy`), daya tahan sangat tinggi.
- **Pil Restu Sekte** (`Item_NusaOP_Dan_Favor`): saat ditukar ke sekte lewat trade, relasi sekte itu dinaikkan ke 2000 (nilai bisa diubah di `Scripts/NusaOP.lua`, variabel `TARGET_RELATION`). Jika dimakan, hanya memberi efek ringan 1 hari.
- Resep pil `Dan_NusaOP_Favor` (bahan: 25x `Item_MagicHerb`).
- **Pil Naik Ranah** (`Item_NusaOP_Dan_Realm`): hanya untuk murid sekte dalam (`DiscipleOnly`). Saat dimakan, murid langsung naik satu ranah (satu `Stage` pada kitabnya, misalnya Pembentukan Pil ke ranah berikutnya) tanpa melewati bottleneck. Jika murid belum punya kitab atau sudah di ranah tertinggi, muncul pesan dan pil tidak berefek. Resep `Dan_NusaOP_Realm` (bahan: 50x `Item_MagicHerb`, 20x `Item_LingStone`). Logikanya ada di `Scripts/modifier_nusaop_realm.lua`.
- **Cermin Bagua Pembalik Nasib** (`Item_NusaOP_FengShui`): relik feng shui (zhenwu) berbentuk barang dekorasi. Diletakkan di sebuah ruangan, nilai feng shui ruangan itu ditambah `AddV` = 500 (relik bawaan hanya 30), berlaku di ruangan jenis apa pun dan ukuran berapa pun (`RoomKind` None, `RoomLevel` 0). Penghuni ruangan mendapat modifier `SP_NusaOP_FSZhenWu`: tambahan nilai dasar keadaan batin +15, potensi +2, hukuman langit -25, dan kecepatan kerja +50%. Cermin juga memancarkan spiritual power seperti relik bawaan. Resep: 30x `Item_MagicHerb`, 20x `Item_LingStone`. Nilai `AddV` dan modifier bisa diubah di `Item_NusaOP.xml` dan `Modifier_NusaOP.xml`. `Scripts/NusaOP_FengShui.lua` membuat cermin langsung aktif tanpa sihir pembuka.

## Struktur
Info.json, Preview.png, Scripts/NusaOP.lua, Scripts/modifier_nusaop_realm.lua, Scripts/NusaOP_FengShui.lua, Settings/ThingDef/Item/Item_NusaOP.xml, Settings/Modifiers/Modifier_NusaOP.xml, Settings/Practice/DanFormula/Dan_NusaOP.xml

## Dependensi
Tidak ada.

## Pasang (lewat MOD Store di game)
1. Unggah SEMUA isi folder ini ke repositori GitHub baru (Info.json harus ada di akar repositori).
2. Di game: MOD Store, tombol di pojok kanan atas, masukkan alamat repositori Git, lalu aktifkan mod.
3. Uji di save baru atau salinan save.

## Skenario uji
1. Mod tampil dan bisa diaktifkan; game bisa mulai.
2. Item muncul (lewat spawner atau resep) dan nama tampil benar.
3. Pedang: equip pada murid, lawan satu musuh. Cek apakah satu serangan cukup mematikan.
4. Pil: catat relasi sebuah sekte, jual satu pil ke sekte itu lewat jendela trade, lalu cek relasinya. Kalau tidak berubah, kirim log (konsol PC: CTRL+F) berisi baris "[NusaOP]".
5. Simpan lalu muat ulang save; pastikan tetap bisa dimuat.
6. Pil Naik Ranah: pakai pada murid sekte dalam yang punya kitab. Catat ranahnya (lihat panel murid), beri murid makan pil, lalu cek ranah baru dan pesan "menembus ranah". Cek juga bahwa murid tetap sehat dan bisa berkultivasi normal. Coba lagi pada murid di ranah tertinggi (harus muncul pesan penolakan), pada murid luar (pil harus ditolak game), lalu simpan dan muat ulang untuk memastikan efek tidak terpicu dua kali. Kalau tidak ada efek, kirim log berisi baris "[NusaOP]".

7. Cermin Feng Shui: pilih satu ruangan yang feng shui-nya jelek (buka panel feng shui ruangan), catat tingkatnya, lalu letakkan cermin di dalamnya. Cek apakah tingkatnya naik (Best = 大吉) dan apakah penghuni mendapat modifier. Cek juga bahwa cermin bisa dibuat lewat resep atau muncul lewat spawner, dan bahwa save tetap bisa dimuat. Kalau tidak berefek, kirim log berisi baris "[NusaOP]".

## Batas yang belum terverifikasi
- Cermin Feng Shui: skala nilai feng shui dan batas tiap tingkat (Best sampai Worst) tidak ada di data konfigurasi (di kode game), jadi belum diketahui apakah 500 cukup untuk mengangkat ruangan terburuk ke Best. Naikkan `AddV` kalau kurang.
- Cermin memakai induk `ItemBase`, bukan `FengShuiItemBase` (terkunci DLC ShangGuJuShou), dengan field disalin dari relik bawaan. Belum diuji bahwa game mengenalinya sebagai relik.
- Skrip mengubah `FSItemState` menjadi 2 (sudah dibuka). Belum diuji bahwa itu cukup agar relik aktif, dan nilai awal status untuk item baru belum diketahui.
- Resep `BeMade` pada cermin belum dipastikan muncul di meja kerja mana pun. Kalau tidak muncul, pakai spawner atau tambahkan ke pool dagang.
- Efek trade bergantung pada asumsi bahwa stok pil di data sekte bertambah saat dijual. Belum diuji.
- Batas maksimum relasi sekte belum terdokumentasi; 2000 dipilih karena kondisi bawaan game memakai ambang hingga 1200.
- Penggabungan `<Equip>` pada pedang turunan mengikuti pola item bawaan, tapi belum diuji untuk `Damage`.

- Pil Naik Ranah memanggil `Practice:UpgradeStage(false, false)`. Nama method dan parameternya terverifikasi di APIDoc resmi dan di dump game v1.2.0, tetapi APIDoc tidak menjelaskan apa persisnya yang dilakukan (naik satu `Stage`, penyesuaian nilai tahap, event). Belum diuji di perangkat.
- Bila ranah berikutnya biasanya menuntut tribulasi, efek sampingnya (misalnya cloud petir atau luka) pada jalur ini belum diketahui.
- Skrip memakai `modifier:Kill()` agar pil tidak terpicu ulang setelah load. Belum diuji bahwa `Enter` tidak terpanggil ulang untuk modifier tersimpan.

## Nonaktif / hapus
Matikan mod di MOD Store. Item dari mod yang sudah ada di save bisa memicu masalah saat dimuat tanpa mod, jadi sebaiknya buang item itu dari inventori sebelum menonaktifkan.
