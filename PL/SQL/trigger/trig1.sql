/* Trigger to update the total amount of user everytime he adds something to payment table*/

CREATE OR REPLACE TRIGGER update_payment_total
AFTER INSERT OR DELETE ON cart_item
FOR EACH ROW
DECLARE
    v_cart_id Cart_item.cart_id%TYPE := :NEW.cart_id;
    v_total_amount Payment.total_amount%TYPE;
BEGIN
    SELECT SUM(p.cost * ci.quantity_wished)
    INTO v_total_amount
    FROM product p
    JOIN cart_item ci ON p.product_id = ci.product_id
    WHERE ci.cart_id = v_cart_id;

    UPDATE payment
    SET total_amount = v_total_amount
    WHERE cart_id = v_cart_id;
END;
/

/*
CREATE OR REPLACE TRIGGER UPDATE_PAYMENT_TOTAL
FOR INSERT ON CART_ITEM
COMPOUND TRIGGER

  -- Declare variables to store the total amount and the cart ID
  total_amount number(6);
  cart_id varchar2(7);

  BEFORE STATEMENT IS
  BEGIN
    -- Reset the total amount and cart ID variables for the new statement
    total_amount := 0;
    cart_id := null;
  END BEFORE STATEMENT;

  BEFORE EACH ROW IS
  BEGIN
    -- Check if the row is purchased, and if so, add the cost to the total amount
    IF :NEW.purchased = 'YES' THEN
      SELECT cost INTO total_amount FROM product WHERE product_id = :NEW.product_id;
    END IF;

    -- Store the cart ID for this row
    cart_id := :NEW.cart_id;
  END BEFORE EACH ROW;

  AFTER STATEMENT IS
  BEGIN
    -- Update the total amount in the payment table for the cart
    UPDATE payment SET total_amount = total_amount WHERE cart_id = cart_id;
  END AFTER STATEMENT;

END UPDATE_PAYMENT_TOTAL;
/
*/
