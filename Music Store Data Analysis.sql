/*	Question Set 1 */

/* Q1: Who is the senior most employee based on job title? */

select * from employee
order by levels DESC 
limit 1;

/* Q2: Which countries have the most Invoices? */

Select billing_country,count(*) as TotalCount from invoice
group by billing_country order by TotalCount DESC;

/* Q3: What are top 3 values of total invoice? */

select total from invoice
order by total DESC limit 3;

/* Q4: Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. 
Write a query that returns one city that has the highest sum of invoice totals. 
Return both the city name & sum of all invoice totals */

select billing_city,sum(total) as Total_Amount from invoice
group by billing_city order by Total_Amount DESC limit 1;

/* Q5: Who is the best customer? The customer who has spent the most money will be declared the best customer. 
Write a query that returns the person who has spent the most money.*/

select customer.customer_id, first_name, last_name, sum(total) as total_spending
from customer
join invoice on customer.customer_id = invoice.customer_id
group by customer.customer_id
order by total_spending DESC
LIMIT 1;

/* Another Method(Q5)*/

select first_name,
(select sum(total) from invoice where customer.customer_id=invoice.customer_id) as Total_Amount
from customer group by first_name order by Total_Amount DESC limit 1;

/*	Question Set 2 */

/* Q1: Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
Return your list ordered alphabetically by email starting with A. */

/* Method 1 */

select DISTINCT email,first_name, last_name
from customer
JOIN invoice ON customer.customer_id = invoice.customer_id
JOIN invoice_line ON invoice.invoice_id = invoice_line.invoice_id
where track_id IN(
	select track_id from track
	JOIN genre ON track.genre_id = genre.genre_id
	where genre.name LIKE 'Rock'
)
order by email;

/* Method 2 */

select DISTINCT email as Email,first_name as FirstName, last_name as LastName, genre.name as Name
from customer
JOIN invoice ON invoice.customer_id = customer.customer_id
JOIN invoice_line ON invoice_line.invoice_id = invoice.invoice_id
JOIN track ON track.track_id = invoice_line.track_id
JOIN genre ON genre.genre_id = track.genre_id
where genre.name like 'Rock'
order by email;

/* Q2: Let's invite the artists who have written the most rock music in our dataset. 
Write a query that returns the Artist name and total track count of the top 10 rock bands. */

select artist.artist_id,artist.name,count(artist.artist_id) as TotalTracks from track
join album on album.album_id=track.album_id
join artist on artist.artist_id=album.artist_id
join genre on genre.genre_id=track.genre_id
where genre.name like 'Rock%'
group by artist.artist_id
order by TotalTracks DESC;

/* Q3: Return all the track names that have a song length longer than the average song length. 
Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first. */

select name,milliseconds
from track
where milliseconds>(
		select avg(milliseconds) as AvgLenth 
		from track)
order by milliseconds DESC;
