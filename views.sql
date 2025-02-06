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


select * from View_Rezerwacje;
select * from View_Hotele_SredniaOcena;
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
        6,
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



UPDATE OfertyWakacyjne_tab
SET price = price * 0.8
WHERE packID = 5;

select * from V_HOTEL_SALES_STATS;

---------------------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW v_hotel_sales_stats AS
SELECT 
    h.hotelID,
    h.nazwa as hotel_name,
    h.kraj as country,
    COUNT(r.rezerwacja_id) as total_reservations,
    SUM(CASE 
        WHEN r.rezerwacja_id IS NOT NULL THEN r.cena_rezerwacji
        ELSE o.original_price
    END) as total_revenue,
    AVG(CASE 
        WHEN r.rezerwacja_id IS NOT NULL THEN r.cena_rezerwacji
        ELSE o.original_price
    END) as avg_reservation_price,
    MIN(CASE 
        WHEN r.rezerwacja_id IS NOT NULL THEN r.cena_rezerwacji
        ELSE o.original_price
    END) as min_price,
    MAX(CASE 
        WHEN r.rezerwacja_id IS NOT NULL THEN r.cena_rezerwacji
        ELSE o.original_price
    END) as max_price,
    COUNT(CASE 
        WHEN o.startDate - r.data_rezerwacji <= 7 THEN 1 
    END) as last_minute_bookings
FROM 
    Hotele_tab h
    LEFT JOIN OfertyWakacyjne_tab o ON REF(h) = o.ref_hotel
    LEFT JOIN Rezerwacje_tab r ON REF(o) = r.ref_oferta
GROUP BY 
    h.hotelID, h.nazwa, h.kraj
ORDER BY 
    total_revenue DESC NULLS LAST;
/

---------------------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW v_user_activity AS
SELECT 
    u.uzytkownik_id,
    u.imie || ' ' || u.nazwisko as user_name,
    COUNT(DISTINCT r.rezerwacja_id) as total_reservations,
    COUNT(DISTINCT oh.ocena_id) as total_reviews,
    AVG(oh.ocena.wartosc) as avg_rating_given,
    MIN(r.data_rezerwacji) as first_reservation,
    MAX(r.data_rezerwacji) as last_reservation,
    COUNT(DISTINCT CASE WHEN o.endDate < SYSDATE THEN r.rezerwacja_id END) as completed_trips,
    COUNT(DISTINCT CASE WHEN o.endDate >= SYSDATE THEN r.rezerwacja_id END) as upcoming_trips
FROM 
    Uzytkownicy_tab u
    LEFT JOIN Rezerwacje_tab r ON REF(u) = r.ref_uzytkownik
    LEFT JOIN OfertyWakacyjne_tab o ON REF(o) = r.ref_oferta
    LEFT JOIN OcenyHoteli_tab oh ON REF(u) = oh.ref_uzytkownik
GROUP BY 
    u.uzytkownik_id, u.imie, u.nazwisko;
---------------------------------------------------------------------------------------------------------

select * from V_HOTEL_SALES_STATS;
select * from V_USER_ACTIVITY;

select * from Kategorie_tab;
select * from OfertyWakacyjne_tab;
---------------------------------------------------------------------------------------------------------

CREATE OR REPLACE VIEW v_reservation_details AS
SELECT 
    r.rezerwacja_id,
    u.uzytkownik_id,
    u.imie || ' ' || u.nazwisko as klient,
    o.packID as oferta_id,
    h.nazwa as hotel,
    h.kraj,
    h.region,
    o.price as cena,
    o.startDate as data_rozpoczecia,
    o.endDate as data_zakonczenia,
    o.duration as dlugosc_pobytu,
    k.name as kategoria,
    k.allIn as all_inclusive,
    r.data_rezerwacji,
    CASE 
        WHEN o.startDate > SYSDATE THEN 'Nadchodząca'
        WHEN o.endDate < SYSDATE THEN 'Zakończona'
        ELSE 'W trakcie'
    END as status_rezerwacji
FROM 
    Rezerwacje_tab r,
    Uzytkownicy_tab u,
    OfertyWakacyjne_tab o,
    Hotele_tab h,
    Kategorie_tab k
WHERE 
    REF(u) = r.ref_uzytkownik
    AND REF(o) = r.ref_oferta
    AND REF(h) = o.ref_hotel
    AND REF(k) = o.ref_cat;

---------------------------------------------------------------------------------------------------------

CREATE OR REPLACE VIEW v_user_reservations_summary AS
SELECT 
    u.uzytkownik_id,
    u.imie || ' ' || u.nazwisko as klient,
    COUNT(r.rezerwacja_id) as liczba_rezerwacji,
    SUM(o.price) as suma_wydatkow,
    MIN(r.data_rezerwacji) as pierwsza_rezerwacja,
    MAX(r.data_rezerwacji) as ostatnia_rezerwacja,
    COUNT(CASE WHEN o.startDate > SYSDATE THEN 1 END) as nadchodzace_wyjazdy,
    COUNT(CASE WHEN o.endDate < SYSDATE THEN 1 END) as zakonczone_wyjazdy,
    ROUND(AVG(o.duration), 1) as srednia_dlugosc_pobytu
FROM 
    Uzytkownicy_tab u
    LEFT JOIN Rezerwacje_tab r ON REF(u) = r.ref_uzytkownik
    LEFT JOIN OfertyWakacyjne_tab o ON REF(o) = r.ref_oferta
GROUP BY 
    u.uzytkownik_id, u.imie, u.nazwisko
ORDER BY 
    liczba_rezerwacji DESC;


---------------------------------------------------------------------------------------------------------

CREATE OR REPLACE VIEW v_available_offers AS
SELECT 
    o.packID as oferta_id,
    h.nazwa as hotel,
    h.kraj,
    h.region,
    o.price as cena,
    o.startDate as data_rozpoczecia,
    o.endDate as data_zakonczenia,
    o.duration as dlugosc_pobytu,
    k.name as kategoria,
    k.allIn as all_inclusive,
    k.wakacjeZDziecmi as dla_rodzin,
    o.avalibitystatus as dostepnosc,
    ROUND(o.startDate - SYSDATE) as dni_do_wyjazdu
FROM 
    OfertyWakacyjne_tab o,
    Hotele_tab h,
    Kategorie_tab k
WHERE 
    REF(h) = o.ref_hotel
    AND REF(k) = o.ref_cat
    AND o.avalibitystatus = 1
    AND o.startDate > SYSDATE
ORDER BY 
    o.startDate;


---------------------------------------------------------------------------------------------------------

SELECT * FROM v_reservation_details 
WHERE uzytkownik_id = 1;

SELECT * FROM UZytkownicy_tab;

-----------------------------WIDOK POMOCNICZY---------------------------------------------------------


SELECT 
    r.rezerwacja_id,
    u.uzytkownik_id,
    u.imie || ' ' || u.nazwisko as klient,
    o.startDate as data_rozpoczecia,
    o.endDate as data_zakonczenia
FROM 
    Rezerwacje_tab r,
    Uzytkownicy_tab u,
    OfertyWakacyjne_tab o
WHERE 
    REF(u) = r.ref_uzytkownik
    AND REF(o) = r.ref_oferta
ORDER BY 
    o.startDate;

------------------ WIDOK POMOCNICZY--------------------------------------------------------------------

SELECT 
    o.packID,
    h.nazwa as hotel,
    o.startDate,
    o.endDate,
    o.price,
    CASE 
        WHEN EXISTS (
            SELECT 1 
            FROM Rezerwacje_tab r2, OfertyWakacyjne_tab o2
            WHERE REF(o2) = r2.ref_oferta
            AND r2.ref_uzytkownik = (SELECT REF(u) FROM Uzytkownicy_tab u WHERE u.uzytkownik_id = 3)
            AND (
                (o.startDate BETWEEN o2.startDate AND o2.endDate) OR
                (o.endDate BETWEEN o2.startDate AND o2.endDate)
            )
        ) THEN 'KONFLIKT'
        ELSE 'DOSTĘPNA'
    END as status
FROM 
    OfertyWakacyjne_tab o,
    Hotele_tab h
WHERE 
    REF(h) = o.ref_hotel
    AND o.avalibitystatus = 1
    AND o.startDate >= SYSDATE
ORDER BY 
    o.startDate;
    
    
-------------------------------WIDOK POMOCNICZY-------------------------------------------------------
SELECT 
    o.packID,
    h.nazwa as hotel_name,
    o.startDate as data_rozpoczecia,
    o.endDate as data_zakonczenia,
    o.price as cena
FROM 
    OfertyWakacyjne_tab o,
    Hotele_tab h
WHERE 
    REF(h) = o.ref_hotel
    AND o.avalibitystatus = 1
    AND o.startDate >= SYSDATE
ORDER BY 
    o.startDate;


--------------------------------------------------------------------------------------

DECLARE
    v_status VARCHAR2(100);
BEGIN
    pkg_reservation_management.create_reservation(
        p_user_id => 3,    
        p_package_id => 5,     
        p_status => v_status
    );
    DBMS_OUTPUT.PUT_LINE('Status rezerwacji: ' || v_status);
END;
/


BEGIN
    pkg_reservation_management.generate_user_reservations_report(3);
END;
/

DECLARE
    v_status VARCHAR2(100);
BEGIN
    pkg_reservation_management.cancel_reservation(
        p_reservation_id => 1,
        p_status => v_status
    );
    DBMS_OUTPUT.PUT_LINE('Status anulowania: ' || v_status);
END;
/
DECLARE
    v_status VARCHAR2(100);
BEGIN
    pkg_reservation_management.create_reservation(
        p_user_id => 1,
        p_package_id => 2,
        p_reservation_date => SYSDATE,
        p_status => v_status
    );
    DBMS_OUTPUT.PUT_LINE('Status rezerwacji: ' || v_status);
END;
/
-- Przykład próby utworzenia rezerwacji dla niedostępnej oferty
DECLARE
    v_status VARCHAR2(100);
BEGIN
    pkg_reservation_management.create_reservation(
        p_user_id => 1,
        p_package_id => 999,
        p_status => v_status
    );
    DBMS_OUTPUT.PUT_LINE('Status rezerwacji: ' || v_status);
END;
/

DECLARE
    v_is_available BOOLEAN;
BEGIN
    v_is_available := pkg_reservation_management.check_availability(
        p_package_id => 2,
        p_start_date => TO_DATE('2024-07-15', 'YYYY-MM-DD')
    );
    
    IF v_is_available THEN
        DBMS_OUTPUT.PUT_LINE('Oferta jest dostępna');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Oferta nie jest dostępna');
    END IF;
END;
/



BEGIN
    pkg_reservation_management.generate_user_reservations_report(
        p_user_id => 1 
    );
END;
/



DECLARE
    v_status VARCHAR2(100);
    v_is_available BOOLEAN;
    v_user_id NUMBER := 1;
    v_package_id NUMBER := 2;
BEGIN
    v_is_available := pkg_reservation_management.check_availability(
        p_package_id => v_package_id,
        p_start_date => SYSDATE
    );
    
    IF v_is_available THEN
        pkg_reservation_management.create_reservation(
            p_user_id => v_user_id,
            p_package_id => v_package_id,
            p_status => v_status
        );
        
        IF v_status = 'SUCCESS' THEN
            pkg_reservation_management.generate_user_reservations_report(
                p_user_id => v_user_id
            );
        ELSE
            DBMS_OUTPUT.PUT_LINE('Błąd podczas tworzenia rezerwacji: ' || v_status);
        END IF;
    ELSE
        DBMS_OUTPUT.PUT_LINE('Oferta nie jest dostępna');
    END IF;
END;
/


DECLARE
    v_status VARCHAR2(100);
BEGIN
    pkg_reservation_management.create_reservation(
        p_user_id => 3,
        p_package_id => 1,  
        p_reservation_date => TO_DATE('2024-06-01', 'YYYY-MM-DD'),
        p_status => v_status
    );
    DBMS_OUTPUT.PUT_LINE('Status rezerwacji: ' || v_status);
END;
/


DECLARE
    v_status VARCHAR2(100);
BEGIN
    pkg_reservation_management.create_reservation(
        p_user_id => 6,
        p_package_id => 5,
        p_reservation_date => SYSDATE,
        p_status => v_status
    );
    DBMS_OUTPUT.PUT_LINE('Status rezerwacji: ' || v_status);
END;
/

DECLARE
    v_status VARCHAR2(100);
BEGIN
    pkg_reservation_management.create_reservation(
        p_user_id => 6,
        p_package_id => 999,
        p_status => v_status
    );
    DBMS_OUTPUT.PUT_LINE('Status rezerwacji: ' || v_status);
END;
/

DECLARE
    v_is_available BOOLEAN;
BEGIN
    v_is_available := pkg_reservation_management.check_availability(
        p_package_id => 2,
        p_start_date => TO_DATE('2024-07-15', 'YYYY-MM-DD')
    );
    
    IF v_is_available THEN
        DBMS_OUTPUT.PUT_LINE('Oferta jest dostępna');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Oferta nie jest dostępna');
    END IF;
END;
/



BEGIN
    pkg_reservation_management.generate_user_reservations_report(
        p_user_id => 3
    );
END;
/




DECLARE
    v_status VARCHAR2(100);
    v_is_available BOOLEAN;
    v_user_id NUMBER := 1;
    v_package_id NUMBER := 2;
BEGIN
    v_is_available := pkg_reservation_management.check_availability(
        p_package_id => v_package_id,
        p_start_date => SYSDATE
    );
    
    IF v_is_available THEN
        pkg_reservation_management.create_reservation(
            p_user_id => v_user_id,
            p_package_id => v_package_id,
            p_status => v_status
        );
        
        IF v_status = 'SUCCESS' THEN
            pkg_reservation_management.generate_user_reservations_report(
                p_user_id => v_user_id
            );
        ELSE
            DBMS_OUTPUT.PUT_LINE('Błąd podczas tworzenia rezerwacji: ' || v_status);
        END IF;
    ELSE
        DBMS_OUTPUT.PUT_LINE('Oferta nie jest dostępna');
    END IF;
END;
/



DECLARE
    v_status VARCHAR2(100);
BEGIN
    pkg_reservation_management.create_reservation(
        p_user_id => 3,
        p_package_id => 5,  
        p_reservation_date => TO_DATE('2024-06-06', 'YYYY-MM-DD'),
        p_status => v_status
    );
    DBMS_OUTPUT.PUT_LINE('Status rezerwacji: ' || v_status);
END;
/

SELECT * FROM v_user_reservations_summary;
select * from Kategorie_tab;
