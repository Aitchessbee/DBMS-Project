select count(product_id) count_pid,date_added from Cart_item where purchased='Y'  group by(date_added);