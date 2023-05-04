use mavenmovies;

/*
1.	We will need a list of all staff members, including their first and last names, 
email addresses, and the store identification number where they work. 
*/ 
Select 
   staff_id, 
   first_name, 
   last_name,email, 
   store_id
From staff;

/*
2.	We will need separate counts of inventory items held at each of your two stores. 
*/ 
Select 
      store_id, 
      count(inventory_id) As 'Inventory Items'
From inventory
Group by store_id
Order by store_id;


/*
3.	We will need a count of active customers for each of your stores. Separately, please. 
*/

Select 
      store_id, 
      count(customer_id) as 'Active customers'
From customer
Where active=1
Group by store_id;


/*
4.	In order to assess the liability of a data breach, we will need you to provide a count 
of all customer email addresses stored in the database. 
*/
Select 
     count(email) as 'Number of emails'
From customer;



/*
5.	We are interested in how diverse your film offering is as a means of understanding how likely 
you are to keep customers engaged in the future. Please provide a count of unique film titles 
you have in inventory at each store and then provide a count of the unique categories of films you provide. 
*/

Select 
     store_id, 
     count(distinct film_id) as 'Unique films'
From inventory
Group by store_id;


Select 
      count(distinct name) as 'Categories'
From category;









/*
6.	We would like to understand the replacement cost of your films. 
Please provide the replacement cost for the film that is least expensive to replace, 
the most expensive to replace, and the average of all films you carry. ``	
*/
Select 
       avg(replacement_cost) As 'Avg Replacement Cost',
       min(replacement_cost) As 'Min Replacement Cost',
       max(replacement_cost) As 'Max Replacement Cost'
From film;



/*
7.	We are interested in having you put payment monitoring systems and maximum payment 
processing restrictions in place in order to minimize the future risk of fraud by your staff. 
Please provide the average payment you process, as well as the maximum payment you have processed.
*/
Select 
     avg(amount), 
     max(amount)
From payment;




/*
8.	We would like to better understand what your customer base looks like. 
Please provide a list of all customer identification values, with a count of rentals 
they have made all-time, with your highest volume customers at the top of the list.
*/
Select 
      customer_id,
      count(rental_id) As 'total rentals'
From rental
Group by customer_id
Order by count(rental_id) desc;


/* 
9. My partner and I want to come by each of the stores in person and meet the managers. 
Please send over the managers’ names at each store, with the full address 
of each property (street address, district, city, and country please). 
 
*/ 

Select  
     first_name, 
     last_name, 
     address, 
     district, 
     city, 
     country
From store
Left Join staff ON store.manager_staff_id=staff.staff_id
Left Join address ON staff.address_id=address.address_id
Left Join city ON address.city_id= city.city_id
Left Join country ON city.country_id= country.country_id;




	
/*
10.	I would like to get a better understanding of all of the inventory that would come along with the business. 
Please pull together a list of each inventory item you have stocked, including the store_id number, 
the inventory_id, the name of the film, the film’s rating, its rental rate and replacement cost. 
*/
Select  
	inventory.store_id,
    inventory.inventory_id, 
    title, 
    rating,
    rental_rate, 
    replacement_cost
From inventory
Left Join film ON inventory.film_id= film.film_id;






/* 
11.	From the same list of films you just pulled, please roll that data up and provide a summary level overview 
of your inventory. We would like to know how many inventory items you have with each rating at each store. 
*/

Select  
    store_id, 
    rating,
    count(inventory_id) As 'Number of inventory items'
From inventory
Left Join film ON inventory.film_id= film.film_id
Group by store_id, rating;


/* 
12. Similarly, we want to understand how diversified the inventory is in terms of replacement cost. We want to 
see how big of a hit it would be if a certain category of film became unpopular at a certain store.
We would like to see the number of films, as well as the average replacement cost, and total replacement cost, 
sliced by store and film category. 
*/ 

Select 
      store_id,
      category.name As 'Category', 
      count(inventory.inventory_id) As 'Number of films', 
      avg(replacement_cost) As 'Average replacement cost',
	  Sum(replacement_cost) As 'Total replacement cost'
From inventory
Left Join film ON film.film_id=inventory.film_id
Left Join film_category ON film.film_id=film_category.film_id
Left Join category ON film_category.category_id=category.category_id

Group by store_id, name
Order by Sum(replacement_cost) desc;




/*
13.	We want to make sure you folks have a good handle on who your customers are. Please provide a list 
of all customer names, which store they go to, whether or not they are currently active, 
and their full addresses – street address, city, and country. 
*/
Select 
     first_name, 
     last_name, 
     store_id, 
     active, 
     address, 
     city, 
     country
From customer
Left Join address ON customer.address_id=address.address_id
Left Join city ON address.city_id= city.city_id
Left Join country ON city.country_id=country.country_id;






/*
14.	We would like to understand how much your customers are spending with you, and also to know 
who your most valuable customers are. Please pull together a list of customer names, their total 
lifetime rentals, and the sum of all payments you have collected from them. It would be great to 
see this ordered on total lifetime value, with the most valuable customers at the top of the list. 
*/

Select 
     first_name, 
     last_name, 
     count(rental.rental_id) As 'Total rentals', 
     sum(amount) As 'Total Amount'
From customer
Left join rental ON customer.customer_id= rental.customer_id
Left join payment ON rental.rental_id= payment.rental_id
Group by customer.customer_id
Order by  sum(amount) desc;







/*
15. My partner and I would like to get to know your board of advisors and any current investors.
Could you please provide a list of advisor and investor names in one table? 
Could you please note whether they are an investor or an advisor, and for the investors, 
it would be good to include which company they work with. 
*/
Select 
     'Advisor' As type, 
     first_name, 
     last_name, 
     'Board of Advisors' As 'Company Name'
From advisor
 
 Union
 
Select 
     'Investor' As type, 
     first_name, 
     last_name, 
     company_name
From investor;







/*
16. We're interested in how well you have covered the most-awarded actors. 
Of all the actors with three types of awards, for what % of them do we carry a film?
And how about for actors with two types of awards? Same questions. 
Finally, how about actors with just one award? 
*/




Select 
   Case 
      When actor_award.awards like '%,%,%' Then 'Three Awards'
      When actor_award.awards like '%,%' Then 'Two Awards'
      Else 'One Award'
	End As 'Number of Awards',
    Avg (Case When actor_award.actor_id IS NULL Then 0 Else 1 END) As '% of Actors with Films'
    From actor_award
    
Group by
     Case 
         When actor_award.awards like '%,%,%' Then 'Three Awards'
         When actor_award.awards like '%,%' Then 'Two Awards'
         Else 'One Award'
	 End; 
    
      

