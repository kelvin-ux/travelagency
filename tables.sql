------------------------------------------------------------------------
-- 1. Tabela Uzytkownicy_tab
------------------------------------------------------------------------
CREATE TABLE Uzytkownicy_tab OF Uzytkownik_typ
(
    CONSTRAINT pk_uzytkownicy PRIMARY KEY (uzytkownik_id)
)
OBJECT IDENTIFIER IS PRIMARY KEY
/

------------------------------------------------------------------------
-- 2. Tabela Adresy_tab 
------------------------------------------------------------------------
CREATE TABLE Adresy_tab OF Adresy_typ
(
    CONSTRAINT pk_adresy PRIMARY KEY (adresID)
)
OBJECT IDENTIFIER IS PRIMARY KEY
/

------------------------------------------------------------------------
-- 3. Tabela Hotel_tab 
------------------------------------------------------------------------
CREATE TABLE Hotel_tab OF Hotel_typ
(
    CONSTRAINT pk_hotel PRIMARY KEY (hotelID)
)
OBJECT IDENTIFIER IS PRIMARY KEY
/

------------------------------------------------------------------------
-- 4. Tabela Oceny_hoteli_tab 
------------------------------------------------------------------------
CREATE TABLE Oceny_hoteli_tab OF OcenaHoteli_typ
(
    ref_uzytkownik SCOPE IS Uzytkownicy_tab,
    
    CONSTRAINT pk_oceny_hoteli PRIMARY KEY (ocena_id)
)
OBJECT IDENTIFIER IS PRIMARY KEY
/

------------------------------------------------------------------------
-- 5. Tabela Atrakcja_tab 
------------------------------------------------------------------------
CREATE TABLE Atrakcja_tab OF Atrakcja_typ
(
    ref_ocena SCOPE IS Oceny_hoteli_tab,
    
    CONSTRAINT pk_atrakcja PRIMARY KEY (atrakcjaID)
)
OBJECT IDENTIFIER IS PRIMARY KEY
/

------------------------------------------------------------------------
-- 6. Tabela Kategorie_tab 
------------------------------------------------------------------------
CREATE TABLE Kategorie_tab OF Kategorie_typ
(
    CONSTRAINT pk_kategorie PRIMARY KEY (catId)
)
OBJECT IDENTIFIER IS PRIMARY KEY
/

------------------------------------------------------------------------
-- 7. Tabela OfertyWakacyjne_tab 
------------------------------------------------------------------------
CREATE TABLE OfertyWakacyjne_tab OF OfertyWakacyjne_typ
(
    ref_cat   SCOPE IS Kategorie_tab,
    
    ref_hotel SCOPE IS Hotel_tab,
    
    CONSTRAINT pk_oferty PRIMARY KEY (packID)
)
OBJECT IDENTIFIER IS PRIMARY KEY
/

------------------------------------------------------------------------
-- 8. Tabela Promotions_tab 
------------------------------------------------------------------------
CREATE TABLE Promotions_tab OF Promotions_typ
(
    ref_package SCOPE IS OfertyWakacyjne_tab,
    
    CONSTRAINT pk_promotions PRIMARY KEY (promoId)
)
OBJECT IDENTIFIER IS PRIMARY KEY
/