ALTER TABLE Oceny_hoteli_tab
ADD CONSTRAINT chk_ocena_wartosc
CHECK (ocena.wartosc BETWEEN 1 AND 5);


ALTER TABLE OfertyWakacyjne_tab
ADD CONSTRAINT chk_price_positive
CHECK (price > 0);

ALTER TABLE OfertyWakacyjne_tab
ADD CONSTRAINT chk_date_order
CHECK (endDate > startDate);

ALTER TABLE OfertyWakacyjne_tab
ADD CONSTRAINT chk_duration_positive
CHECK (duration > 0);

ALTER TABLE Hotel_tab
ADD CONSTRAINT chk_dla_doroslych
CHECK (dla_doroslych IN (0, 1));

ALTER TABLE Kategorie_tab
ADD CONSTRAINT chk_allIn
CHECK (allIn IN (0, 1));

ALTER TABLE Kategorie_tab
ADD CONSTRAINT chk_lastMinute
CHECK (lastMinute IN (0, 1));

ALTER TABLE Hotel_tab
ADD CONSTRAINT chk_hotel_country_not_null
CHECK (kraj IS NOT NULL);

ALTER TABLE Hotel_tab
ADD CONSTRAINT chk_opisdestynacja_country_not_null
CHECK (opis_destynacji.kraj IS NOT NULL);

ALTER TABLE Adresy_tab
ADD CONSTRAINT chk_adres_country_not_null
CHECK (adres.kraj IS NOT NULL);

COMMIT;