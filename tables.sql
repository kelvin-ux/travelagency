------------------------------------------------------------------------
-- Tworzenie tabel na podstawie typ�w obiektowych
------------------------------------------------------------------------
-- Tabela dla typu Hotel_typ
CREATE TABLE Hotele_tab OF Hotel_typ
(
    CONSTRAINT pk_hotele PRIMARY KEY (hotelID)
)
/
-- Tabela dla typu OcenaHoteli_typ
CREATE TABLE OcenyHoteli_tab OF OcenaHoteli_typ
(
    CONSTRAINT pk_ocena_hoteli PRIMARY KEY (ocena_id)
)
/
-- Tabela dla typu OfertyWakacyjne_typ
CREATE TABLE OfertyWakacyjne_tab OF OfertyWakacyjne_typ
(
    CONSTRAINT pk_oferty_wakacyjne PRIMARY KEY (packID)
)
NESTED TABLE atrakcje STORE AS AtrakcjeStore;
/
-- Tabela dla typu Promotions_typ
CREATE TABLE Promocje_tab OF Promotions_typ
(
    CONSTRAINT pk_promocje PRIMARY KEY (promoId)
)
/
-- Tabela dla typu Uzytkownik_typ
CREATE TABLE Uzytkownicy_tab OF Uzytkownik_typ
(
    CONSTRAINT pk_uzytkownicy PRIMARY KEY (uzytkownik_id)
)
/
-- Tabela dla typu Rezerwacja_typ
CREATE TABLE Rezerwacje_tab OF Rezerwacja_typ
(
    CONSTRAINT pk_rezerwacje PRIMARY KEY (rezerwacja_id)
)
/
-- Tabela dla typu Kategorie_typ
CREATE TABLE Kategorie_tab OF Kategorie_typ (
    CONSTRAINT pk_kategorie PRIMARY KEY (catId)
)
/

