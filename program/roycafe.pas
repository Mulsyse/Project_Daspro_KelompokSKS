program SistemPemesananRoyCafe;
uses crt;

var
  { Array Data Menu & Pesanan }
  namaMenu      : array[1..20] of string;
  hargaMenu     : array[1..20] of LongInt;
  jumlahPesanan : array[1..20] of integer;

  { Variabel Operasional }
  pilihan, jumlah, pilihanAkhir, i : integer;
  harga, subtotal, total, bayar, kembalian : LongInt;
  pesanError : string;
  pesanLagi  : char;

  { Variabel Kontrol Alur (Boolean) }
  ulangSistem, transaksiSelesai, selesaiPesanItem, adaError : boolean;

{ Prosedur Header Utama }
procedure TampilkanHeader(judul : string);
begin
  writeln('===========================================================================');
  writeln('                          ', judul);
  writeln('===========================================================================');
end;

{ Prosedur Inisialisasi Data Menu (10 Makanan & 10 Minuman) }
procedure InisialisasiDataMenu;
begin
  { --- KATEGORI MAKANAN (1 - 10) --- }
  namaMenu[1]  := 'Chicken Steak';       hargaMenu[1]  := 35000;
  namaMenu[2]  := 'Beef Burger';          hargaMenu[2]  := 32000;
  namaMenu[3]  := 'Chicken Burger';       hargaMenu[3]  := 28000;
  namaMenu[4]  := 'Spaghetti Bolognese';  hargaMenu[4]  := 30000;
  namaMenu[5]  := 'Carbonara Pasta';      hargaMenu[5]  := 32000;
  namaMenu[6]  := 'Chicken Katsu Rice';   hargaMenu[6]  := 28000;
  namaMenu[7]  := 'Beef Teriyaki Rice';   hargaMenu[7]  := 30000;
  namaMenu[8]  := 'Chicken Wings';        hargaMenu[8]  := 25000;
  namaMenu[9]  := 'French Fries';         hargaMenu[9]  := 18000;
  namaMenu[10] := 'Fish & Chips';         hargaMenu[10] := 35000;

  { --- KATEGORI MINUMAN (11 - 20) --- }
  namaMenu[11] := 'Ice Americano';        hargaMenu[11] := 18000;
  namaMenu[12] := 'Cafe Latte';           hargaMenu[12] := 22000;
  namaMenu[13] := 'Cappuccino';           hargaMenu[13] := 22000;
  namaMenu[14] := 'Caramel Macchiato';    hargaMenu[14] := 25000;
  namaMenu[15] := 'Matcha Latte';         hargaMenu[15] := 24000;
  namaMenu[16] := 'Chocolate Frappe';     hargaMenu[16] := 25000;
  namaMenu[17] := 'Strawberry Smoothie';  hargaMenu[17] := 23000;
  namaMenu[18] := 'Iced Lemon Tea';       hargaMenu[18] := 15000;
  namaMenu[19] := 'Fresh Orange Juice';   hargaMenu[19] := 18000;
  namaMenu[20] := 'Mineral Water';        hargaMenu[20] :=  7000;
end;

begin
  ClrScr;
  InisialisasiDataMenu; 
  ulangSistem := true;

  while ulangSistem do
  begin
    { Reset Keranjang Pesanan Saat Sesi Baru }
    for i := 1 to 20 do
      jumlahPesanan[i] := 0;

    transaksiSelesai := false;

    repeat

      { --------------------------------------------------- }
      { FASE 1: PEMILIHAN ITEM DAN JUMLAH PESANAN           }
      { --------------------------------------------------- }
      selesaiPesanItem := false;
      repeat
        
        { 1. Pilih Menu (Dipisah Makanan & Minuman) }
        adaError := false;
        repeat
          ClrScr;
          TampilkanHeader('DAFTAR MENU ROY CAFE');
          
          { Judul Kecil Kategori }
          writeln('        --- MAKANAN ---                         --- MINUMAN ---');
          writeln('---------------------------------------------------------------------------');

          { Cetak Menu berdampingan dengan jarak spasi 22 karakter }
          for i := 1 to 10 do
          begin
            writeln(i:2, '. ', namaMenu[i], ' ': (22 - length(namaMenu[i])), 
                    'Rp', hargaMenu[i]:6, '   |   ', 
                    (i+10):2, '. ', namaMenu[i+10], ' ': (22 - length(namaMenu[i+10])), 
                    'Rp', hargaMenu[i+10]:6);
          end;
          
          writeln('---------------------------------------------------------------------------');

          if adaError then
          begin
            writeln('>> ERROR: ', pesanError);
            writeln('---------------------------------------------------------------------------');
          end;

          write('Pilih nomor menu (1-20): ');
          {$I-} readln(pilihan); {$I+}

          if IOResult <> 0 then
          begin
            adaError := true;
            pesanError := 'Input tidak valid! Harap masukkan angka 1-20, bukan huruf/simbol.';
          end
          else if (pilihan < 1) or (pilihan > 20) then
          begin
            adaError := true;
            pesanError := 'Pilihan menu tidak valid! Silakan pilih nomor 1-20.';
          end
          else
            adaError := false;

        until not adaError;

        { 2. Input Jumlah Pesanan }
        adaError := false;
        repeat
          ClrScr;
          TampilkanHeader('INPUT JUMLAH PESANAN');
          writeln('Menu Dipilih : ', namaMenu[pilihan]);
          writeln('Harga Satuan : Rp', hargaMenu[pilihan]);
          writeln('---------------------------------------------------------------------------');

          if adaError then
          begin
            writeln('>> ERROR: ', pesanError);
            writeln('---------------------------------------------------------------------------');
          end;

          write('Masukkan jumlah pesanan: ');
          {$I-} readln(jumlah); {$I+}

          if IOResult <> 0 then
          begin
            adaError := true;
            pesanError := 'Input tidak valid! Harap masukkan angka, bukan huruf/simbol.';
          end
          else if jumlah <= 0 then
          begin
            adaError := true;
            pesanError := 'Jumlah pesanan harus berupa angka lebih dari 0!';
          end 
          else
            adaError := false;

        until not adaError;

        { Simpan Pesanan }
        jumlahPesanan[pilihan] := jumlahPesanan[pilihan] + jumlah;
        subtotal := hargaMenu[pilihan] * jumlah;

        { 3. Konfirmasi Tambah Item Lagi (Y/T) }
        adaError := false;
        repeat
          ClrScr;
          TampilkanHeader('STATUS PESANAN');
          writeln('>> Berhasil menambahkan ', namaMenu[pilihan], ' (Qty: ', jumlah, ')');
          writeln('>> Subtotal Item: Rp', subtotal);
          writeln('---------------------------------------------------------------------------');

          if adaError then
          begin
            writeln('>> ERROR: ', pesanError);
            writeln('---------------------------------------------------------------------------');
          end;

          write('Apakah ingin menambah item menu lain? (Y/T): ');
          readln(pesanLagi);

          if (pesanLagi <> 'Y') and (pesanLagi <> 'y') and 
             (pesanLagi <> 'T') and (pesanLagi <> 't') then
          begin
            adaError := true;
            pesanError := 'Pilihan tidak valid! Masukkan huruf Y atau T.';
          end
          else
            adaError := false;

        until not adaError;

        if (pesanLagi = 'T') or (pesanLagi = 't') then
          selesaiPesanItem := true;

      until selesaiPesanItem;

      { --------------------------------------------------- }
      { FASE 2: RINGKASAN PESANAN & NAVIGASI AKHIR          }
      { --------------------------------------------------- }
      adaError := false;
      repeat
        ClrScr;
        TampilkanHeader('RINGKASAN PESANAN');
        writeln('No.  Nama Menu                  Harga    Qty   Subtotal');
        writeln('---------------------------------------------------------------------------');

        total := 0;
        pilihan := 0;

        for i := 1 to 20 do
        begin
          if jumlahPesanan[i] > 0 then
          begin
            pilihan := pilihan + 1;
            subtotal := hargaMenu[i] * jumlahPesanan[i];
            total := total + subtotal;
            writeln(pilihan:2, '.  ', namaMenu[i], ' ': (25 - length(namaMenu[i])), 
                    'Rp', hargaMenu[i]:5, ' ', jumlahPesanan[i]:4, '   Rp', subtotal);
          end;
        end;

        writeln('---------------------------------------------------------------------------');
        writeln('Total Harga : Rp', total);
        writeln;
        writeln('Menu Pilihan Akhir:');
        writeln('1. Pesan lagi');
        writeln('2. Lanjut ke pembayaran');
        writeln('3. Keluar');
        writeln('---------------------------------------------------------------------------');

        if adaError then
        begin
          writeln('>> ERROR: ', pesanError);
          writeln('---------------------------------------------------------------------------');
        end;

        write('Pilih menu (1-3): ');
        {$I-} readln(pilihanAkhir); {$I+}

        if IOResult <> 0 then
        begin
          adaError := true;
          pesanError := 'Input tidak valid! Harap masukkan angka 1, 2, atau 3.';
        end
        else if (pilihanAkhir < 1) or (pilihanAkhir > 3) then
        begin
          adaError := true;
          pesanError := 'Pilihan tidak valid! Pilih nomor 1, 2, atau 3.';
        end
        else
          adaError := false;

      until not adaError;

      { --------------------------------------------------- }
      { FASE 3: EKSEKUSI NAVIGASI AKHIR                      }
      { --------------------------------------------------- }
      if pilihanAkhir = 1 then
      begin
        transaksiSelesai := false;
      end
      else if pilihanAkhir = 2 then
      begin
        { Lanjut ke Pembayaran }
        adaError := false;
        repeat
          ClrScr;
          TampilkanHeader('PEMBAYARAN');
          writeln('Total Tagihan : Rp', total);
          writeln('---------------------------------------------------------------------------');

          if adaError then
          begin
            writeln('>> ERROR: ', pesanError);
            writeln('---------------------------------------------------------------------------');
          end;

          write('Uang Bayar    : Rp');
          {$I-} readln(bayar); {$I+}

          if IOResult <> 0 then
          begin
            adaError := true;
            pesanError := 'Input tidak valid! Harap masukkan nominal angka yang benar.';
          end
          else if bayar < total then
          begin
            adaError := true;
            pesanError := 'Uang pembayaran kurang dari total tagihan!';
          end
          else
            adaError := false;

        until not adaError;

        kembalian := bayar - total;

        ClrScr;
        TampilkanHeader('STRUK PEMBAYARAN');
        writeln('Total Tagihan : Rp', total);
        writeln('Uang Bayar    : Rp', bayar);
        writeln('Kembalian     : Rp', kembalian);
        writeln('---------------------------------------------------------------------------');
        writeln('Status        : LUNAS');
        writeln;
        writeln('Terima kasih telah berbelanja di ROY CAFE!');
        writeln('===========================================================================');
        writeln('Tekan Enter untuk keluar...');
        readln;

        transaksiSelesai := true;
        ulangSistem := false;
      end;
      if pilihanAkhir = 3 then
      begin
        ClrScr;
        TampilkanHeader('ROY CAFE');
        writeln('Terima kasih telah berkunjung ke ROY CAFE!');
        writeln('===========================================================================');
        writeln('Tekan Enter untuk keluar...');
        readln;

        transaksiSelesai := true;
        ulangSistem := false;
      end;

    until transaksiSelesai;

  end;
end.