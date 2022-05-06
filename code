-- to finishing this challenge, I used xampp with MariaDB as a server and DBeaver as a software to compiling the code

-- 10 biggest transaction by user 12476

select seller_id, buyer_id, total as nilai_transaksi, created_at as tanggal_transaksi
from orders_csv oc 
where buyer_id = 12476
order by 3 desc
limit 10

