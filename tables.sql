------------------------------------------------------------------------
-- 1. Tabela Uzytkownicy_tab (obiekty typu Uzytkownik_typ)
------------------------------------------------------------------------
CREATE TABLE Uzytkownicy_tab OF Uzytkownik_typ
(
    CONSTRAINT pk_uzytkownicy PRIMARY KEY (uzytkownik_id)
)
OBJECT IDENTIFIER IS PRIMARY KEY;
/

------------------------------------------------------------------------
-- 2. Tabela Adresy_tab (obiekty typu Adresy_typ)
------------------------------------------------------------------------
CREATE TABLE Adresy_tab OF Adresy_typ
(
    CONSTRAINT pk_adresy PRIMARY KEY (adresID)
)
OBJECT IDENTIFIER IS PRIMARY KEY;
/

------------------------------------------------------------------------
-- 3. Tabela Hotel_tab (obiekty typu Hotel_typ)
------------------------------------------------------------------------
CREATE TABLE Hotel_tab OF Hotel_typ
(
    CONSTRAINT pk_hotel PRIMARY KEY (hotelID)
)
OBJECT IDENTIFIER IS PRIMARY KEY;
/

------------------------------------------------------------------------
-- 4. Tabela Oceny_hoteli_tab (obiekty typu OcenaHoteli_typ)
------------------------------------------------------------------------
CREATE TABLE Oceny_hoteli_tab OF OcenaHoteli_typ
(
    -- Klauzula SCOPE pokazuje, że ref_uzytkownik (REF Uzytkownik_typ)
    -- wskazuje na obiekty przechowywane w Uzytkownicy_tab:
    ref_uzytkownik SCOPE IS Uzytkownicy_tab,
    
    CONSTRAINT pk_oceny_hoteli PRIMARY KEY (ocena_id)
)
OBJECT IDENTIFIER IS PRIMARY KEY;
/

------------------------------------------------------------------------
-- 5. Tabela Atrakcja_tab (obiekty typu Atrakcja_typ)
------------------------------------------------------------------------
CREATE TABLE Atrakcja_tab OF Atrakcja_typ
(
    -- ref_ocena (REF OcenaHoteli_typ) odwołuje się do obiektów w Oceny_hoteli_tab
    ref_ocena SCOPE IS Oceny_hoteli_tab,
    
    CONSTRAINT pk_atrakcja PRIMARY KEY (atrakcjaID)
)
OBJECT IDENTIFIER IS PRIMARY KEY;
/

------------------------------------------------------------------------
-- 6. Tabela Kategorie_tab (obiekty typu Kategorie_typ)
------------------------------------------------------------------------
CREATE TABLE Kategorie_tab OF Kategorie_typ
(
    CONSTRAINT pk_kategorie PRIMARY KEY (catId)
)
OBJECT IDENTIFIER IS PRIMARY KEY;
/

------------------------------------------------------------------------
-- 7. Tabela OfertyWakacyjne_tab (obiekty typu OfertyWakacyjne_typ)
------------------------------------------------------------------------
CREATE TABLE OfertyWakacyjne_tab OF OfertyWakacyjne_typ
(
    -- ref_cat (REF Kategorie_typ) -> Kategorie_tab
    ref_cat   SCOPE IS Kategorie_tab,
    
    -- ref_hotel (REF Hotel_typ) -> Hotel_tab
    ref_hotel SCOPE IS Hotel_tab,
    
    CONSTRAINT pk_oferty PRIMARY KEY (packID)
)
OBJECT IDENTIFIER IS PRIMARY KEY;
/

------------------------------------------------------------------------
-- 8. Tabela Promotions_tab (obiekty typu Promotions_typ)
------------------------------------------------------------------------
CREATE TABLE Promotions_tab OF Promotions_typ
(
    -- ref_package (REF OfertyWakacyjne_typ) -> OfertyWakacyjne_tab
    ref_package SCOPE IS OfertyWakacyjne_tab,
    
    CONSTRAINT pk_promotions PRIMARY KEY (promoId)
)
OBJECT IDENTIFIER IS PRIMARY KEY;
/