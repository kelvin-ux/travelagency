--TRIGGER SPRAWDZAJ�CY POPRAWNO�� WYSTAWIANIA OCENY PRZEZ U�YTKOWNIKA
CREATE OR REPLACE TRIGGER trg_check_ocena_hoteli
BEFORE INSERT OR UPDATE ON OcenyHoteli_tab
FOR EACH ROW
DECLARE
    v_count NUMBER;
BEGIN
    -- Sprawdzenie, czy u�ytkownik ma zako�czon� rezerwacj� na dany hotel
    SELECT COUNT(*)
    INTO v_count
    FROM Rezerwacje_tab r
    JOIN OfertyWakacyjne_tab o ON r.ref_oferta = REF(o)
    WHERE r.ref_uzytkownik = :NEW.ref_uzytkownik
      AND o.ref_hotel = :NEW.ref_hotel
      AND o.endDate < SYSDATE;
      
    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'U�ytkownik musi mie� zako�czon� rezerwacj� na ten hotel, aby wystawi� ocen�.');
    END IF;
END;
/


------

CREATE OR REPLACE TRIGGER trg_update_price_after_promotion
AFTER INSERT OR UPDATE ON Promocje_tab
FOR EACH ROW
DECLARE
    v_offer OfertyWakacyjne_typ;
    v_new_price NUMBER;
BEGIN

    SELECT VALUE(o) INTO v_offer
    FROM OfertyWakacyjne_tab o
    WHERE REF(o) = :NEW.ref_package;
    v_new_price := v_offer.original_price * (1 - :NEW.discount/100);
    
    DBMS_OUTPUT.PUT_LINE('Oryginalna cena: ' || v_offer.original_price);
    DBMS_OUTPUT.PUT_LINE('Zniżka: ' || :NEW.discount || '%');
    DBMS_OUTPUT.PUT_LINE('Nowa cena: ' || v_new_price);
    
    UPDATE OfertyWakacyjne_tab o
    SET o.price = v_new_price
    WHERE o.packID = v_offer.packID;

    DBMS_OUTPUT.PUT_LINE('Aktualizacja zakończona');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Błąd w triggerze: ' || SQLERRM);
        RAISE;
END;
/

CREATE OR REPLACE TRIGGER trg_restore_price_after_promotion_delete
AFTER DELETE ON Promocje_tab
FOR EACH ROW
DECLARE
    v_offer OfertyWakacyjne_typ;
BEGIN

    SELECT VALUE(o) INTO v_offer
    FROM OfertyWakacyjne_tab o
    WHERE REF(o) = :OLD.ref_package;
    
    UPDATE OfertyWakacyjne_tab o
    SET o.price = o.original_price
    WHERE o.packID = v_offer.packID;
    
    DBMS_OUTPUT.PUT_LINE('Przywrócono oryginalną cenę: ' || v_offer.original_price);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Błąd w triggerze przywracania ceny: ' || SQLERRM);
        RAISE;
END;
/

CREATE OR REPLACE TRIGGER trg_set_original_price
BEFORE INSERT ON OfertyWakacyjne_tab
FOR EACH ROW
BEGIN
    :NEW.original_price := :NEW.price;
END;
/

commit;