------------------------------------------------------------------------
-- ADRES_TYP 
------------------------------------------------------------------------
CREATE OR REPLACE TYPE Adresy_typ AS OBJECT (
    adresID       NUMBER,
    ulica         VARCHAR2(100),
    nr_domu       VARCHAR2(10),
    nr_mieszkania VARCHAR2(10),
    kod_pocztowy  VARCHAR2(10),
    miasto        VARCHAR2(100),
    kraj          VARCHAR2(100)
);
/

------------------------------------------------------------------------
-- OCENA_TYP 
------------------------------------------------------------------------
CREATE OR REPLACE TYPE Ocena_typ AS OBJECT (
  wartosc    NUMBER,           
  komentarz  VARCHAR2(1000),
  data       DATE
);
/
------------------------------------------------------------------------
-- HOTEL_TYP 
------------------------------------------------------------------------
CREATE OR REPLACE TYPE Hotel_typ AS OBJECT (
  hotelID          NUMBER,
  nazwa            VARCHAR2(200),
  lokalizacja      VARCHAR2(200),
  kraj             VARCHAR2(100),
  region           VARCHAR2(100),
  opisLong         CLOB,
  dla_doroslych    NUMBER(1),
  adres            Adresy_typ
);
/

------------------------------------------------------------------------
-- UZYTKOWNICY_TYP
------------------------------------------------------------------------

CREATE OR REPLACE TYPE Uzytkownik_typ AS OBJECT (
  uzytkownik_id    NUMBER,
  imie             VARCHAR2(50),
  nazwisko         VARCHAR2(50),
  email            VARCHAR2(100),
  telefon          VARCHAR2(20),
  typ_uzytkownika  VARCHAR2(50),
  data_urodzenia   DATE         
);
/

------------------------------------------------------------------------
-- OCENAHOTELI_TYP
------------------------------------------------------------------------
CREATE OR REPLACE TYPE OcenaHoteli_typ AS OBJECT (
  ocena_id         NUMBER,
  ref_uzytkownik   REF Uzytkownik_typ,    
  ref_hotel        REF Hotel_typ,        
  ocena            Ocena_typ
);
/
------------------------------------------------------------------------
-- ATRAKCJA_TYP 
------------------------------------------------------------------------
CREATE OR REPLACE TYPE Atrakcja_typ AS OBJECT (
  atrakcjaID       NUMBER,
  nazwa  VARCHAR2(200),
  opis_atrakcji    CLOB
);
/
------------------------------------------------------------------------
-- LISTAATRAKCJE_TYP
------------------------------------------------------------------------
CREATE OR REPLACE TYPE ListaAtrakcje_typ AS TABLE OF Atrakcja_typ;
------------------------------------------------------------------------
-- KATEGORIE_TYP 
------------------------------------------------------------------------
CREATE OR REPLACE TYPE Kategorie_typ AS OBJECT (
  catId            NUMBER,
  name             VARCHAR2(100),
  opis             CLOB,
  allIn            NUMBER(1),
  wakacjeZDziecmi  NUMBER(1),
  lastMinute       NUMBER(1)
);
/
------------------------------------------------------------------------
-- OFERTYWAKACYJNE_TYP 
------------------------------------------------------------------------
CREATE OR REPLACE TYPE OfertyWakacyjne_typ AS OBJECT (
  packID           NUMBER,
  ref_cat          REF Kategorie_typ,
  ref_hotel        REF Hotel_typ,
  startDate        DATE,
  endDate          DATE,
  price            NUMBER(10,2),
  original_price   NUMBER(10,2),
  opis_pakietu     VARCHAR2(2000),
  avalibitystatus  NUMBER(1),
  duration         NUMBER(5,2),
  atrakcje         ListaAtrakcje_typ
);
------------------------------------------------------------------------
-- PROMOTIONS_TYP 
------------------------------------------------------------------------
CREATE OR REPLACE TYPE Promotions_typ AS OBJECT (
    promoId       NUMBER,
    ref_package   REF OfertyWakacyjne_typ,
    promoName     VARCHAR2(100),
    promoDesc     VARCHAR2(1000),
    discount      NUMBER(3),
    startDate     DATE,
    endDate       DATE
);
/

------------------------------------------------------------------------
-- REZERWACJE_TYP
------------------------------------------------------------------------

CREATE OR REPLACE TYPE Rezerwacja_typ AS OBJECT (
  rezerwacja_id    NUMBER,
  ref_uzytkownik   REF Uzytkownik_typ,
  ref_oferta       REF OfertyWakacyjne_typ,
  data_rezerwacji  DATE
);
/

