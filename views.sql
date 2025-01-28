--WIDOK O REZERWACJACH UZYTKOWNIKACH NA DANY HOTEL I OFERTE
CREATE OR REPLACE VIEW View_Rezerwacje AS
SELECT 
    r.rezerwacja_id,
    r.data_rezerwacji,
    u.uzytkownik_id,
    o.packID,
    o.startDate,
    o.endDate,
    h.hotelID
FROM 
    Rezerwacje_tab r
    JOIN Uzytkownicy_tab u ON REF(u) = r.ref_uzytkownik
    JOIN OfertyWakacyjne_tab o ON REF(o) = r.ref_oferta
    JOIN Hotele_tab h ON REF(h) = o.ref_hotel;
/
--WIDOK O SREDNIEJ OCENIE HOTELI
CREATE OR REPLACE VIEW View_Hotele_SredniaOcena AS
SELECT 
    h.hotelID,
    h.nazwa,
    h.lokalizacja,
    NVL(AVG(o.ocena.wartosc), 0) AS srednia_ocena
FROM 
    Hotele_tab h
    LEFT JOIN OcenyHoteli_tab o ON o.ref_hotel = REF(h)
GROUP BY 
    h.hotelID,
    h.nazwa,
    h.lokalizacja;
/
-------------------------------------------------------------------------------------------------------------------------------
-- WYSZUKIWARKA

CREATE OR REPLACE VIEW v_oferty_details AS
SELECT 
    ow.packID          AS id_oferty,
    ow.opis_pakietu    AS opis,
    ow.price           AS cena,
    ow.duration        AS liczba_dni,
    ow.startDate       AS data_rozpoczecia,
    ow.endDate         AS data_zakonczenia,
    h.hotelID          AS id_hotelu,
    h.nazwa            AS nazwa_hotelu,
    h.kraj             AS kraj,
    h.region           AS region,
    h.dla_doroslych    AS dla_doroslych,
    k.catId            AS id_kategorii,
    k.name             AS nazwa_kategorii,
    k.allIn            AS all_inclusive,
    k.lastMinute       AS last_minute,
    k.wakacjeZDziecmi  AS wakacje_z_dziecmi,
    NVL((SELECT AVG(oh.ocena.wartosc) 
         FROM OcenyHoteli_tab oh 
         WHERE REF(h) = oh.ref_hotel), 0) AS srednia_ocena
FROM 
    OfertyWakacyjne_tab ow
    JOIN Hotele_tab h ON REF(h) = ow.ref_hotel
    JOIN Kategorie_tab k ON REF(k) = ow.ref_cat;
/

commit;


BEGIN
    pkg_travel_display.display_search_results(
        p_min_rating => 3,
        p_min_duration => 5,
        p_max_duration => 14,
        p_country => 'Hiszpania',
        p_allIn => 1,
        p_min_price => 2000,
        p_max_price => 5000
    );
END;
/

----------------

SET SERVEROUTPUT ON;

SELECT o.packID, o.price, o.original_price 
FROM OfertyWakacyjne_tab o 
WHERE o.packID = 1;

INSERT INTO Promocje_tab VALUES (
    Promotions_typ(
        3,
        (SELECT REF(o) FROM OfertyWakacyjne_tab o WHERE o.packID = 1),
        'Test Promotion',
        'Test Description',
        20,
        SYSDATE,
        SYSDATE + 30
    )
);

SELECT o.packID, o.price, o.original_price 
FROM OfertyWakacyjne_tab o 
WHERE o.packID = 1;