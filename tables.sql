-------------------------------------------------------------------------
-- 2. TABELA UZYTKOWNICY (obiektowa)
-------------------------------------------------------------------------
CREATE TABLE Uzytkownicy_tab OF Uzytkownik_typ
(
    CONSTRAINT pk_uzytkownicy PRIMARY KEY (uzytkownik_id)
)
OBJECT IDENTIFIER IS PRIMARY KEY;
/

-------------------------------------------------------------------------
-- 3. TABELA HOTEL (obiektowa)
-------------------------------------------------------------------------
CREATE TABLE Hotel_tab OF Hotel_typ
(
    CONSTRAINT pk_hotel PRIMARY KEY (hotelID)
)
OBJECT IDENTIFIER IS PRIMARY KEY;
/

-------------------------------------------------------------------------
-- 4. TABELA OCENY_HOTELI (obiektowa)
-------------------------------------------------------------------------
CREATE TABLE Oceny_hoteli_tab OF OcenaHoteli_typ
(
    ref_uzytkownik SCOPE IS Uzytkownicy_tab, 
    CONSTRAINT pk_oceny_hoteli PRIMARY KEY (ocena_id)
)
OBJECT IDENTIFIER IS PRIMARY KEY;
/

-------------------------------------------------------------------------
-- 5. TABELA ATRAKCJA (obiektowa)
-------------------------------------------------------------------------
CREATE TABLE Atrakcja_tab OF Atrakcja_typ
(
    ref_ocena SCOPE IS Oceny_hoteli_tab,
    CONSTRAINT pk_atrakcja PRIMARY KEY (atrakcjaID)
)
OBJECT IDENTIFIER IS PRIMARY KEY;
/

-------------------------------------------------------------------------
-- 6. TABELA ADRESY (obiektowa)
-------------------------------------------------------------------------
-- Najpierw utworzymy typ "opakowujący" Adres, jeśli chcemy mieć ID + Adres:
CREATE OR REPLACE TYPE Adresy_typ AS OBJECT (
    adresID          NUMBER,
    adres            Adres_typ
);
/

CREATE TABLE Adresy_tab OF Adresy_typ
(
    CONSTRAINT pk_adresy PRIMARY KEY (adresID)
)
OBJECT IDENTIFIER IS PRIMARY KEY;
/

-------------------------------------------------------------------------
-- 7. TABELA KATEGORIE (obiektowa)
-------------------------------------------------------------------------
CREATE TABLE Kategorie_tab OF Kategorie_typ
(
    CONSTRAINT pk_kategorie PRIMARY KEY (catId)
)
OBJECT IDENTIFIER IS PRIMARY KEY;
/

-------------------------------------------------------------------------
-- 8. TABELA OFERTY WAKACYJNE (obiektowa)
-------------------------------------------------------------------------
CREATE TABLE OfertyWakacyjne_tab OF OfertyWakacyjne_typ
(
    ref_cat SCOPE IS Kategorie_tab,
    ref_hotel SCOPE IS Hotel_tab,
    CONSTRAINT pk_oferty PRIMARY KEY (packID)
)
OBJECT IDENTIFIER IS PRIMARY KEY;
/

-------------------------------------------------------------------------
-- 9. TABELA PROMOCJE (obiektowa)
-------------------------------------------------------------------------
CREATE TABLE Promotions_tab OF Promotions_typ
(
    ref_package SCOPE IS OfertyWakacyjne_tab,
    CONSTRAINT pk_promotions PRIMARY KEY (promoId)
)
OBJECT IDENTIFIER IS PRIMARY KEY;
/