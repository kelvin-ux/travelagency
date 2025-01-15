@views.sql

select * from Uzytkownicy_tab;
select * from Adresy_tab;
select * from Hotel_tab;




---------------------- Opcja Basic Dziala - advenced nie ma wystarczajacej ilosci danych do testowania

VAR my_cursor REFCURSOR;

EXEC SEARCH_OFFERS_BASIC(4.5, 7, 12, :my_cursor);

PRINT my_cursor;
     
---------------------- Opcja Advanced

VAR my_cursor REFCURSOR;

EXEC search_offers(
    4.5,            -- p_min_rating
    7,              -- p_min_duration
    12,             -- p_max_duration
    'Hiszpania',    -- p_country
    NULL,           -- p_region
    1,              -- p_dla_doroslych
    1,              -- p_allIn
    NULL,           -- p_lastMinute
    3000,           -- p_min_price
    5000,           -- p_max_price
    :my_cursor
);

PRINT my_cursor;

