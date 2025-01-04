--Senior most employee based on job title

SELECT * FROM employee order by levels desc limit 1;

--The countries that have the most Invoices

SELECT COUNT(*) as c, billing_country
from invoice 
group by billing_country
order by c desc;

--top 3 values of total invoices

SELECT total from invoice 
order by total desc
limit 3;

--A company wants to organize a music festival where the city has made the most money;


SELECT SUM(Total) as invoice_total, billing_city
from invoice
group by billing_city
order by invoice_total desc;

-- the best customer(the one who has spent the most money)

SELECT customer.customer_id, customer.first_name, customer.last_name, SUM(invoice.total) AS Total  
FROM customer JOIN invoice on customer.customer_id = invoice.customer_id
group by customer.customer_id
order by total desc 
limit 1;

--return the list of all rock music listeners.
--return the list alphabettically by email starting with A

SELECT DISTINCT email, first_name, last_name
FROM customer
Join invoice ON customer.customer_id = invoice.invoice_id
join invoice_line ON invoice.invoice_id = invoice_line.invoice_id
WHERE track_id IN(
   SELECT track_id FROM track
   JOIN genre ON track.genre_id = genre.genre_id
   WHERE genre.name LIKE 'Rock')
ORDER BY email;

--returns the Artist name and total track count of the top 10 rock bands
SELECT artist.artist_id, artist.name, COUNT(artist.artist_id) as no_of_songs
FROM track
JOIN album ON album.album_id = track.album_id
JOIN artist ON artist.artist_id = album.artist_id
JOIN genre ON genre.genre_id = track.genre_id
WHERE genre.name LIKE 'Rock'
group by artist.artist_id
order by no_of_songs DESC
LIMIT 10;

--LENGTH of songs should be average

SELECT name, milLiseconds 
FROM track WHERE  milLiseconds > (
  SELECT AVG(milliseconds) as avg_track_length
  FROM track
)
ORDER BY milliseconds DESC;

--Amount Spent by each Customers on Artists. Write a query to return customer name, artist name and total spent

WITH best_selling_artist AS(
   SELECT artist.artist_id AS artist_id, artist.name AS artist_name,
   SUM(invoice_line.unit_price*invoice_line.quantity) AS total_sales
   FROM invoice_line
   JOIN track track ON track.track_id = invoice_line.track_id
   JOIN album ON album.album_id = track.album_id
   JOIN artist ON artist.artist_id = album.artist_id
   GROUP BY 1
   ORDER BY 3 DESC
   LIMIT 1
)
SELECT c.customer_id, c.first_name, c.last_name, bsa.artist_name, 
SUM(il.unit_price*il.quantity) AS amount_spent
FROM invoice i
JOIN customer c ON c.customer_id = i.customer_id
JOIN invoice_line il ON il.invoice_id = i.customer_id
JOIN track t ON t.track_id = il.track_id
JOIN album alb ON alb.album_id = t.album_id
JOIN best_selling_artist bsa ON bsa.artist_id = alb.artist_id
GROUP BY 1, 2, 3,4
ORDER BY 5 DESC;





