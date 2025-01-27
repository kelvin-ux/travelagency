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