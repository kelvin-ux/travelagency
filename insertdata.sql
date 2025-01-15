INSERT INTO Uzytkownicy_tab
VALUES (
  Uzytkownik_typ(
    4,
    'Jan',
    'Kowalski',
    'jan.kowalski@example.com',
    '123456789',
    'Klient'
  )
);

INSERT INTO Uzytkownicy_tab
VALUES (
  Uzytkownik_typ(
    5,
    'Anna',
    'Nowak',
    'anna.nowak@example.com',
    '987654321',
    'Pracownik'
  )
);

INSERT INTO Uzytkownicy_tab
VALUES (
  Uzytkownik_typ(
    6,
    'Paweł',
    'Zieliński',
    'pawel.zielinski@example.com',
    '600700800',
    'Administrator'
  )
);

-- select * from UZYTKOWNIK_TAB;

INSERT INTO Adresy_tab
VALUES (
  Adresy_typ(
    101,
    Adres_typ(
      'Morska',        -- ulica
      '10A',           -- nr_domu
      '5',             -- nr_mieszkania
      '81-010',        -- kod_pocztowy
      'Gdynia',        -- miasto
      'Polska'         -- kraj
    )
  )
);

INSERT INTO Adresy_tab
VALUES (
  Adresy_typ(
    102,
    Adres_typ(
      'Gdańska', 
      '55', 
      NULL,       -- brak nr mieszkania
      '80-180',
      'Gdańsk',
      'Polska'
    )
  )
);


INSERT INTO Hotel_tab
VALUES (
  Hotel_typ(
    11,
    NULL,
    'Górski Kurort 22',
    'Polska',
    'Tatry',
    OpisDestynacji_typ(
      'Polska',
      'Tatry',
      'Wspaniałe górskie krajobrazy i liczne szlaki piesze.'
    ),
    0  -- dla_doroslych (0 = false, hotel przyjazny rodzinom)
  )
);

INSERT INTO Kategorie_tab
VALUES (
  Kategorie_typ(
    1,
    'All Inclusive',
    'Pakiet z wyżywieniem i napojami w cenie',
    1,  -- allIn
    0,  -- wakacje z dziećmi
    0   -- lastMinute
  )
);

INSERT INTO Kategorie_tab
VALUES (
  Kategorie_typ(
    2,
    'Rodzinne wakacje',
    'Pakiet wakacyjny przystosowany dla dzieci i rodzin',
    0,  -- allIn
    1,  -- wakacje z dziećmi
    0   -- lastMinute
  )
);


DECLARE
  v_cat   REF Kategorie_typ;
  v_hotel REF Hotel_typ;
BEGIN
  SELECT REF(k) 
    INTO v_cat
    FROM Kategorie_tab k
   WHERE k.catId = 1;

  SELECT REF(h)
    INTO v_hotel
    FROM Hotel_tab h
   WHERE h.hotelID = 10;

  INSERT INTO OfertyWakacyjne_tab
  VALUES (
    OfertyWakacyjne_typ(
      501,            -- packID
      v_cat,          -- ref_cat
      v_hotel,        -- ref_hotel
      DATE '2025-07-01',   -- startDate
      DATE '2025-07-10',   -- endDate
      3999.99,             -- price
      'Wakacje w słonecznej Hiszpanii - 9 dni', 
      1,                   -- avalibitystatus (1 = dostępne)
      9                    -- duration (liczba dni)
    )
  );
END;
/


DECLARE
  v_ref_uzytkownik REF Uzytkownik_typ;
BEGIN
  SELECT REF(u)
    INTO v_ref_uzytkownik
    FROM Uzytkownicy_tab u
   WHERE u.uzytkownik_id = 1;
   
  INSERT INTO Oceny_hoteli_tab
  VALUES(
    OcenaHoteli_typ(
      100,
      v_ref_uzytkownik,
      Ocena_typ(
        9, 
        'Bardzo przyjemny hotel i miła obsługa.', 
        SYSDATE
      ),
      'Świetna lokalizacja nad samym morzem.',
      SYSDATE
    )
  );
END;
/


DECLARE
  v_ref_oferta REF OfertyWakacyjne_typ;
BEGIN
  SELECT REF(o)
    INTO v_ref_oferta
    FROM OfertyWakacyjne_tab o
   WHERE o.packID = 501;
   
  INSERT INTO Promotions_tab
  VALUES (
    Promotions_typ(
      1000,       -- promoId
      v_ref_oferta,
      'Happy Summer',
      'Specjalna promocja na wakacje w Hiszpanii',
      20,         -- discount = 20%
      DATE '2025-06-01',
      DATE '2025-06-30'
    )
  );
END;
/


DECLARE
  v_ref_ocena REF OcenaHoteli_typ;
BEGIN
  SELECT REF(o)
    INTO v_ref_ocena
    FROM Oceny_hoteli_tab o
   WHERE o.ocena_id = 100;
   
  INSERT INTO Atrakcja_tab
  VALUES (
    Atrakcja_typ(
      2001,                     -- atrakcjaID
      v_ref_ocena,             -- ref_ocena
      OpisAtrakcja_typ(
        'Safari w górach',     -- nazwa
        'Wyjątkowa przygoda z widokiem na piękne szczyty.'
      )
    )
  );
END;
/


-- Dodajemy hotel (hotelID = 100) z oceną 4.6
INSERT INTO Hotel_tab
VALUES (
  Hotel_typ(
    100,
    200,  -- ocenaId (potrzebny do powiązania z Oceny_hoteli_tab)
    'Hotel Centralny 1',
    'Hiszpania',
    'Costa del Sol',
    OpisDestynacji_typ('Hiszpania', 'Costa del Sol', 'Opis destynacji...'),
    1
  )
);


-- Dodajemy ocenę dla hoteluID = 100
DECLARE
  v_ref_uzytkownik REF Uzytkownik_typ;
BEGIN
  SELECT REF(u) INTO v_ref_uzytkownik FROM Uzytkownicy_tab u WHERE u.uzytkownik_id = 1;
  
  INSERT INTO Oceny_hoteli_tab
  VALUES(
    OcenaHoteli_typ(
      200,           -- ocena_id
      v_ref_uzytkownik,
      Ocena_typ(4.6, 'Bardzo dobry hotel', SYSDATE),
      'Przyjemny pobyt',
      SYSDATE
    )
  );
END;
/


DECLARE
  v_cat   REF Kategorie_typ;
  v_hotel REF Hotel_typ;
BEGIN
  SELECT REF(k) INTO v_cat FROM Kategorie_tab k WHERE k.catId = 1;
  SELECT REF(h) INTO v_hotel FROM Hotel_tab h WHERE h.hotelID = 100;
  
  INSERT INTO OfertyWakacyjne_tab
  VALUES (
    OfertyWakacyjne_typ(
      503, 
      v_cat,          
      v_hotel,        
      DATE '2025-07-01',   -- startDate
      DATE '2025-07-10',   -- endDate 
      3999.99,             
      'All Inclusive na Costa del Sol',
      1,                   
      9                    
    )
  );
END;
/
COMMIT;

INSERT INTO Hotel_tab
VALUES (
  Hotel_typ(
    102,                     -- hotelID
    200,                     -- ocenaId (będzie użyte do powiązania z oceną)
    'Hotel Riviera', 
    'Hiszpania', 
    'Costa del Sol', 
    OpisDestynacji_typ('Hiszpania', 'Costa del Sol', 'Luksusowy hotel nad morzem.'), 
    1                        -- dla_doroslych
  )
);
COMMIT;

DECLARE
  v_ref_uzytkownik REF Uzytkownik_typ;
BEGIN
  SELECT REF(u) INTO v_ref_uzytkownik FROM Uzytkownicy_tab u WHERE u.uzytkownik_id = 1;
  
  INSERT INTO Oceny_hoteli_tab
  VALUES(
    OcenaHoteli_typ(
      201,                      -- ocena_id
      v_ref_uzytkownik,         
      Ocena_typ(4.7, 'Świetny hotel!', SYSDATE),  -- ocena > 4.5
      'Bardzo polecam',
      SYSDATE
    )
  );
END;
/
COMMIT;

INSERT INTO Kategorie_tab
VALUES (
  Kategorie_typ(3, 'All Inclusive', 'Wyżywienie i napoje w cenie', 1, 0, 0)
);
COMMIT;


DECLARE
  v_cat   REF Kategorie_typ;
  v_hotel REF Hotel_typ;
BEGIN
  -- Pobranie referencji do kategorii All Inclusive i hotelu
  SELECT REF(k) INTO v_cat FROM Kategorie_tab k WHERE k.catId = 3;
  SELECT REF(h) INTO v_hotel FROM Hotel_tab h WHERE h.hotelID = 102;
  
  INSERT INTO OfertyWakacyjne_tab
  VALUES (
    OfertyWakacyjne_typ(
      702,                     -- packID (wybierz unikalne ID)
      v_cat,                   
      v_hotel,                 
      DATE '2025-08-01',       -- startDate
      DATE '2025-08-10',       -- endDate (9 dni)
      4000,                    -- cena w zakresie 3000-5000
      'Luksusowy pobyt All Inclusive nad morzem.',
      1,                       -- avalibitystatus
      9                        -- duration
    )
  );
END;
/
COMMIT;