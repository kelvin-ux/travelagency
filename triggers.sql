CREATE OR REPLACE TRIGGER trg_check_reservation_date
BEFORE INSERT ON Rezerwacje_tab
FOR EACH ROW
DECLARE
    v_startDate DATE;
    v_endDate   DATE;
BEGIN
    SELECT o.startDate, o.endDate
      INTO v_startDate, v_endDate
      FROM OfertyWakacyjne_tab o
     WHERE REF(o) = :NEW.ref_oferta;

    IF :NEW.data_rezerwacji < v_startDate OR :NEW.data_rezerwacji > v_endDate THEN
        RAISE_APPLICATION_ERROR(-20001, 'Data rezerwacji poza terminem oferty.');
    END IF;
END;
/


CREATE OR REPLACE TRIGGER trg_check_user_age
BEFORE INSERT ON Rezerwacje_tab
FOR EACH ROW
DECLARE
    v_birthdate DATE;
    v_age       NUMBER;
BEGIN
    SELECT u.data_urodzenia 
      INTO v_birthdate 
      FROM Uzytkownicy_tab u 
     WHERE REF(u) = :NEW.ref_uzytkownik;


    v_age := TRUNC(MONTHS_BETWEEN(SYSDATE, v_birthdate) / 12);

    IF v_age < 18 THEN
      RAISE_APPLICATION_ERROR(-20002, 'Użytkownik musi mieć co najmniej 18 lat, aby dokonać rezerwacji.');
    END IF;
END;
/


CREATE OR REPLACE TRIGGER trg_check_rating_date
BEFORE INSERT ON Oceny_hoteli_tab
FOR EACH ROW
DECLARE
    v_endDate DATE;
BEGIN
    SELECT o.endDate 
      INTO v_endDate
      FROM OfertyWakacyjne_tab o
     WHERE REF(o) = :NEW.ref_oferta;

    IF SYSDATE <= v_endDate THEN
       RAISE_APPLICATION_ERROR(-20003, 'Ocena może być dodana dopiero po zakończonej podróży.');
    END IF;
END;
/