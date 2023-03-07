
#Step-1 

#Create a stored procedure to display supplier id, name, rating and Type_of_Service. 
# For Type_of_Service, If rating =5, print “Excellent Service”, 
# If rating >4 print “Good Service”, If rating >2 print “Average Service” else print “Poor Service”.

# Create a new procedure using MySQL Workbench
# Name the procedure as get_supplier_rating_info

#Step-2

#Embed the following block of code within the BEGIN and END statements

select report.SUPP_ID as Supplier_ID, report.SUPP_NAME as Supplier_Name, report.AverageRating as Average_Rating,
CASE
WHEN report.AverageRating =5 THEN 'Excellent Service'
WHEN report.AverageRating >4 THEN 'Good Service'
WHEN report.AverageRating >2 THEN 'Average Service'
ELSE 'Poor Service'
END
AS Type_of_Service 
from
(
	select supplier.SUPP_NAME, final.SUPP_ID, final.AverageRating from
	(	
		select sp_orra.SUPP_ID, avg(sp_orra.rat_ratstars) as AverageRating from
		(
			select supplier_pricing.SUPP_ID, orra.ORD_ID, orra.RAT_RATSTARS from supplier_pricing 
            inner join
			(
				select `order`.pricing_id, rating.ORD_ID, rating.RAT_RATSTARS from `order` inner join rating on rating.`ord_id` = `order`.ord_id 
			) 
			as orra
			on orra.pricing_id = supplier_pricing.pricing_id
		)
		as sp_orra 
		group by supplier_pricing.SUPP_ID
	)
	as final 
	inner join 
	supplier 
	where final.SUPP_ID = supplier.SUPP_ID
) 
as report;




#Step-3

#Invoke the procedure using the following statement

call get_supplier_rating_info();