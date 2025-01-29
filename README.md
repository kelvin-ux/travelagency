# System Zarządzania Biurem Podróży

> Kompleksowy system obiektowej bazy danych dla biura podróży, zaimplementowany w PL/SQL.

## 📋 Spis treści

- [Opis projektu](#opis-projektu)
- [Funkcjonalności](#funkcjonalności)
- [Struktura systemu](#struktura-systemu)
- [Wymagania](#wymagania)
- [Szczegóły implementacji](#szczegóły-implementacji)
- [Role i uprawnienia](#role-i-uprawnienia)

## 🎯 Opis projektu

System zarządzania biurem podróży to kompleksowe rozwiązanie bazodanowe wykorzystujące możliwości obiektowej bazy danych Oracle. Projekt umożliwia pełną obsługę procesów związanych z rezerwacją wakacji, zarządzaniem ofertami oraz obsługą klientów.

### Główne cele biznesowe:
- Zarządzanie ofertami wakacyjnymi i rezerwacjami
- Obsługa systemu ocen i recenzji hoteli
- Implementacja systemu promocji i rabatów
- Kompleksowa obsługa klientów i rezerwacji

## 🔑 Funkcjonalności

### Zarządzanie ofertami
- Kategoryzacja ofert (rodzinne/dla dorosłych/all-inclusive)
- Dynamiczny system cenowy z obsługą promocji
- System zarządzania atrakcjami
- Obsługa wielu lokalizacji i regionów

### System rezerwacji
- Kontrola dostępności terminów
- Weryfikacja konfliktów rezerwacji
- Automatyczne przeliczanie cen
- Śledzenie statusu rezerwacji

### Obsługa klientów
- System ocen i recenzji
- Historia rezerwacji
- Profile użytkowników
- Różne poziomy dostępu

## 🏗 Struktura systemu

### Typy obiektowe:
```sql
- Adresy_typ
- Ocena_typ
- Hotel_typ
- Uzytkownik_typ
- OcenaHoteli_typ
- Atrakcja_typ
- ListaAtrakcje_typ
- Kategorie_typ
- OfertyWakacyjne_typ
- Promotions_typ
- Rezerwacja_typ
```

### Pakiety:
```sql
- pkg_travel_search       -- wyszukiwanie ofert
- pkg_travel_display      -- wyświetlanie wyników
- pkg_reservation_management -- zarządzanie rezerwacjami
```

### Wyzwalacze:
```sql
- trg_check_ocena_hoteli
- trg_update_price_after_promotion
- trg_restore_price_after_promotion_delete
- trg_set_original_price
- trg_check_reservation_conflict
```

### Widoki analityczne:
```sql
- v_oferty_details
- v_hotel_sales_stats
- v_user_activity
- v_reservation_details
- v_available_offers
```

## ⚙️ Wymagania

### Techniczne:
- Oracle Database (wersja wspierająca typy obiektowe)
- PL/SQL

### Biznesowe:
- Każdy hotel musi mieć przypisaną lokalizację
- Oceny tylko od zweryfikowanych gości
- Brak nakładających się rezerwacji
- Kontrola cen i promocji

## 🛠 Szczegóły implementacji

### Walidacje i ograniczenia:
- Kontrola wartości ocen (1-5)
- Walidacja dat rezerwacji
- Weryfikacja cen (> 0)
- Kontrola konfliktów rezerwacji
- Automatyczna aktualizacja dostępności

### Relacje obiektowe:
- Referencje między ofertami a hotelami
- Referencje między rezerwacjami a użytkownikami
- Kolekcje atrakcji w ofertach (NESTED TABLE)

## 👥 Role i uprawnienia

### Administrator
- Pełny dostęp do systemu
- Zarządzanie użytkownikami
- Modyfikacja struktur bazy danych

### Klient
- Modyfikacja ofert
- Zarządzanie promocjami
- Przeglądanie danych

### Regularny użytkownik
- Przeglądanie ofert
- Dodawanie rezerwacji
- Wystawianie ocen

## ✅ Zrealizowane założenia

- [x] Implementacja typów obiektowych
- [x] Utworzenie tabel obiektowych
- [x] Zastosowanie referencji
- [x] Implementacja kolekcji
- [x] Logika biznesowa w pakietach
- [x] Wyzwalacze dla automatyzacji
- [x] Widoki analityczne
- [x] Role i uprawnienia
- [x] Walidacje i ograniczenia
- [x] Obsługa błędów

## 📊 System raportowania

### Dostępne raporty:
- Statystyki sprzedaży
- Analiza popularności ofert
- Raporty rezerwacji
- Zestawienia ocen hoteli

---

****
