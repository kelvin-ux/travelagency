------------------------------------------------------------------------
-- UZYTKOWNIK_TYP
------------------------------------------------------------------------
CREATE OR REPLACE TYPE Uzytkownik_typ AS OBJECT (
  uzytkownik_id    NUMBER,
  imie             VARCHAR2(50),
  nazwisko         VARCHAR2(50),
  email            VARCHAR2(100),
  telefon          VARCHAR2(20),
  typ_uzytkownika  VARCHAR2(50)
);
/
------------------------------------------------------------------------
-- ADRES_TYP oraz ADRESY_TYP (opakowanie z ID)
------------------------------------------------------------------------
CREATE OR REPLACE TYPE Adres_typ AS OBJECT (
    ulica         VARCHAR2(100),
    nr_domu       VARCHAR2(10),
    nr_mieszkania VARCHAR2(10),
    kod_pocztowy  VARCHAR2(10),
    miasto        VARCHAR2(100),
    kraj          VARCHAR2(100)
);
/

CREATE OR REPLACE TYPE Adresy_typ AS OBJECT (
    adresID NUMBER,
    adres   Adres_typ
);
/
------------------------------------------------------------------------
-- OPISATRACJA_TYP (z nazwa i opis)
------------------------------------------------------------------------
CREATE OR REPLACE TYPE OpisAtrakcja_typ AS OBJECT (
  nazwa  VARCHAR2(200),
  opis   CLOB
);
/
------------------------------------------------------------------------
-- OPISDESTYNACJI_TYP (kraj, region, opisLong)
------------------------------------------------------------------------
CREATE OR REPLACE TYPE OpisDestynacji_typ AS OBJECT (
  kraj       VARCHAR2(100),
  region     VARCHAR2(100),
  opisLong   CLOB
);
/
------------------------------------------------------------------------
-- OCENA_TYP (wartosc, komentarz, data)
------------------------------------------------------------------------
CREATE OR REPLACE TYPE Ocena_typ AS OBJECT (
  wartosc    NUMBER,           
  komentarz  VARCHAR2(1000),
  data       DATE
);
/
------------------------------------------------------------------------
-- HOTEL_TYP (z Boolean "dla_doroslych")
------------------------------------------------------------------------
CREATE OR REPLACE TYPE Hotel_typ AS OBJECT (
  hotelID          NUMBER,
  ocenaId          NUMBER,
  lokalizacja      VARCHAR2(200),
  kraj             VARCHAR2(100),
  region           VARCHAR2(100),
  opis_destynacji  OpisDestynacji_typ,
  dla_doroslych    NUMBER(1)
);
/
------------------------------------------------------------------------
-- OCENAHOTELI_TYP (przechowuje REF do Uzytkownik_typ)
------------------------------------------------------------------------
CREATE OR REPLACE TYPE OcenaHoteli_typ AS OBJECT (
  ocena_id         NUMBER,
  ref_uzytkownik   REF Uzytkownik_typ,  
  ocena            Ocena_typ,          
  opinia           VARCHAR2(1000),
  data_oceny       DATE
);
/
------------------------------------------------------------------------
-- ATRAKCJA_TYP (z REF do OcenaHoteli_typ, jeśli potrzebne)
------------------------------------------------------------------------
CREATE OR REPLACE TYPE Atrakcja_typ AS OBJECT (
  atrakcjaID       NUMBER,
  ref_ocena        REF OcenaHoteli_typ,
  opis_atrakcji    OpisAtrakcja_typ
);
/
------------------------------------------------------------------------
-- KATEGORIE_TYP (Boolean: allIn, wakacjeZDziecmi, lastMinute)
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
-- OFERTYWAKACYJNE_TYP (z "duration" = endDate - startDate)
------------------------------------------------------------------------
CREATE OR REPLACE TYPE OfertyWakacyjne_typ AS OBJECT (
  packID           NUMBER,
  ref_cat          REF Kategorie_typ,
  ref_hotel        REF Hotel_typ,
  startDate        DATE,
  endDate          DATE,
  price            NUMBER(10,2),
  opis_pakietu     VARCHAR2(2000),
  avalibitystatus  NUMBER(1),
  duration         NUMBER(5,2)    -- lub NUMBER(3) jeśli wystarczy całkowita liczba dni
);
/
------------------------------------------------------------------------
-- PROMOTIONS_TYP (z REF do OfertyWakacyjne_typ)
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