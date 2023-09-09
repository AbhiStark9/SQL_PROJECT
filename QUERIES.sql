SELECT * FROM employee
ORDER BY levels desc
limit 1;


SELECT COUNT(*) AS cnt, billing_country
FROM invoice
GROUP BY billing_country
ORDER BY cnt DESC;


SELECT total FROM invoice
ORDER BY total DESC
limit 3;

SELECT SUM(total) as invoice_ttl, billing_city
FROM invoice
GROUP BY billing_city
ORDER BY invoice_ttl DESC
limit 1;

SELECT customer.customer_id, customer.first_name, customer.last_name, SUM(invoice.total) AS Total
FROM customer
JOIN invoice ON customer.customer_id = invoice.customer_id
GROUP BY customer.customer_id
ORDER BY Total DESC
limit 1;


SELECT DISTINCT email, first_name, last_name FROM customer
JOIN invoice ON customer.customer_id = invoice.customer_id
JOIN invoice_line ON invoice.invoice_id = invoice_line.invoice_id
WHERE track_id IN(
	SELECT track_id FROM track
	JOIN genre
	ON track.genre_id = genre.genre_id
	WHERE genre.name LIKE 'Rock'
	)
ORDER BY email


SELECT artist.artist_id, artist.name, COUNT(artist.artist_id) AS Nums_of_songs
FROM track
JOIN album ON album.album_id = track.album_id
JOIN artist ON artist.artist_id = album.artist_id
JOIN genre ON genre.genre_id = track.genre_id
WHERE genre.name LIKE 'Rock'
GROUP BY artist.artist_id
ORDER BY Nums_of_songs DESC
LIMIT 10;

SELECT name , milliseconds FROM track
WHERE milliseconds > (
	SELECT AVG(milliseconds) AS avg_track_duration FROM track
)
ORDER BY milliseconds DESC;


WITH best_selling_artist AS (
	SELECT artist.artist_id, artist.name AS artist_name, SUM(invoice_line.unit_price*invoice_line.quantity) AS total_sales FROM invoice_line
	JOIN track ON track.track_id = invoice_line.track_id
	JOIN album ON album.album_id = track.album_id
	JOIN artist ON artist.artist_id = album.artist_id
	GROUP BY 1
	ORDER BY 3 DESC 
	limit 1
)

SELECT cus.customer_id, cus.first_name, cus.last_name, bsa.artist_name, SUM(invl.unit_price*invl.quantity) AS money_spent
FROM invoice inv 
JOIN customer cus ON cus.customer_id = inv.customer_id
JOIN invoice_line invl ON invl.invoice_id = inv.invoice_id
JOIN track tr ON tr.track_id = invl.track_id
JOIN album alb ON alb.album_id = tr.album_id
JOIN best_selling_artist bsa ON bsa.artist_id = alb.artist_id
GROUP BY 1,2,3,4
ORDER BY 5 DESC;



