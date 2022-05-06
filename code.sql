-- to finishing this challenge, I used xampp with MariaDB as a server and DBeaver as a software to compiling the code

-- 10 biggest transaction by user 12476

select seller_id, buyer_id, total as nilai_transaksi, created_at as tanggal_transaksi
from orders_csv oc 
where buyer_id = 12476
order by 3 desc
limit 10

-- transactions per month
select EXTRACT(YEAR_MONTH FROM created_at) as tahun_bulan, count(1) as jumlah_transaksi, sum(total) as total_nilai_transaksi
from orders_csv
where created_at>='2020-01-01'
group by 1
order by 1

-- User with biggest transaction average in January 2020
select buyer_id, count(1) as jumlah_transaksi , avg(total) as avg_nilai_transaksi
from orders_csv
where created_at>='2020-01-01' and created_at<'2020-02-01'
group by 1
having count(1)>=  2
order by 3 desc
limit 10

-- The biggest transactions in December 2019
select nama_user as nama_pembeli, total as nilai_transaksi, created_at as tanggal_transaksi
from orders_csv
inner join users_csv on buyer_id = user_id
where created_at>='2019-12-01' and created_at<'2020-01-01'
and total >= 20000000
order by 1

-- Best Selling Product Category in 2020
select category, sum(quantity) as total_quantity, sum(price) as total_price from orders_csv 
inner join order_details_csv  using(order_id)
inner join products_csv using(product_id)
where created_at>='2020-01-01'
and delivery_at is not null
group by 1
order by 2 desc
limit 5

-- Buyer with high value
select 
nama_user nama_pembeli,
count(1) jumlah_transaksi,
sum(total) total_nilai_transaksi,
min(total) min_nilai_transaksi
from orders_csv
join users_csv on buyer_id=user_id
group by user_id, nama_user
having count(1) > 5 and min(total) > 2000000
order by 3 desc

-- Dropshipper
select
nama_user as nama_pembeli,
count(1) as jumlah_transaksi,
count(distinct orders_csv.kodepos) as distinct_kodepos,
sum(total) as total_nilai_transaksi,
avg(total) as avg_nilai_transaksi
from orders_csv
inner join users_csv on buyer_id = user_id
group by user_id, nama_user
having count(1) >= 10 and count(1)=count(distinct orders_csv.kodepos)
order by 2 desc

-- Offline reseller
select
nama_user as nama_pembeli,
count(1) as jumlah_transaksi,
sum(total) as total_nilai_transaksi,
avg(total) as avg_nilai_transaksi,
avg(total_quantity) as avg_quantity_per_transaksi
from orders_csv
inner join users_csv on buyer_id = user_id
inner join (select order_id, sum(quantity) as total_quantity from order_details_csv group by 1) as summary_order using(order_id)
where orders_csv.kodepos = users_csv.kodepos
group by user_id, nama_user
having count(1) >= 8 and avg(total_quantity) > 10
order by 3 desc

-- Buyer and also Seller
select
nama_user as nama_pengguna,
jumlah_transaksi_beli,
jumlah_transaksi_jual
from users_csv
inner join (select buyer_id, count(1) as jumlah_transaksi_beli from orders_csv group by 1) as buyer on buyer_id = user_id
inner join (select seller_id, count(1) as jumlah_transaksi_jual from orders_csv group by 1) as seller on seller_id = user_id
where jumlah_transaksi_beli >= 7
order by 1

-- Transaction Time Paid
select
extract(year_month from created_at) as tahun_bulan,
count(1) as jumlah_transaksi,
avg(datediff(paid_at, created_at)) as avg_lama_dibayar,
min(datediff(paid_at, created_at)) min_lama_dibayar,
max(datediff(paid_at, created_at)) max_lama_dibayar
from orders_csv
where paid_at is not null
group by 1
order by 1

/* from this analysis, we can get some insight. there are :
1. Buyer id 12476 has the largest transaction value on 23-12-2019 worth 12,014,000. after that date the transaction value of the buyer id has decreased significantly
2. The number of transactions and the total value of transactions have increased significantly in the last 5 months of 2020
3. Buyer id 11140, 7905, 12935 are the top 3 buyers who have the highest average transaction value (above 8,000,000) during January 2020
4. Diah Mahendra is the buyer with the highest transaction value in December 2019
5. Products in the personal hygiene category are the best-selling products in 2020 with a total quantity purchased reaching 944018 and a total price reaching 1.333.153.000
6. R. Tata Nasyidah is the buyer with the highest total transaction value during this e-commerce operation with a total transaction of 25,117,800
7. An active dropshipper who has a number of transactions above 10 times, namely R.M. Setya Waskita and Anastasia Gunarto. R.M Setya Wakita is a dropshipper with the highest transaction value reaching 30,595,000 with an average value per transaction reaching 3,059,500
8. There are also buyers who act as resellers with the characteristics of many orders and the same shipping address as the main address. R. Prima Laksmiwati is a buyer who is also a reseller who has the highest total transaction value reaching 17,269,000 during this e-commerce operation.
9. The average duration of order settlement every month is about 7 days with the longest repayment duration each month being 14 days.
