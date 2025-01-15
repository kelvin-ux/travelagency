CREATE OR REPLACE PROCEDURE SEARCH_OFFERS_BASIC(
    p_min_rating    IN NUMBER,
    p_min_duration  IN NUMBER,
    p_max_duration  IN NUMBER,
    p_rc            OUT SYS_REFCURSOR
)
IS
BEGIN
    OPEN p_rc FOR
        SELECT
            ow.packID          AS id_oferty,
            ow.opis_pakietu    AS opis,
            ow.price           AS cena,
            ow.duration        AS liczba_dni,
            h.hotelID          AS id_hotelu,
            oh.ocena.wartosc   AS ocena_ogolna
        FROM OfertyWakacyjne_tab ow
             JOIN Hotel_tab h
               ON REF(h) = ow.ref_hotel
             JOIN Oceny_hoteli_tab oh
               ON oh.ocena_id = h.ocenaId
        WHERE oh.ocena.wartosc > p_min_rating
          AND ow.duration > p_min_duration
          AND ow.duration < p_max_duration;
END;
/


CREATE OR REPLACE PROCEDURE search_offers(
    p_min_rating     IN NUMBER   DEFAULT NULL,
    p_min_duration   IN NUMBER   DEFAULT NULL,
    p_max_duration   IN NUMBER   DEFAULT NULL,
    p_country        IN VARCHAR2 DEFAULT NULL,
    p_region         IN VARCHAR2 DEFAULT NULL,
    p_dla_doroslych  IN NUMBER   DEFAULT NULL,
    p_allIn          IN NUMBER   DEFAULT NULL,
    p_lastMinute     IN NUMBER   DEFAULT NULL,
    p_min_price      IN NUMBER   DEFAULT NULL,  
    p_max_price      IN NUMBER   DEFAULT NULL,  
    p_rc             OUT SYS_REFCURSOR
)
IS
BEGIN
    OPEN p_rc FOR
        SELECT
            ow.packID          AS id_oferty,
            ow.opis_pakietu    AS opis,
            ow.price           AS cena,
            ow.duration        AS liczba_dni,
            h.hotelID          AS id_hotelu,
            h.kraj             AS kraj,
            h.region           AS region,
            h.dla_doroslych    AS dla_doroslych,
            k.allIn            AS all_in,
            k.lastMinute       AS last_minute,
            oh.ocena.wartosc   AS ocena_ogolna
        FROM OfertyWakacyjne_tab ow
        JOIN Hotel_tab h
          ON REF(h) = ow.ref_hotel
        JOIN Oceny_hoteli_tab oh
          ON oh.ocena_id = h.ocenaId
        JOIN Kategorie_tab k
          ON REF(k) = ow.ref_cat
        WHERE oh.ocena.wartosc > p_min_rating
          AND ow.duration > p_min_duration
          AND ow.duration < p_max_duration
          AND (p_country IS NULL OR h.kraj = p_country)
          AND (p_region IS NULL OR h.region = p_region)
          AND (p_dla_doroslych IS NULL OR h.dla_doroslych = p_dla_doroslych)
          AND (p_allIn IS NULL OR k.allIn = p_allIn)
          AND (p_lastMinute IS NULL OR k.lastMinute = p_lastMinute)
          AND (p_min_price IS NULL OR ow.price >= p_min_price)
          AND (p_max_price IS NULL OR ow.price <= p_max_price);
END;
/
COMMIT;


