import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const HarcamaApp());
}

// ── Veri Modeli ──────────────────────────────────────────────
class Harcama {
  final String aciklama;
  final double tutar;
  final String kisi;
  final String kategori;
  final String tarih;

  Harcama({
    required this.aciklama,
    required this.tutar,
    required this.kisi,
    required this.kategori,
    required this.tarih,
  });

  Map<String, dynamic> toJson() => {
    'aciklama': aciklama,
    'tutar': tutar,
    'kisi': kisi,
    'kategori': kategori,
    'tarih': tarih,
  };

  factory Harcama.fromJson(Map<String, dynamic> json) => Harcama(
    aciklama: json['aciklama'],
    tutar: (json['tutar'] as num).toDouble(),
    kisi: json['kisi'],
    kategori: json['kategori'],
    tarih: json['tarih'],
  );
}

// ── Kategori Bilgileri ────────────────────────────────────────
const Map<String, Map<String, dynamic>> kategoriler = {
  'ofis':    {'emoji': '🏢', 'label': 'Ofis',    'renk': Color(0xFF6C63FF)},
  'seyahat': {'emoji': '✈️', 'label': 'Seyahat', 'renk': Color(0xFF00D4AA)},
  'yemek':   {'emoji': '🍽️', 'label': 'Yemek',   'renk': Color(0xFFFFB347)},
  'yazilim': {'emoji': '💻', 'label': 'Yazılım', 'renk': Color(0xFFFF6B6B)},
  'ekipman': {'emoji': '🔧', 'label': 'Ekipman', 'renk': Color(0xFF4ECDC4)},
  'diger':   {'emoji': '📦', 'label': 'Diğer',   'renk': Color(0xFFA0A0B0)},
};

// ── Kullanıcılar ──────────────────────────────────────────────
const List<Map<String, String>> kullanicilar = [
  {'username': 'admin', 'password': '1234',     'name': 'Admin',        'initials': 'AD'},
  {'username': 'ahmet', 'password': 'ahmet123', 'name': 'Ahmet Yılmaz', 'initials': 'AY'},
  {'username': 'ayse',  'password': 'ayse123',  'name': 'Ayşe Kaya',    'initials': 'AK'},
];

// ── Renkler ───────────────────────────────────────────────────
const Color bgColor     = Color(0xFF0F1117);
const Color bg2Color    = Color(0xFF181B25);
const Color bg3Color    = Color(0xFF1E2130);
const Color accentColor = Color(0xFF6C63FF);
const Color mutedColor  = Color(0x72F0F0F8);
const Color redColor    = Color(0xFFFF6B6B);

// ═══════════════════════════════════════════════════════════════
// ANA UYGULAMA
// ═══════════════════════════════════════════════════════════════
class HarcamaApp extends StatelessWidget {
  const HarcamaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Harcama Takip',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: bgColor,
        colorScheme: const ColorScheme.dark(primary: accentColor),
      ),
      home: const LoginScreen(),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// GİRİŞ EKRANI
// ═══════════════════════════════════════════════════════════════
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _userCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _hata = false;
  bool _passGizli = true;

  void _girisYap() {
    final u = _userCtrl.text.trim();
    final p = _passCtrl.text;
    final kullanici = kullanicilar.where(
      (k) => k['username'] == u && k['password'] == p,
    ).firstOrNull;

    if (kullanici == null) {
      setState(() => _hata = true);
      _passCtrl.clear();
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => HomeScreen(kullanici: kullanici)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Container(
                width: 56, height: 56,
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Center(child: Text('💼', style: TextStyle(fontSize: 28))),
              ),
              const SizedBox(height: 28),
              const Text('Hoş Geldiniz',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: Colors.white)),
              const SizedBox(height: 6),
              const Text('Harcama takip sistemine giriş yapın',
                style: TextStyle(fontSize: 14, color: mutedColor)),
              const SizedBox(height: 36),

              if (_hata) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: redColor.withOpacity(0.12),
                    border: Border.all(color: redColor.withOpacity(0.35)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text('Kullanıcı adı veya şifre hatalı.',
                    style: TextStyle(color: redColor, fontSize: 13)),
                ),
                const SizedBox(height: 16),
              ],

              _label('Kullanıcı Adı'),
              const SizedBox(height: 8),
              _input(controller: _userCtrl, hint: 'kullanici_adi', icon: Icons.person_outline,
                onSubmit: (_) => FocusScope.of(context).nextFocus()),
              const SizedBox(height: 16),

              _label('Şifre'),
              const SizedBox(height: 8),
              _inputPass(),
              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _girisYap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Giriş Yap',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 20),

              Center(
                child: RichText(
                  text: const TextSpan(
                    style: TextStyle(fontSize: 12, color: mutedColor),
                    children: [
                      TextSpan(text: 'Demo: '),
                      TextSpan(text: 'admin', style: TextStyle(color: accentColor)),
                      TextSpan(text: ' / '),
                      TextSpan(text: '1234', style: TextStyle(color: accentColor)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Text(text,
    style: const TextStyle(fontSize: 12, color: mutedColor, letterSpacing: 0.05, fontWeight: FontWeight.w500));

  Widget _input({required TextEditingController controller, required String hint,
      required IconData icon, Function(String)? onSubmit}) {
    return TextField(
      controller: controller,
      onSubmitted: onSubmit,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint, hintStyle: const TextStyle(color: mutedColor),
        prefixIcon: Icon(icon, color: mutedColor, size: 20),
        filled: true, fillColor: bg2Color,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0x12FFFFFF))),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0x12FFFFFF))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: accentColor)),
      ),
    );
  }

  Widget _inputPass() {
    return TextField(
      controller: _passCtrl,
      obscureText: _passGizli,
      onSubmitted: (_) => _girisYap(),
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        hintText: '••••••••', hintStyle: const TextStyle(color: mutedColor),
        prefixIcon: const Icon(Icons.lock_outline, color: mutedColor, size: 20),
        suffixIcon: IconButton(
          icon: Icon(_passGizli ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            color: mutedColor, size: 20),
          onPressed: () => setState(() => _passGizli = !_passGizli),
        ),
        filled: true, fillColor: bg2Color,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0x12FFFFFF))),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0x12FFFFFF))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: accentColor)),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// ANA SAYFA
// ═══════════════════════════════════════════════════════════════
class HomeScreen extends StatefulWidget {
  final Map<String, String> kullanici;
  const HomeScreen({super.key, required this.kullanici});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Harcama> _harcamalar = [];
  String _filtre = 'tumu';
  final double _butce = 50000;

  @override
  void initState() {
    super.initState();
    _yukle();
  }

  // ── Kaydet / Yükle ───────────────────────────────────────────
  Future<void> _yukle() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString('harcamalar');
    if (jsonStr != null) {
      final List decoded = jsonDecode(jsonStr);
      setState(() {
        _harcamalar = decoded.map((e) => Harcama.fromJson(e)).toList();
      });
    }
  }

  Future<void> _kaydet() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = jsonEncode(_harcamalar.map((h) => h.toJson()).toList());
    await prefs.setString('harcamalar', jsonStr);
  }

  double get _toplam => _harcamalar.fold(0, (s, h) => s + h.tutar);

  List<Harcama> get _filtreliHarcamalar => _filtre == 'tumu'
      ? _harcamalar
      : _harcamalar.where((h) => h.kategori == _filtre).toList();

  void _cikisYap() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: bg2Color,
        title: const Text('Çıkış Yap', style: TextStyle(color: Colors.white)),
        content: const Text('Çıkış yapmak istiyor musunuz?', style: TextStyle(color: mutedColor)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('İptal')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (_) => const LoginScreen()));
            },
            child: const Text('Çıkış Yap', style: TextStyle(color: redColor)),
          ),
        ],
      ),
    );
  }

  void _harcamaEkle() async {
    final yeni = await showModalBottomSheet<Harcama>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const HarcamaEkleSheet(),
    );
    if (yeni != null) {
      setState(() => _harcamalar.add(yeni));
      _kaydet();
    }
  }

  void _temizle() {
    if (_harcamalar.isEmpty) return;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: bg2Color,
        title: const Text('Temizle', style: TextStyle(color: Colors.white)),
        content: const Text('Tüm harcamalar silinsin mi?', style: TextStyle(color: mutedColor)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('İptal')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => _harcamalar.clear());
              _kaydet();
            },
            child: const Text('Sil', style: TextStyle(color: redColor)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ofisT = _harcamalar.where((h) => h.kategori == 'ofis').fold(0.0, (s, h) => s + h.tutar);
    final seyahatT = _harcamalar.where((h) => h.kategori == 'seyahat').fold(0.0, (s, h) => s + h.tutar);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  // Top bar
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text('Şirket Hesabı',
                            style: TextStyle(fontSize: 12, color: mutedColor, letterSpacing: 0.06)),
                          Text('Acme Teknoloji A.Ş.',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                        ]),
                        GestureDetector(
                          onTap: _cikisYap,
                          child: CircleAvatar(
                            radius: 18, backgroundColor: accentColor,
                            child: Text(widget.kullanici['initials']!,
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Balance card
                  Container(
                    margin: const EdgeInsets.all(20),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6C63FF), Color(0xFF4ECDC4)],
                        begin: Alignment.topLeft, end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Text('Bu Ay Toplam Harcama',
                        style: TextStyle(fontSize: 12, color: Colors.white70, letterSpacing: 0.05)),
                      const SizedBox(height: 8),
                      Text('₺${_fmt(_toplam)}',
                        style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w500,
                          color: Colors.white, letterSpacing: -1)),
                      const SizedBox(height: 4),
                      const Text('Haziran 2026',
                        style: TextStyle(fontSize: 12, color: Colors.white70)),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _balanceStat('Bütçe', '₺${_fmt(_butce)}'),
                          _balanceStat('İşlem', '${_harcamalar.length} adet'),
                          _balanceStat('Kalan', '₺${_fmt((_butce - _toplam).clamp(0, _butce))}'),
                        ],
                      ),
                    ]),
                  ),

                  // Quick stats
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(children: [
                      Expanded(child: _statKart('🏢', 'Ofis Giderleri', ofisT)),
                      const SizedBox(width: 12),
                      Expanded(child: _statKart('✈️', 'Seyahat', seyahatT)),
                    ]),
                  ),

                  // Section header
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Son Harcamalar',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)),
                        GestureDetector(
                          onTap: _temizle,
                          child: const Text('Temizle',
                            style: TextStyle(fontSize: 13, color: accentColor)),
                        ),
                      ],
                    ),
                  ),

                  // Filter pills
                  SizedBox(
                    height: 38,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      children: [
                        _pill('tumu', 'Tümü'),
                        _pill('ofis', '🏢 Ofis'),
                        _pill('seyahat', '✈️ Seyahat'),
                        _pill('yemek', '🍽️ Yemek'),
                        _pill('yazilim', '💻 Yazılım'),
                        _pill('diger', '📦 Diğer'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Harcama listesi
                  if (_filtreliHarcamalar.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(30),
                      child: Center(
                        child: Text('Henüz harcama eklenmedi.\n+ butonuna basarak başlayın.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: mutedColor, fontSize: 14, height: 1.8)),
                      ),
                    )
                  else
                    ...(_filtreliHarcamalar.reversed.map((h) => _harcamaKart(h))),

                  const SizedBox(height: 20),
                ],
              ),
            ),

            // Bottom nav
            Container(
              decoration: const BoxDecoration(
                color: bg2Color,
                border: Border(top: BorderSide(color: Color(0x12FFFFFF))),
              ),
              padding: const EdgeInsets.only(top: 12, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _navItem(Icons.home_rounded, 'Ana Sayfa', true),
                  _navItem(Icons.bar_chart_rounded, 'Rapor', false),
                  GestureDetector(
                    onTap: _harcamaEkle,
                    child: Container(
                      width: 50, height: 50,
                      decoration: BoxDecoration(
                        color: accentColor, shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: accentColor.withOpacity(0.4), blurRadius: 12)],
                      ),
                      child: const Icon(Icons.add, color: Colors.white, size: 26),
                    ),
                  ),
                  _navItem(Icons.people_outline_rounded, 'Ekip', false),
                  _navItem(Icons.settings_outlined, 'Ayarlar', false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _balanceStat(String label, String val) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(fontSize: 11, color: Colors.white70)),
      const SizedBox(height: 2),
      Text(val, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white)),
    ],
  );

  Widget _statKart(String emoji, String label, double tutar) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: bg2Color,
      border: Border.all(color: const Color(0x12FFFFFF)),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(emoji, style: const TextStyle(fontSize: 20)),
      const SizedBox(height: 10),
      Text('₺${_fmt(tutar)}',
        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: Colors.white)),
      const SizedBox(height: 2),
      Text(label, style: const TextStyle(fontSize: 12, color: mutedColor)),
    ]),
  );

  Widget _pill(String key, String label) {
    final aktif = _filtre == key;
    return GestureDetector(
      onTap: () => setState(() => _filtre = key),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: aktif ? accentColor : bg2Color,
          border: Border.all(color: aktif ? accentColor : const Color(0x12FFFFFF)),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(label,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500,
            color: aktif ? Colors.white : mutedColor)),
      ),
    );
  }

  Widget _harcamaKart(Harcama h) {
    final kat = kategoriler[h.kategori] ?? kategoriler['diger']!;
    final renk = kat['renk'] as Color;
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bg2Color,
        border: Border.all(color: const Color(0x12FFFFFF)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(children: [
        Container(
          width: 40, height: 40,
          decoration: BoxDecoration(
            color: renk.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(child: Text(kat['emoji'], style: const TextStyle(fontSize: 18))),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(h.aciklama,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
            maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 2),
          Text('${h.kisi} · ${h.tarih}', style: const TextStyle(fontSize: 12, color: mutedColor)),
        ])),
        const SizedBox(width: 8),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text('-₺${_fmt(h.tutar)}',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: redColor)),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: renk.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(kat['label'],
              style: TextStyle(fontSize: 10, color: renk, fontWeight: FontWeight.w600)),
          ),
        ]),
      ]),
    );
  }

  Widget _navItem(IconData icon, String label, bool aktif) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 24, color: aktif ? accentColor : mutedColor),
      const SizedBox(height: 4),
      Text(label, style: TextStyle(fontSize: 10, color: aktif ? accentColor : mutedColor)),
    ],
  );

  String _fmt(double n) => n.toStringAsFixed(0).replaceAllMapped(
    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
}

// ═══════════════════════════════════════════════════════════════
// HARCAMA EKLEME BOTTOM SHEET
// ═══════════════════════════════════════════════════════════════
class HarcamaEkleSheet extends StatefulWidget {
  const HarcamaEkleSheet({super.key});

  @override
  State<HarcamaEkleSheet> createState() => _HarcamaEkleSheetState();
}

class _HarcamaEkleSheetState extends State<HarcamaEkleSheet> {
  final _aciklamaCtrl = TextEditingController();
  final _tutarCtrl    = TextEditingController();
  final _kisiCtrl     = TextEditingController();
  String _secilenKat  = 'ofis';
  bool _aciklamaHata  = false;
  bool _tutarHata     = false;

  void _kaydet() {
    final aciklama = _aciklamaCtrl.text.trim();
    final tutar    = double.tryParse(_tutarCtrl.text) ?? 0;
    setState(() {
      _aciklamaHata = aciklama.isEmpty;
      _tutarHata    = tutar <= 0;
    });
    if (_aciklamaHata || _tutarHata) return;

    final now  = DateTime.now();
    final tarih = '${now.day.toString().padLeft(2, '0')} ${_ayAdi(now.month)}';
    Navigator.pop(context, Harcama(
      aciklama: aciklama,
      tutar: tutar,
      kisi: _kisiCtrl.text.trim().isEmpty ? 'Belirtilmedi' : _kisiCtrl.text.trim(),
      kategori: _secilenKat,
      tarih: tarih,
    ));
  }

  String _ayAdi(int ay) {
    const aylar = ['', 'Oca', 'Şub', 'Mar', 'Nis', 'May', 'Haz',
      'Tem', 'Ağu', 'Eyl', 'Eki', 'Kas', 'Ara'];
    return aylar[ay];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: bg2Color,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(20, 0, 20,
        MediaQuery.of(context).viewInsets.bottom + 32),
      child: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 36, height: 4,
              decoration: BoxDecoration(
                color: const Color(0x12FFFFFF),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const Text('Harcama Ekle',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: Colors.white)),
          const SizedBox(height: 20),

          _formLabel('Açıklama'),
          const SizedBox(height: 8),
          _formInput(_aciklamaCtrl, 'Örn: AWS Sunucu Faturası', hata: _aciklamaHata),
          const SizedBox(height: 16),

          _formLabel('Tutar (₺)'),
          const SizedBox(height: 8),
          _formInput(_tutarCtrl, '0.00', keyboardType: TextInputType.number, hata: _tutarHata),
          const SizedBox(height: 16),

          _formLabel('Sorumlu Kişi'),
          const SizedBox(height: 8),
          _formInput(_kisiCtrl, 'Ad Soyad'),
          const SizedBox(height: 16),

          _formLabel('Kategori'),
          const SizedBox(height: 8),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 8, mainAxisSpacing: 8,
            childAspectRatio: 1.6,
            children: kategoriler.entries.map((e) {
              final aktif = _secilenKat == e.key;
              return GestureDetector(
                onTap: () => setState(() => _secilenKat = e.key),
                child: Container(
                  decoration: BoxDecoration(
                    color: aktif ? accentColor.withOpacity(0.15) : bg3Color,
                    border: Border.all(color: aktif ? accentColor : const Color(0x12FFFFFF)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(e.value['emoji'], style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 4),
                    Text(e.value['label'],
                      style: TextStyle(fontSize: 11,
                        color: aktif ? accentColor : mutedColor,
                        fontWeight: FontWeight.w500)),
                  ]),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _kaydet,
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Harcama Kaydet',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _formLabel(String text) => Text(text,
    style: const TextStyle(fontSize: 12, color: mutedColor, letterSpacing: 0.05, fontWeight: FontWeight.w500));

  Widget _formInput(TextEditingController ctrl, String hint,
      {TextInputType? keyboardType, bool hata = false}) {
    return TextField(
      controller: ctrl,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint, hintStyle: const TextStyle(color: mutedColor),
        filled: true, fillColor: bg3Color,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: hata ? redColor : const Color(0x12FFFFFF))),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: hata ? redColor : const Color(0x12FFFFFF))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: accentColor)),
      ),
    );
  }
}
