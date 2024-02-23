# SQL_Movies

## Table of Contents

* [Problem Statement](#problem-statement)
* [Data Sourcing](#data-sourcing)
* [Data Presentation](#data-presentation)
* [Data Analysis](#data-analysis)
* [Insights](#insights)

### Problem Statement

The purpose of this analysis is to provide data information about our 
movie rental bussiness to a potential byer of the company.

About:
* Staff
* Inventory
* Customers
* Investors & Board of Advisors
* Film range and replacement cost


### Data Sourcing

The Dataset used for this analysis come from [MavenAnalytics](https://www.mavenanalytics.io/data-playground) and are available in the file above.

### Data Presentation
The Dataset has 19 tables, with 599 customers, 4581 inventory items and 1000 films.
Data Cleaning was done already.
Follows the EER Diagram with primary and foreign keys.

#### Data Schema - EER Diagram

![Schema](https://github.com/RoulaNtinou/SQL_Movies/blob/06524c9968248cda040d48f3f9cff18a75351912/DataSchema.png)



### Data Analysis


1. We will need a list of **all staff members**, including their first and last names, 
email addresses, and the store identification number where they work. 


``` sql
Select 
    staff_id, 
    first_name , 
    last_name,
    email, 
    store_id
From staff;
```

| staff_id   | first_name    | last_name  |  email                        |  store_id |
| ---------  |:-------------:| -----:     | --------------------------:   | -----:    |
| 1          | Mick          | Hillyer    | Mike.Hillyer@sakilastaff.com  |  1        |
| 2          | Jon           | Stephens   | Jon.Stephens@sakilastaff.com  |  2        |




2.	We will need separate counts of **inventory items** held at each of your two stores. 
``` sql
Select 
    store_id, 
    count(inventory_id) As 'Inventory Items'
From inventory
Group by store_id
Order by store_id;
```
| store_id   | Inventory Items    | 
| ---------  |:-------------:     |
| 1          | 2270               |
| 2          | 2311               |

> Store 1 holds slightly more inventory items compared to store 2.


3.	We will need a count of **active customers** for each of your stores. Separately, please. 

``` sql
Select 
     store_id, 
     count(customer_id) as 'Active customers'
From customer
Where active=1
Group by store_id;
```

| store_id   | Active customers   | 
| ---------  |:-------------:     |
| 1          | 318                |
| 2          | 266                |

>Store 1 also has more active customers than store 2, which might indicate higher foot traffic or better engagement strategies.

4.	In order to assess the liability of a data breach, we will need you to provide a count 
of all customer **email addresses** stored in the database. 
``` sql
Select 
      count(email) as 'Number of emails'
From customer;
```

> Numeber of emails : 599




5.	We are interested in how diverse your film offering is as a means of understanding how likely 
you are to keep customers engaged in the future. Please provide a count of **unique film titles** 
you have in inventory at each store and then provide a count of the unique categories of films you provide. 

``` sql
Select 
     store_id, 
     count(distinct film_id) as 'Unique films'
From inventory
Group by store_id;


Select 
     count(distinct name) as 'Categories'
From category;
```

| store_id   | Unique films   | 
| ---------  |:-------------: |
| 1          | 792            |
| 2          | 769            |

> * Both stores offer a wide range of unique films, with store 1 having 792 unique titles and store 2 having 769.
> * The number of categories is 16.
>   The presence of 16 unique film categories suggests a diverse selection, catering to different tastes and preferences.


6.	We would like to understand the **replacement cost** of your films. 
Please provide the replacement cost for the film that is least expensive to replace, 
the most expensive to replace, and the average of all films you carry. ``	
``` sql
Select 
       avg(replacement_cost) As 'Avg Replacement Cost',
       min(replacement_cost) As 'Min Replacement Cost',
       max(replacement_cost) As 'Max Replacement Cost'
from film;
```
 

> Avg Replacement Cost        19.984   
> Min Replacement Cost         9.99     
> Max Replacement Cost        29.99      


7.	We are interested in having you put **payment** monitoring systems and maximum payment 
processing restrictions in place in order to minimize the future risk of fraud by your staff. 
Please provide the average payment you process, as well as the maximum payment you have processed.
``` sql

Select 
     avg(amount), 
     max(amount)
From payment;
```
> The average payment processed is $4.20, with the maximum payment being $11.99.




8.	We would like to better understand what your customer base looks like. 
Please provide a list of all customer identification values, with a count of **rentals** 
they have made all-time, with your highest volume customers at the top of the list.
``` sql
Select 
     customer_id,count(rental_id) As 'total rentals'
From rental
Group by customer_id
Order by count(rental_id) desc
```
| customer_id   | Total Rentals   | 
| ------------  |:-------------:  |
| 148           | 46              |
| 526           | 45              |
| 144           | 42              |
| 236           | 42              |
| 75            | 41              |

> The highest total rentals per customer is 46 from customer with id 148.



9. We want to come by each of the stores in person and meet the **managers**. 
Please send over the managers’ names at each store, with the full address 
of each property (street address, district, city, and country please). 
 

``` sql
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
```
> The managers at each store are: 

| first_name    | last_name  |  address              |  district | City       |  Country  |
|:-------------:| -----:     | ------------------:   | -----:    | -----:     | -----:    |
| Mick          | Hillyer    | 23 Workhaven Lane     | Alberta   | Lethbridge | Canada    |
| Jon           | Stephens   | 1411 Lillydale Drive  | QLD       | Woodridge  | Australia |



10.	I would like to get a better **understanding of all of the inventory** that would come along with the business. 
Please pull together a list of each inventory item you have stocked, including the store_id number, 
the inventory_id, the name of the film, the film’s rating, its rental rate and replacement cost. 

``` sql
Select  
	  inventory.store_id,
    inventory.inventory_id, 
    title, 
    rating,
    rental_rate, 
    replacement_cost
From inventory
Left Join film ON inventory.film_id= film.film_id;
```

> All the inventory items with the rating, rental rate  and replacemnt cost

| store_id | inventory_id |  title            | rating  | rental_rate |  replacement_cost |
|:--------:| --------:    | -----------:      | ------: | --------:   |   -----------:    |
|  1       | 1            |  ACADEMY DINOSAUR | PG      |  0.99       |  20.99            |
|  1       | 2            |  ACADEMY DINOSAUR | PG      |  0.99       |  20.99            |
|  1       | 3            |  ACADEMY DINOSAUR | PG      |  0.99       |  20.99            |
|  1       | 4            |  ACADEMY DINOSAUR | PG      |  0.99       |  20.99            |
|  1       | 16           |  AFFAIR PREJUDICE | G       |  2.99       |  26.99            |
|  1       | 17           |  AFFAIR PREJUDICE | G       |  2.99       |  26.99            |





11.	From the same list of films you just pulled, please roll that data up and provide a summary level overview 
of your inventory. We would like to know how many inventory items you have with each **rating** at each store. 

``` sql
Select  
    store_id, 
    rating,
    count(inventory_id) As 'Number of inventory items'
From inventory
Left Join film ON inventory.film_id= film.film_id
Group by store_id, rating;
```

> All the inventory items per rating at each store.

| store_id   | rating  | Inventory items  |  
| ---------  |:-------:| -----------:     | 
| 1          | PG      | 444              | 
| 1          | G       | 394              | 
| 1          | PG-13   | 525              | 
| 1          | NC-17   | 465              |
| 1          | R       | 442              | 
| 2          | PG      | 480              |
| 2          | G       | 397              |
| 2          | PG-13   | 479              |
| 2          | NC-17   | 493              |
| 2          | R       | 462              |

>  It's evident that both stores offer a similar range of movies across different ratings, with some variations in the quantity of items per rating category.
 
12. Similarly, we want to understand how diversified the inventory is in terms of **replacement cost**. We want to 
see how big of a hit it would be if a certain category of film became unpopular at a certain store.
We would like to see the number of films, as well as the average replacement cost, and total replacement cost, 
sliced by store and film category. 

``` sql
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
Order by store_id, Sum(replacement_cost) desc;
```

> All the items at each store per film category and in ascending order according to the total replacement cost.

| store_id | category     |  Number of films | Avg replacement cost  | total replacement_cost |
|:--------:| --------:    | -----------:     | -------------------:  | -----------------:     |
|  1       | Action       |  169             | 21.19                 |  3581.31               |
|  1       | Drama        |  162             | 21.93                 |  3553.38               |
|  1       | Sports       |  163             | 20.58                 |  3354.37               |
|  1       | Animation    |  161             | 20.39                 |  3282.39               |
|  1       | Sci-Fi       |  149             | 21.79                 |  3247.51               |
|  1       | Family       |  157             | 20.54                 |  3224.43               |
|  1       | New          |  148             | 19.27                 |  2851.52               |
|  1       | Foreign      |  153             | 18.56                 |  2839.47               |
|  1       | Comedy       |  142             | 19.44                 |  2760.58               |
|  1       | Games        |  128             | 21.13                 |  2704.72               |
|  1       | Classics     |  131             | 20.61                 |  2700.69               |
|  1       | Documentary  |  130             | 20.73                 |  2694.70               |
|  1       | Children     |  129             | 19.99                 |  2578.71               |
|  1       | Music        |  122             | 19.28                 |  2352.78               |
|  1       | Travel       |  114             | 19.88                 |  2266.86               |
|  1       | Horror       |  112             | 19.75                 |  2211.88               |
|  2       | Sports       |  181             | 20.70                 |  3746.19               |
|  2       | Animation    |  174             | 19.99                 |  3479.26               |
|  2       | Documentary  |  164             | 20.54                 |  3369.36               |
|  2       | Sci-Fi       |  163             | 20.49                 |  3340.37               |
|  2       | Action       |  143             | 21.50                 |  3074.57               |
|  2       | Games        |  148             | 20.77                 |  3074.52               |
|  2       | Family       |  153             | 19.51                 |  2985.47               |
|  2       | Drama        |  138             | 21.46                 |  2961.62               |
|  2       | Classics     |  139             | 21.29                 |  2959.61               |
|  2       | Foreign      |  147             | 18.63                 |  2739.53               |
|  2       | Children     |  140             | 19.50                 |  2730.60               |
|  2       | Horror       |  136             | 19.56                 |  2660.64               |
|  2       | New          |  127             | 20.03                 |  2543.73               |
|  2       | Comedy       |  127             | 18.87                 |  2396.73               |
|  2       | Travel       |  121             | 18.71                 |  2263.79               |
|  2       | Music        |  110             | 18.99                 |  2089.90               |

>This breakdown allows for a better understanding of the replacement cost distribution across different film categories at each store.
> It also provides insights into the potential financial impact if a particular category were to become unpopular at a certain store.


13.	We want to make sure you folks have a good handle on **who your customers are**. Please provide a list 
of all customer names, which store they go to, whether or not they are currently active, 
and their full addresses – street address, city, and country. 


``` sql
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
```

> All the customers with their full addresses.

| first_name | last_name   | store_id | active |      address           | city        |   country   |
|:--------:  | --------:   | -----:   | ----:  | -----------------:     | --------:   |----------:  |
| MARY       | SMITH       |  1       | 1      |  1913 Hanoi Way        | Sasebo      | Japan       | 
 
> **There is a big variety in the origin of customers**



14.	We would like to understand how much your **customers are spending** with you, and also to know 
who your most valuable customers are. Please pull together a list of customer names, their total 
lifetime rentals, and the sum of all payments you have collected from them. It would be great to 
see this ordered on total lifetime value, with the most valuable customers at the top of the list. 

``` sql
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
```

| first_name | last_name |  total rentals            | total amount paid |
|:--------:| --------:    | -----------:      | ------: |
|  1       | 1            |  ACADEMY DINOSAUR | PG      |  
|  1       | 2            |  ACADEMY DINOSAUR | PG      | 
|  1       | 3            |  ACADEMY DINOSAUR | PG      | 
|  1       | 4            |  ACADEMY DINOSAUR | PG      | 
|  1       | 16           |  AFFAIR PREJUDICE | G       | 
|  1       | 17           |  AFFAIR PREJUDICE | G       | 

>  The 599 customers have paid from 50 to 221 USD so far.





15. My partner and I would like to get to know your **board of advisors and any current investors**.
Could you please provide a list of advisor and investor names in one table? 
Could you please note whether they are an investor or an advisor, and for the investors, 
it would be good to include which company they work with. 

``` sql
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
```

| type          | first_name  |  last_name     | company_name           |
|:-------------:| -----:      | -----------:   | --------------:        |
|  Advisor      | Barry       |  Beenthere     | Board of Advisors      | 
|  Advisor      | Cindy       |  Smartypants   | Board of Advisors      |
|  Advisor      | Mary        |  Moneybags     | Board of Advisors      |
|  Advisor      | Walter      |  White         | Board of Advisors      |
|  Investor     | Montgomery  |  Burns         | Springfield Syndicators|
|  Investor     | Anthony     |  Stark         | Iron Investors         |
|  Investor     | William     |  Wonka         | Chocolate Ventures     |



16. We're interested in how well you have covered the **most-awarded actors**. 
Of all the actors with three types of awards, for what % of them do we carry a film?
And how about for actors with two types of awards? Same questions. 
Finally, how about actors with just one award? 




``` sql
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
```

| Number of Awards  | % of Actors with Awards   | 
| :-------------:   | :----------------------:  |
| Three Awards      | 0.5714                    |
| Two Awards        | 0.9242                    |
| One Awards        | 0.8333                    |



### Insights

