# 💼 Harcama Takip Uygulaması (Expense Tracker)

Bilecik Şeyh Edebali Üniversitesi ibf Fakültesi ybs bölümü **Mobil Programlama** dersi kapsamında, **Öğr. Gör. Hüseyin Parmaksız** yönetiminde geliştirilmiş bir kurumsal/bireysel harcama yönetim mobil uygulamasıdır.

Uygulama, modern bir arayüz (Dark Mode) sunarak kullanıcıların günlük, haftalık veya aylık harcamalarını kategorize ederek bütçe takibi yapmalarını sağlar. Veriler yerel hafızada tutularak uygulamanın çevrimdışı (offline) çalışması desteklenmiştir.

---

## ✨ Özellikler

* **Kullanıcı Giriş Sistemi (Authentication Demo):** Güvenli arayüz mimarisine sahip, `admin/1234` gibi önceden tanımlanmış kullanıcı hesaplarıyla giriş yapabilme özelliği.
* **Dinamik Bütçe Yönetimi:** Toplam bütçe (50.000 ₺) üzerinden yapılan harcamaların anlık hesaplanması, kalan bütçe ve toplam işlem adetlerinin dinamik takibi.
* **Kategorizasyon ve Filtreleme:** Harcamaları *Ofis, Seyahat, Yemek, Yazılım, Ekipman ve Diğer* kategorilerine ayırabilme ve ana sayfada tek tıkla filtreleyebilme.
* **Kalıcı Veri Depolama (Persistent Storage):** `shared_preferences` entegrasyonu sayesinde uygulama kapatılıp açılsa bile harcama verilerinin kaybolmaması.
* **Modern UI/UX:** Koyu tema yapısı, yuvarlatılmış kart tasarımları, degrade (gradient) efektleri ve alt gezinti çubuğu (Bottom Navigation Bar) ile sezgisel kullanıcı deneyimi.

---

## 🛠️ Kullanılan Teknolojiler ve Kütüphaneler

* **Framework:** [Flutter](https://flutter.dev/) (Cross-platform Mobil Uygulama Geliştirme)
* **Dil:** [Dart](https://dart.dev/)
* **Veri Depolama:** `shared_preferences: ^2.2.0` (Key-value tabanlı yerel depolama)
* **Veri Dönüşümü:** `dart:convert` (Nesneleri JSON formatına dönüştürme ve çözme)

---

## 🏗️ Kod Yapısı ve Mimari Özeti

Proje tek bir ana dosyada (`main.dart`) temiz ve modüler bir mimariyle kurgulanmıştır:

1. **`Harcama` Veri Modeli:** Nesne tabanlı veri yönetimini sağlamak amacıyla oluşturulan model; `toJson` ve `fromJson` metotları ile yerel veritabanı transferini kolaylaştırır.
2. **Kategori ve Kullanıcı Konfigürasyonu:** Uygulama içerisindeki renk paletleri, emojiler ve mock kullanıcı verileri global sabitler (`const`) olarak tanımlanarak bellek optimizasyonu sağlanmıştır.
3. **State Management (Durum Yönetimi):** Uygulama içi veri güncellemeleri, filtreleme işlemleri ve bütçe hesaplamaları Flutter'ın yerleşik `StatefulWidget` ve `setState` mekanizması ile reactive bir şekilde yönetilir.
4. **Harcama Ekleme Arayüzü (`HarcamaEkleSheet`):** Form doğrulama (validation) mekanizmasına sahip, alt panelden (Bottom Sheet) açılan kullanıcı dostu form yapısı.

---

### 👨‍💻 Geliştirici
* **Adı Soyadı:** DIAEDEIN MBROOKA
* **Üniversite:** Bilecik Şeyh Edebali Üniversitesi
* **Ders:** Mobil Programlama (Öğr. Gör. Hüseyin Parmaksız)
